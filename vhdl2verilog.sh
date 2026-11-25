#!/usr/bin/env bash
# =============================================================================
# vhdl2verilog.sh - convert a VHDL file into ONE Verilog file using Cadence Genus
#
# Usage:
#   vhdl2verilog.sh [options] input.vhd [more.vhd ...]
#
#   Each input .vhd produces exactly one .v file (default: same name, same
#   folder, e.g. rtl/fifo.vhd -> rtl/fifo.v). All Genus scratch files go to a
#   temporary directory that is deleted afterwards.
#
# Options:
#   -o, --output FILE     output .v file (only with a single input file)
#   -O, --outdir DIR      write outputs into DIR instead of next to the inputs
#   -t, --top NAME        top-level entity (default: auto-detected)
#   -g, --generic N=V     override a top-level generic, repeatable (-g WIDTH=16)
#   -d, --dep FILE        extra VHDL file needed to elaborate (package or
#                         sub-entity), repeatable; read before the input, not
#                         converted on its own (its entities still end up in
#                         the output if they are instantiated)
#   -l, --lib FILE        Liberty file: synthesize and map to its cells
#                         (default: no mapping, generic gates)
#       --vhdl2008        parse as VHDL-2008 (default: VHDL-1993)
#       --flat            flatten the hierarchy into a single module
#   -k, --keep            keep the Genus work directory (for debugging)
#   -q, --quiet           only print errors
#   -h, --help            show this help
#
# Environment (all optional):
#   VHDL2V_MODULE         environment module to load for Genus and its license
#                         (default: cadence; set it empty to skip loading)
#   GENUS                 path to the genus executable
#   LM_LICENSE_FILE /     license servers, if no module sets them
#   CDS_LIC_FILE
# =============================================================================
set -euo pipefail

