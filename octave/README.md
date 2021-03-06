```bash
cd test/py
python3 sim.py -v
```

Data is read from `data/in.csv` and results are written to `data/out.csv`.

# Octave

> TODO: is it worth guessing the set of arguments that `mkoctfile` requires in order to embedded all the `*.o` objects? This might be useful because loading PIE binaries generated by GHDL is *hackish* and it is not supported on Windows.

# VUnit + GHDL with C wrapper (PIE binary)

## Standalone entrypoint

```bash
# Build and execute PIE binary
cd test/py
python3 run.py -v
```

Buffers are allocated and data is generated in the `main` C function in `c/main.c`. Results are checked in `exit_handler`, also defined in `c/main.c`.

## Dynamically loaded in C

`dlopen/main.c` can be used to load the PIE binary in, e.g., a MAMBO plugin or as a gRPC client.

## Dynamically loaded in C++

`dlopen/main.cc` can be used to load the PIE binary in, e.g., a DynamoRIO client. Sources for octave plugins (see below) are based on this.

## Dynamically loaded in Python

```bash
# Build PIE binary
cd test/py
python3 run.py --build
```

```bash
# Dynamically load and test two entrypoints: 'main' and 'ghdl_main'
cd test/py
python3 cosim.py -v
```

When the entrypoint is `main`, the execution is the same as the previous case. However, when the entrypoint is `ghdl_main`, buffers are allocated, data is generated and results are checked in `cosim.py`. Therefore, C resources from `vhpidirect_user.h` are used only.

## Dynamically locaded in Octave

```bash
# Build PIE binary
cd test/py
python3 run.py --build

# Build *.oct file
cd ../oct
mkoctfile axis_stage.cc

# Execute VHDL simulation through octave
octave --eval "axis_stage('../py/args.txt', [10, 15, 20, 25, 30])"

# If axis_stage is executed interactively, it needs to be cleared before recompiling:
# clear axis_stage
```

Data is generated in Octave and results are returned as any regular buil-in function.
