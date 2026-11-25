# vhdl2verilog

Convert VHDL files into Verilog using Cadence Genus. Each `.vhd` file you give
it becomes **one `.v` file**.

On this cluster, Genus is installed only on the compute node **cyberdeck**, so
you run the converter as a **Slurm job** with `sbatch`. You don't need to log in
to cyberdeck or load any modules yourself.

---

## Quick start

```bash
cd /path/to/VHDL_Verilog_convert             # 1. go to the project folder

sbatch vhdl2verilog.sbatch -O verilog vhdl/counter.vhd   # 2. submit a job
#   Submitted batch job 1601

squeue -u $USER                              # 3. wait until the job is gone from the list

cat vhdl2v_1601.log                          # 4. read the result (use your own job number)
```

The result is `verilog/counter.v`. `-O verilog` puts the output in the
`verilog/` folder (it is created if it doesn't exist). Without `-O`, the `.v`
file is written next to the input, so you would get `vhdl/counter.v`.

> **Always run `sbatch` from the project folder.** The job looks for
> `vhdl2verilog.sh` in the folder you submitted from, and relative paths such
> as `vhdl/counter.vhd` are read from there too.

---

## Converting your own files

Everything after `sbatch vhdl2verilog.sbatch` is passed on to the converter.

| I want to… | Command |
|---|---|
| Convert one file (output next to it) | `sbatch vhdl2verilog.sbatch my_design.vhd` |
| Choose the output file name | `sbatch vhdl2verilog.sbatch -o out/my_design.v my_design.vhd` |
| Convert several files into one folder | `sbatch vhdl2verilog.sbatch -O verilog a.vhd b.vhd c.vhd` |
| Convert a file that uses entities or packages from other files | `sbatch vhdl2verilog.sbatch -d sub1.vhd -d my_pkg.vhd top.vhd` |
| Change a generic value | `sbatch vhdl2verilog.sbatch -g WIDTH=16 my_design.vhd` |
| Use VHDL-2008 syntax | `sbatch vhdl2verilog.sbatch --vhdl2008 my_design.vhd` |
| Get a single flat module | `sbatch vhdl2verilog.sbatch --flat my_design.vhd` |

You can combine options. For example, this converts the example top level,
which uses three other files:

```bash
sbatch vhdl2verilog.sbatch -O verilog \
    -d vhdl/counter.vhd -d vhdl/pwm_gen.vhd -d vhdl/seq_detect.vhd \
    vhdl/top.vhd
```

All options are listed in [Options](#options).

### Running without arguments

`sbatch vhdl2verilog.sbatch` with no arguments runs the commands in the
**"Default job"** section at the bottom of [vhdl2verilog.sbatch](vhdl2verilog.sbatch).
Right now that section converts the example designs in `vhdl/` into `verilog/`.
If you convert the same set of files often, put your own commands there so that
`sbatch vhdl2verilog.sbatch` is all you need to type.

---

## Checking on your job

| What | Command |
|---|---|
| Is it still running? | `squeue -u $USER` (when the job no longer appears, it has finished) |
| What happened? | `cat vhdl2v_<jobid>.log` |
| What went wrong? | `cat vhdl2v_<jobid>.err` (empty when everything worked) |
| Cancel it | `scancel <jobid>` |

A conversion takes about 15–20 s per file, most of it Genus start-up time.
Both log files are created in the folder you submitted from.

A successful log looks like this:

```
job 1601 on cyberdeck at 2026-11-25 07:59:12
submit dir: /home/<you>/VHDL_Verilog_convert

>> module: cadence
>> genus: /opt/cadence/DDI251/bin/genus
>> vhdl/uart_tx.vhd -> /home/<you>/VHDL_Verilog_convert/verilog/uart_tx.v
   top: uart_tx   mode: generic
   modules: add_unsigned bmux baud_gen_CLKS_PER_BIT16 ... uart_tx CDN_flop CDN_mux2 ...
   no warnings
```

If a file fails, the `.err` file shows the Genus error and usually a hint
(see [Troubleshooting](#troubleshooting)), and Slurm marks the job as `FAILED`.
The other files in the same job are still converted.

---

## What kind of Verilog you get

Genus is a synthesis tool, not a source-to-source translator. It reads the VHDL
and writes the result as a **structural Verilog netlist**:

| VHDL construct | Appears in the Verilog as |
|---|---|
| Entity hierarchy | Same hierarchy, one `module` per entity (generic values are added to the name, e.g. `counter_WIDTH8`) |
| Registers (`rising_edge` processes) | `CDN_flop` instances (a behavioural model is included in the same file) |
| Arithmetic / comparisons | Small gate-level modules (`add_unsigned`, `lt_unsigned`, …) |
| `if` / `case` / muxing | `bmux` / `CDN_bmux*` modules and gates |
| Enumerated FSM states | Binary-encoded state bits (`state_reg[2:0]`) |

In practice:

* ✅ The output is **logically equivalent** to the VHDL. You can simulate it,
  synthesize it, or drop it into a Verilog design in place of the VHDL.
* ✅ **Port names, port widths and the module hierarchy are kept**, so the
  module connects to the rest of your design exactly like the VHDL entity did.
* ❌ It is **not readable RTL**. Processes, `case` statements and internal
  signal names are not kept as in the source, so don't plan to edit it by hand.
* Every module the design needs is in the same `.v` file, so the file is
  complete on its own.

---

## Options

```
  -o, --output FILE     output .v file (only with a single input file)
  -O, --outdir DIR      write outputs into DIR instead of next to the inputs
  -t, --top NAME        top-level entity (default: auto-detected)
  -g, --generic N=V     override a top-level generic, repeatable (-g WIDTH=16)
  -d, --dep FILE        extra VHDL file needed to elaborate (package or
                        sub-entity), repeatable
  -l, --lib FILE        Liberty file: synthesize and map to its cells
                        (default: no mapping, generic gates)
      --vhdl2008        parse as VHDL-2008 (default: VHDL-1993)
      --flat            flatten the hierarchy into a single module
  -k, --keep            keep the Genus work directory (for debugging)
  -q, --quiet           only print errors
  -h, --help            show this help
```

Notes:

* **Top-level entity**: if a file has several entities, the converter picks the
  one that the others don't instantiate. Use `-t name` if it picks the wrong one.
* **`-d` files** are only read to make the input complete; they don't get their
  own `.v`. To get a `.v` for them as well, list them as inputs too.
* **`-l`** maps the design to real standard cells from a Liberty library, e.g.
  `-l /opt/cadence/DDI251/GENUS251/share/synth/tutorials/tech/tutorial.lib`.
  Without it you get technology-independent generic gates, which is what most
  people want.

---

## Changing the job resources

The resource requests are the `#SBATCH` lines at the top of
[vhdl2verilog.sbatch](vhdl2verilog.sbatch):

```bash
#SBATCH --time=01:00:00          # max run time
#SBATCH --nodelist=cyberdeck     # keep this: Genus is only installed on cyberdeck
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
```

These are enough for normal designs. For very large designs or long file
lists, increase `--time` and `--mem`. You can also change them for one job
only, without editing the file:

```bash
sbatch --time=04:00:00 --mem=32G vhdl2verilog.sbatch big_design.vhd
```

---

## Troubleshooting

| Message (in `vhdl2v_<jobid>.err`) | Fix |
|---|---|
| `vhdl2verilog.sh not found or not executable` | Run `sbatch` from the project folder, or set `VHDL2V=/path/to/vhdl2verilog.sh` |
| `file not found: ...` | The path is wrong, or you submitted from another folder. Paths are read from the submit folder |
| `Could not resolve reference ... [CDFG-431]` | The file uses an entity from another file: add that file with `-d` |
| Package not found (`use work.my_pkg.all`) | Add the package file with `-d my_pkg.vhd` |
| `[VHDLPT-...]` parse errors | The file probably uses VHDL-2008 syntax (`process(all)`, `?=`, …): add `--vhdl2008` |
| Wrong top level / several tops detected | Name it with `-t <entity>` |
| `no license server set` / `Cannot obtain 'Genus_Synthesis' license` | The license comes from `module load cadence`. Check that `>> module: cadence` appears in the `.log`. If it does, all licenses may be in use: try again later |
| `cannot find genus` | The job didn't run on cyberdeck (keep `#SBATCH --nodelist=cyberdeck`), or `module load cadence` failed |
| Job stays `PENDING` in `squeue` | cyberdeck is busy. Wait, or ask for fewer CPUs or less memory |

**Looking at the full Genus log**: when a conversion fails, the `.err` file
ends with `full log and script kept in /tmp/vhdl2v.XXXXXX`. That folder is on
cyberdeck, not on the login node. To read it:

```bash
srun --nodelist=cyberdeck --pty bash        # opens a shell on cyberdeck
less /tmp/vhdl2v.XXXXXX/genus.log
rm -rf /tmp/vhdl2v.XXXXXX                   # clean up when you're done
exit
```

Warnings you can ignore:

* `CDFG-476 Case statement is not full`: normal for FSMs whose number of
  states is not a power of two.
* `LBR-158` and `CDFG-818` are expected and already hidden from the summary.

---

## Running without Slurm

If you already have a shell on cyberdeck (for example through
`srun --nodelist=cyberdeck --pty bash`), you can run the converter directly
with the same arguments:

```bash
./vhdl2verilog.sh -O verilog vhdl/counter.vhd
```

This does **not** work on the login node, because Genus is not installed there.

### Where Genus and the license come from

The script runs `module load cadence` itself; you don't need to do it first.
That module puts Genus on the `PATH` and sets the license servers
(`LM_LICENSE_FILE`). **No license address is stored in the script.**

* To use another module name, set `VHDL2V_MODULE=<name>`. To skip loading a
  module, set `VHDL2V_MODULE=` (empty).
* Without a module, set the license yourself, e.g.
  `export LM_LICENSE_FILE=port@license-server`. The script warns if no license
  server is set at all.
* If Genus is not on the `PATH` after that, the script also checks `$GENUS`,
  `$DDI_HOME/bin/genus` / `$GENUS_HOME/bin/genus`, and the usual install folders
  (`/opt/cadence/DDI*/bin/genus`, …).

---

## How it works

The script first loads the `cadence` module (see above). Then, for each input
file, it:

1. Finds the top-level entity (one that no other entity in the file instantiates).
2. Writes a small Genus Tcl script in a temporary folder:
   ```tcl
   set_db hdl_vhdl_read_version 1993          ;# or 2008
   set_db hdl_error_on_blackbox true          ;# missing entity = error, not silent black box
   read_libs   dummy.lib                      ;# or the -l library
   read_hdl -language vhdl <deps...> input.vhd
   elaborate [-parameters {{NAME VAL} ...}] <top>
   [syn_generic; syn_map]                     ;# only with -l
   [ungroup -all -flatten]                    ;# only with --flat
   write_hdl -language v2001 > out.v
   ```
   Genus needs a library to start, so without `-l` the script creates a tiny
   dummy one. Its contents don't affect the generic output.
3. Runs `genus -no_gui -batch` on that script and checks the log for errors.
4. Writes the final `.v` with a short header naming the source file.
5. Deletes the temporary folder (it is kept on failure, or with `-k`).

[vhdl2verilog.sbatch](vhdl2verilog.sbatch) is a thin wrapper around this: it
asks Slurm for a slot on cyberdeck, moves to the folder you submitted from,
and runs `vhdl2verilog.sh` with your arguments.

---

## Files

```
vhdl2verilog.sbatch    Slurm job script: start here (sbatch vhdl2verilog.sbatch ...)
vhdl2verilog.sh        the converter itself (self-contained)
vhdl/                  example VHDL
  counter.vhd            generic-width counter
  pwm_gen.vhd            PWM generator, instantiates counter
  seq_detect.vhd         Moore FSM ("1011" detector)
  top.vhd                top level: pwm_gen + seq_detect
  uart_tx.vhd            self-contained UART TX (two entities in one file)
verilog/               converted examples
  counter.v  seq_detect.v  uart_tx.v
  top.v                  converted with -d (includes all sub-modules)
  uart_tx_mapped.v       mapped to tutorial.lib cells, flattened
```
