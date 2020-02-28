## <center>ICS (Architecture)</center>

### <center>Fudan University / 2020 Spring</center>

<center>Assignment 1</center>

Note: This is the first assignment for this course, you should read the [guidelines](https://github.com/SunflowerAries/ICS-Spring20-Fudan/blob/master/Arch/README.md) first, it will make up 20% of the final score.

This assignment will **due on Mar 30** before the course start (missing deadline will lead to loss of score), for instructions of submission, please also see the guidelines.

#### Description

In this assignment, you are going to implement Single-Cycle MIPS CPU according to slides and textbook. Your CPU need support instructions including: add，sub，and，or，slt，addi，andi，ori，slti，sw，lw，j，nop，beq，bne, jal, jr, sra, sll, srl.

You have to follow our variable naming rules and framework as shown in `cpu_tb.v`, which mainly refer to our textbook, since our graders are based on them.

```verilog
module cpu_tb();
/*
 * grader
 */
wire [31:0] pc, instr, readdata;
wire clk, reset, memwrite;
wire [31:0] writedata, dataadr;
    
parameter ISIZE = 64, DSIZE = 64;
// size of instruction memory and data memory

mips mips(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);
imem #(ISIZE) imem(pc[7:2], instr);
dmem #(DSIZE) dmem(clk, memwrite, dataadr, writedata, readdata);
endmodule
```

After finishing CPU, you must run simulation to check if your CPU works well using command as below:

```

```

#### Make-up

- Passing all the benchtests makes up 40%.
- Report and interview make up 40%.
- On-board display makes up 20%.

#### Report Requirements

- There's no need to include wave plots in your report, since you have passed all the benchtests.
- You should list all the references you find useful during your implementation, especially for the pictures you include in your report (We recommend you draw pictures on your own).
- You are encouraged to offer some interesting and useful benchtests in your report.
