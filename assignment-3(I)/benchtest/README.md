This file is the same as the one in Pipeline.

# MIPS Test Bench

This is a testbench for MIPS CPU. You need to create a vivado project in this directory, thus there will be a `*.xpr` file in this directory. After creating the vivado project, please add `benchtest/cpu_tb.sv` as a simulation source file.

Please change the value of `PATH_PREFIX` (default is empty `""`) in the 1st line of `cpu_tb.sv` to the absolute path to this project.

Here are test files (`*.dat`) in `data` filled with machine code and corresponding answer files (`*.ans`) which are used in the simulation test.

If you want to run the simulation test in command line on linux, you can configure the `makefile`:

* `VIVADO_PATH` is the absolute path to your vivado executable file, eg. `/usr/local/Xilinx/Vivado/20xx.x/bin/vivado`.
* `PROJECT_DIR` default is `.`, you can leave it alone.
* `PROJECT_NAME` is the name of your vivado project which is equal to the name of `*.xpr` file without `.xpr` suffix.
* `SIM` is the name of the simulation set you want to run.

After proper configuration, you can use `make test` or simple `make` to run the simulation test.
