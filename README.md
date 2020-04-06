# MIPS-Spring20-Fudan

Course Website for MIPS Spring 2020 at Fudan University
[[course website]](https://sunfloweraries.github.io/ICS-Spring20-Fudan/)

## Coursework Guidelines

- Both **verilog** and **system verilog** are recommended, and if you have any problems about them, please search in proper websites (e.g. [stack overflow](https://stackoverflow.com/)) first.
- The first three assignments must be checked as scheduled in our syllabus, and each report can be delayed **no more than a week**. For the fourth assignment, you will not be required to finish it, but we will grade on your accomplishments. 
- You'd better form a team as soon as possible, since `assignment-3` and `assignment-4` are designed as team project (to be discussed).
- Both English and Chinese are acceptable, and there will be no difference in terms of scores as long as you can make yourself clear with your report.
- Write clearly and succinctly. Highlight your answer and key result that is asked in the coursework requirements by **Bold** font. You should take your own risk if you intentionally or unintentionally make the marking un-straightforward.
- Bonus mark (no more than 20%) will be considered if you make more in-depth exploration or further development that could in turn inspire the coursework to be a better one and show your understanding of the course material, this should only be the case given that you have already met the requirements.
- Please use the [issue system](https://github.com/SunflowerAries/ICS-Spring20-Fudan/issues) to ask questions about the coursework and course or discuss about the course content, use proper tags whenever possible, (e.g. `Arch/assignment-1`). In this case any questions answered by the instructor, TAs or others, and discussions will also be visible to other students.
- If you find any mistakes in the coursework or the course website itself (e.g. typos) you are encouraged to correct it with a pull request, however, don't mix this kind of changes with your coursework submission pull request as stated in the following section.
- For any feedback, please consider emailing the TAs first.

## Checker Configuration

For the first three assignments, you need pass all the tests before submitting, and we will again check if you've passed them.

Take `assignment-1` as an example, its benchtests are all included in `assignment-1/benchtest`, which is structured like this

```
.
├── benchtest/
|   ├── run_simulation.tcl
│   ├── cpu_tb.sv
│   ├── .... (other benchtests)
│   └── factorial
|	|	├── factorial.ans
|	|	├── factorial.in
|	|	├── factorial.mem
|	|	├── factorial.out
|	|	├── factorial.run
|	|	└── factorial.txt
```

You need to create a vivado project first, and suppose its name is `project_1`, then include the `benchtest/` directory  and `makefile` in `project_1/`,  and add `benchtest/cpu_tb.sv` as a simulation source file without copying sources into project (and then set it as top). ~~Please change the value of `PATH_PREFIX` in the 1st line of `cpu_tb.sv` to the absolute path to this project, for example `/home/sunflower/Downloads/project_1/`~~. To grade your work automatically, we've made some changes to your cpu_tb.sv and began to take relative path, so there's no need to change the value of `PATH_PREFIX` in the 1st line of `cpu_tb.sv` any more.

Each directory (e.g. `factorial/`) represents a test, which includes 6 files, and you can look into \*.out which includes mips instructions and its corresponding machine code. **If you want to commit some tests to us, you need comment out additional tests before committing in `cpu_tb.sv`**.

If you successfully passed a test, you can get outputs like

```shell
[OK] factorial
[OK] ...
[Done]
```

Otherwise you may get outputs like `FAILURE: Testbench Failed to finish before ddl!` or `[Error] PC: 0x0000001e Cycle: 5 Expected: balabala, Got: labalaba`, when you encounters the second situation in GUI, CPU is now stopped, and you can look into the wave plot to find what's wrong.

On linux, if you want to run the simulation test in command line, you can configure the `makefile`:

* `VIVADO_PATH` is the absolute path to your vivado executable file, eg. `/usr/local/Xilinx/Vivado/20xx.x/bin/vivado`.
* `PROJECT_DIR` default is `.`, you can leave it alone.
* `PROJECT_NAME` is the name of your vivado project which should correspond to `*.xpr`.
* `SIM` is the name of the simulation set you want to run (default is sim_1).
* **You need to restore the configuration before committing, since we'll just use `makefile`  in your directory to run vivado automatically**.

After proper configuration, you can use `make test` or simple `make` to run the simulation test.

## Scores

For each assignment, the score is made up of

- Passing all the benchtests (40%).
- Report and interview (40%).
- On-board test (20%).

## Hint

This course website mainly refers to [PRML-Spring19-Fudan](https://github.com/ichn-hu/PRML-Spring19-Fudan).

For textbook, you can refer to

- *Digital Design and Computer Architecture* (2nd)