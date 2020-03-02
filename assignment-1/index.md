## <center>ICS (Architecture)</center>

### <center>Fudan University / 2020 Spring</center>

<center>Assignment 1</center>

Note: This is the first assignment for this course, you should read the [guidelines](https://github.com/SunflowerAries/ICS-Spring20-Fudan/blob/master/README.md) first. This assignment will make up 20% of the final score.

This assignment will **due on Apr 6** before the course start, and you must pass all the tests before submitting your work, for detailed information about checker configuration, also refer to the [guidelines](https://github.com/SunflowerAries/ICS-Spring20-Fudan/blob/master/README.md#checker-configuration).

#### Description

In this assignment, you are going to implement Single-Cycle MIPS CPU according to slides and textbook. Your CPU need support instructions including: add，sub，and，or，slt，addi，andi，ori，slti，sw，lw，j，nop，beq，bne, jal, jr, sra, sll, srl.

You have to follow our variable naming rules and framework as shown in `cpu_tb.sv`, which mainly refer to our textbook, since our graders are based on them.

```verilog
module cpu_tb();
/*
 * grader
 */
    
parameter ISIZE = 64, DSIZE = 64;
// size of instruction memory and data memory

mips mips(.clk(cpu_clk), .reset(reset), .pc(pc), .instr(instr), .memwrite(cpu_mem_write), .aluout(cpu_data_addr), .writedata(write_data), .readdata(read_data));
imem #(ISIZE) imem(.a(pc[7:2]), .rd(instr));
dmem #(DSIZE) dmem(.clk(clk), .memwrite(mem_write), .a(cpu_data_addr), .writedata(write_data), .rd(read_data));
endmodule
```

After finishing CPU, you must run simulation to check if your CPU works well. This assignment's tests are all listed in `assignment/benchtest`

#### Report Requirements

- There's no need to include simulation results (e.g. wave plots) in your report, since you have passed all the benchtests.
- You should list all the references you find useful during your implementation, especially for the pictures you include in your report (We recommend you draw pictures on your own).
- You are encouraged to offer some interesting and useful benchtests (not included in ours) in your report (no more than 5% **bonus**).
