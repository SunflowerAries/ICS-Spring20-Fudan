## <center>ICS (Architecture)</center>

### <center>Fudan University / 2020 Spring</center>

<center>Assignment 2</center>
This assignment will make up 20% of the final score. It will **due on Apr 27**, and you must pass all the tests before submitting your work. Recently we've made some **changes** to grade your work automatically, please refer to [checker guidelines](https://github.com/SunflowerAries/ICS-Spring20-Fudan/blob/master/README.md#checker-configuration) for details.

#### Background

$$
CPU time = \frac{Seconds}{Program} = \frac{Instructions}{Program}\times\frac{Cycles}{Instruction}\times\frac{Seconds}{Cycle}
$$

Pipelining is a technique where multiple instructions are overlapped during execution.  It reduces CPI so that total CPU time consumption is dramatically reduced compared to non-pipelining. All modern high-performance microprocessors are pipelined.

From now on, we'll measure CPI of your CPU, and you may alter 76th-79th lines of `cpu_tb.sv` to fit into yours.

```systemverilog
cycle = cycle + 1;

if (~mips.dp.flushD & ~mips.dp.haz.stallD)
	instr_count = instr_count + 1;
```

However, because multiple instructions are handled concurrently in a pipelined system, there exists possibility of *hazards*, which need special solution.

#### Description

In this assignment, you are going to implement Pipeline MIPS CPU according to slides and textbook.

Your CPU needs to support instructions: add，sub，and，or，slt，addi，andi，ori，slti，sw，lw，j，nop，beq，bne, jal, jr, sra, sll, srl. For unfamiliar instructions, please refer to our textbook *Digital Design and Computer Architecture*'s Appendix B.

You have to follow our I/O port naming as shown in `cpu_tb.sv`, on which our graders are based. (Same as in textbook)

```verilog
module cpu_tb();
/*
 * grader
 */

mips mips(.clk(cpu_clk), .reset(reset), .pc(pc), .instr(instr), .memwrite(cpu_mem_write), .aluout(cpu_data_addr), .writedata(write_data), .readdata(read_data));
imem imem(.a(pc[7:2]), .rd(instr));
dmem dmem(.clk(clk), .we(mem_write), .a(cpu_data_addr), .wd(write_data), .rd(read_data));
endmodule
```

Before submission, you must run simulation to check if your CPU works well. This assignment's tests are all listed in `assignment-2/benchtest`

#### Report Requirements

- There's no need to include simulation results (e.g. wave plots) in your report, since you have passed all the benchtests.
- For the sake of intellectual property, you should list all the references, especially the pictures you include in the report (It's recommended to draw pictures on your own).
- You are encouraged to offer some interesting and useful benchtests (not included in ours) in your report (no more than 5% bonus).