# ---- Site defaults (edit for another site) ----------------------------------
CADENCE_MODULE="${VHDL2V_MODULE-cadence}"
# Tried in order until one defines 'module'. (OpenHPC's lmod.sh does nothing
# inside a Slurm job, so modules.sh must come first.)
LMOD_INIT=(/etc/profile.d/modules.sh /usr/share/lmod/lmod/init/bash /etc/profile.d/lmod.sh)
SEARCH_GLOBS=(/opt/cadence/DDI*/bin/genus /opt/cadence/GENUS*/bin/genus
              /opt/cadence/*/GENUS*/bin/genus /tools/cadence/*/bin/genus)

PROG="$(basename "$0")"
usage() { sed -n '3,/^# =====*$/p' "$0" | sed '$d; s/^# \{0,1\}//'; exit "${1:-0}"; }
die()   { echo "$PROG: error: $*" >&2; exit 1; }
say()   { [[ $QUIET -eq 1 ]] || echo "$@"; }
abspath() { (cd "$(dirname "$1")" && echo "$(pwd)/$(basename "$1")"); }

# ---- Arguments --------------------------------------------------------------
OUTPUT="" OUTDIR="" TOP="" LIB="" VHDL2008=0 FLAT=0 KEEP=0 QUIET=0
GENERICS=() DEPS=() INPUTS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -o|--output)  OUTPUT="${2:?missing value for $1}"; shift 2 ;;
    -O|--outdir)  OUTDIR="${2:?missing value for $1}"; shift 2 ;;
    -t|--top)     TOP="${2:?missing value for $1}"; shift 2 ;;
    -g|--generic) GENERICS+=("${2:?missing value for $1}"); shift 2 ;;
    -d|--dep)     DEPS+=("${2:?missing value for $1}"); shift 2 ;;
    -l|--lib)     LIB="${2:?missing value for $1}"; shift 2 ;;
    --vhdl2008)   VHDL2008=1; shift ;;
    --flat)       FLAT=1; shift ;;
    -k|--keep)    KEEP=1; shift ;;
    -q|--quiet)   QUIET=1; shift ;;
    -h|--help)    usage 0 ;;
    --)           shift; INPUTS+=("$@"); break ;;
    -*)           die "unknown option '$1' (see --help)" ;;
    *)            INPUTS+=("$1"); shift ;;
  esac
done

[[ ${#INPUTS[@]} -gt 0 ]] || usage 1
[[ -z "$OUTPUT" || ${#INPUTS[@]} -eq 1 ]] || die "-o/--output needs exactly one input file (use -O DIR for several)"
for f in "${INPUTS[@]}" "${DEPS[@]+"${DEPS[@]}"}"; do [[ -f "$f" ]] || die "file not found: $f"; done
[[ -z "$LIB" || -f "$LIB" ]] || die "liberty file not found: $LIB"
for g in "${GENERICS[@]+"${GENERICS[@]}"}"; do [[ "$g" == *=* ]] || die "generic must be NAME=VALUE, got '$g'"; done
[[ -z "$OUTDIR" ]] || mkdir -p "$OUTDIR"

# ---- Load the Cadence module (sets PATH and the license servers) -------------
MODULE_LOADED=0
load_module() {
  [[ -n "$CADENCE_MODULE" ]] || return 0
  set +eu                      # Lmod's shell code is not written for 'set -eu'
  local f
  for f in "${LMOD_INIT[@]}"; do
    [[ "$(type -t module)" == function ]] && break
    [[ -f "$f" ]] && source "$f" >/dev/null 2>&1
  done
  if [[ "$(type -t module)" == function ]] && module load "$CADENCE_MODULE" >/dev/null 2>&1; then
    MODULE_LOADED=1
  fi
  set -eu
}
load_module

# ---- Locate Genus -----------------------------------------------------------
find_genus() {
  [[ -n "${GENUS:-}" && -x "$GENUS" ]] && { echo "$GENUS"; return; }
  command -v genus 2>/dev/null && return
  for h in "${DDI_HOME:-}" "${GENUS_HOME:-}"; do
    [[ -n "$h" && -x "$h/bin/genus" ]] && { echo "$h/bin/genus"; return; }
  done
  local g; for g in $(printf '%s\n' "${SEARCH_GLOBS[@]}" | sort -rV); do
    [[ -x "$g" ]] && { echo "$g"; return; }
  done
  return 1
}
GENUS_BIN="$(find_genus)" || die "cannot find genus; run on a machine with Cadence installed, set GENUS=/path/to/genus, or check that 'module load ${CADENCE_MODULE:-cadence}' works"

export USER="${USER:-$(id -un)}"   # Genus' startup scripts require $USER
if [[ -z "${LM_LICENSE_FILE:-}${CDS_LIC_FILE:-}" ]]; then
  echo "$PROG: warning: no license server set (LM_LICENSE_FILE / CDS_LIC_FILE); Genus will probably fail to start" >&2
fi

# ---- Helpers ----------------------------------------------------------------
# Minimal Liberty: Genus refuses to elaborate without a library, but for a
# generic (unmapped) netlist its contents do not matter.
write_dummy_lib() {
  cat > "$1" <<'EOF'
library (vhdl2verilog_dummy) {
  delay_model : table_lookup;
  time_unit : "1ns"; voltage_unit : "1V"; current_unit : "1mA";
  capacitive_load_unit (1, pf); pulling_resistance_unit : "1kohm";
  leakage_power_unit : "1nW";
  nom_process : 1; nom_voltage : 1; nom_temperature : 25;
  cell (DUMMY_INV) {
    area : 1;
    pin (A) { direction : input; capacitance : 0.001; }
    pin (Y) { direction : output; function : "!A"; }
  }
}
EOF
}

# Print the entities in a VHDL file that are not instantiated inside that same
# file (= its top level entities), one per line.
detect_tops() {
  local src; src="$(sed -e 's/--.*$//' "$1" | tr '[:upper:]' '[:lower:]' | tr '\n' ' ')"
  local declared e
  declared="$(grep -oE '(^|[^a-z0-9_])entity[[:space:]]+[a-z][a-z0-9_]*[[:space:]]+is([^a-z0-9_]|$)' <<<"$src" \
              | awk '{for(i=1;i<=NF;i++) if($i ~ /entity$/){print $(i+1); break}}')"
  for e in $declared; do
    # entity instantiation: "label : entity lib.e"   component: ": [component] e port/generic map"
    if grep -qE "entity[[:space:]]+[a-z0-9_]+\.${e}([^a-z0-9_]|$)|:[[:space:]]*(component[[:space:]]+)?${e}[[:space:]]+(generic|port)[[:space:]]+map" <<<"$src"; then
      continue
    fi
    echo "$e"
  done
}

tcl_quote() { printf '{%s}' "$1"; }

# ---- Convert one file -------------------------------------------------------
convert() {
  local in="$1" in_abs base out work tcl log tops params="" g f
  in_abs="$(abspath "$in")"
  base="$(basename "${in%.*}")"
  if   [[ -n "$OUTPUT" ]]; then out="$OUTPUT"
  elif [[ -n "$OUTDIR" ]]; then out="$OUTDIR/$base.v"
  else                          out="${in%.*}.v"
  fi
  mkdir -p "$(dirname "$out")"
  out="$(abspath "$out")"

  if [[ -n "$TOP" ]]; then tops="$TOP"; else tops="$(detect_tops "$in" | xargs)"; fi

  work="$(mktemp -d "${TMPDIR:-/tmp}/vhdl2v.XXXXXX")"
  tcl="$work/run.tcl"; log="$work/genus.log"
  [[ -n "$LIB" ]] || write_dummy_lib "$work/dummy.lib"

  for g in "${GENERICS[@]+"${GENERICS[@]}"}"; do params+="{${g%%=*} ${g#*=}} "; done
  local elab="elaborate"
  [[ -z "$params" ]] || elab+=" -parameters {${params% }}"
  [[ -z "$tops" ]]   || elab+=" $tops"
  local libfile="$work/dummy.lib"
  [[ -z "$LIB" ]]    || libfile="$(abspath "$LIB")"

  {
    echo "set_db information_level 1"
    echo "set_db hdl_vhdl_read_version $([[ $VHDL2008 -eq 1 ]] && echo 2008 || echo 1993)"
    echo "set_db hdl_error_on_blackbox true   ;# fail on missing entities instead of leaving black boxes"
    echo "read_libs $(tcl_quote "$libfile")"
    for f in "${DEPS[@]+"${DEPS[@]}"}"; do echo "read_hdl -language vhdl $(tcl_quote "$(abspath "$f")")"; done
    echo "read_hdl -language vhdl $(tcl_quote "$in_abs")"
    echo "$elab"
    echo "check_design -unresolved"
    [[ -z "$LIB" ]] || { echo "syn_generic"; echo "syn_map"; }
    [[ $FLAT -eq 0 ]] || echo "ungroup -all -flatten"
    echo "write_hdl -language v2001 > $(tcl_quote "$work/out.v")"
    echo "exit"
  } > "$tcl"

  say ">> $in -> $out"
  say "   top: ${tops:-<let Genus decide>}   mode: $([[ -n "$LIB" ]] && echo "mapped ($(basename "$LIB"))" || echo generic)$([[ $FLAT -eq 1 ]] && echo ', flat')"

  ( cd "$work" && "$GENUS_BIN" -no_gui -abort_on_error -batch -files "$tcl" ) > "$log" 2>&1 || true

  if grep -qE '^Error' "$log" || [[ ! -s "$work/out.v" ]]; then
    echo "$PROG: FAILED to convert $in" >&2
    local errs; errs="$(grep -E -A3 '^Error' "$log" || true)"
    if [[ -n "$errs" ]]; then echo "$errs" >&2; else tail -n 20 "$log" >&2; fi
    if grep -qE '\[VHDLPT-' <<<"$errs" && [[ $VHDL2008 -eq 0 ]]; then
      echo "$PROG: hint: if the file uses VHDL-2008 syntax, retry with --vhdl2008" >&2
    fi
    if grep -qiE 'black ?box|unresolved|not (been )?(found|defined|analyzed)|unknown (entity|package|library)|could not find' <<<"$errs"; then
      echo "$PROG: hint: missing packages/sub-entities can be added with -d other.vhd" >&2
    fi
    if grep -qiE 'licen[cs]e' "$log"; then
      echo "$PROG: hint: license problem; check 'module load ${CADENCE_MODULE:-cadence}' or set LM_LICENSE_FILE=port@server" >&2
    fi
    echo "$PROG: full log and script kept in $work" >&2
    return 1
  fi

  {
    echo "// Converted from VHDL: $(basename "$in")"
    echo "// Tool: Cadence Genus (vhdl2verilog.sh), $(date '+%Y-%m-%d %H:%M')"
    grep -v -E '^// (Generated (by|on)|Verification Directory)' "$work/out.v"
  } > "$out"

  if [[ $QUIET -eq 0 ]]; then
    echo "   modules: $(grep -oE '^module [A-Za-z_][A-Za-z0-9_$]*' "$out" | awk '!s[$2]++{printf "%s ", $2}')"
    # print each Genus warning (2 lines), skipping LBR-158 (dummy lib) and CDFG-818 (default generics used)
    awk '/^Warning/ { skip = /LBR-158|CDFG-818/; if (!skip) { n++; print "   " $0; getline; print "   " $0 } }
         END { if (!n) print "   no warnings" }' "$log"
  fi

  if [[ $KEEP -eq 1 ]]; then say "   work dir kept: $work"; else rm -rf "$work"; fi
}

# ---- Main -------------------------------------------------------------------
[[ $MODULE_LOADED -eq 0 ]] || say ">> module: $CADENCE_MODULE"
say ">> genus: $GENUS_BIN"
rc=0
for f in "${INPUTS[@]}"; do convert "$f" || rc=1; done
exit $rc
