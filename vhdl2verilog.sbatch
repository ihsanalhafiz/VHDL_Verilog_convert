#!/bin/bash
#SBATCH --job-name=vhdl2verilog         # Job name
#SBATCH --output=vhdl2v_%j.log          # Output file (%j expands to jobID)
#SBATCH --error=vhdl2v_%j.err           # Error file
#SBATCH --time=01:00:00                 # Max walltime (hh:mm:ss); ~20 s per file
#SBATCH --nodelist=cyberdeck            # Genus is installed on cyberdeck
#SBATCH --ntasks=1                      # Number of tasks
#SBATCH --cpus-per-task=4               # Genus runs single-threaded here
#SBATCH --mem=16G                       # Memory per node
# =============================================================================
# Run vhdl2verilog.sh as a Slurm job. Submit from the project directory:
#
#   sbatch vhdl2verilog.sbatch
#       -> runs the conversions listed under "Default job" below
#
#   sbatch vhdl2verilog.sbatch [vhdl2verilog.sh options] input.vhd ...
#       -> passes all arguments straight to vhdl2verilog.sh, e.g.
#          sbatch vhdl2verilog.sbatch -O verilog vhdl/counter.vhd vhdl/uart_tx.vhd
#
# Relative paths are resolved against the directory you ran sbatch from.
# Set VHDL2V=/path/to/vhdl2verilog.sh to use a copy of the script elsewhere.
# =============================================================================
set -euo pipefail

# Slurm runs a spooled copy of this file, so find the converter via the
# submit directory, not via $0.
cd "${SLURM_SUBMIT_DIR:-$PWD}"
V2V="${VHDL2V:-$PWD/vhdl2verilog.sh}"
[[ -x "$V2V" ]] || { echo "error: $V2V not found or not executable (submit from the project dir or set VHDL2V)" >&2; exit 1; }

# Genus and its license come from 'module load cadence', which
# vhdl2verilog.sh does itself.

echo "job ${SLURM_JOB_ID:-local} on $(hostname) at $(date '+%Y-%m-%d %H:%M:%S')"
echo "submit dir: $PWD"
echo

if [[ $# -gt 0 ]]; then
  "$V2V" "$@"
else
  # ---- Default job: edit to fit your design --------------------------------
  rc=0
  # Self-contained files: one .v per .vhd
  "$V2V" -O verilog vhdl/counter.vhd vhdl/seq_detect.vhd vhdl/uart_tx.vhd || rc=1
  # A file that instantiates entities from other files: pass them with -d
  "$V2V" -O verilog -d vhdl/counter.vhd -d vhdl/pwm_gen.vhd -d vhdl/seq_detect.vhd \
         vhdl/top.vhd || rc=1
  exit $rc
fi
