`define PATH_PREFIX ""
`define NAME "test1"

module cpu_tb();

wire mem_write, cpu_clk, finish;
wire [31:0] pc, instr, read_data, write_data, cpu_data_addr;

reg clk, reset, success;
reg [31:0] tb_data_addr, tb_dmem_data, data_addr, pc_finished;

parameter ISIZE = 64, DSIZE = 64;

// test variables
integer fans, error_count;

// module instances
mips mips(cpu_clk, reset, pc, instr, mem_write, cpu_data_addr, write_data, read_data);
imem #(ISIZE) imem(pc[7:2], instr);
dmem #(DSIZE) dmem(clk, mem_write, data_addr, write_data, read_data);

// clock and reset
always #20 clk = ~clk;
initial
begin
	reset = 1'b1;
	clk = 1'b0;
	#50 reset = 1'b0;
end

assign finish = ~|(pc ^ pc_finished);
assign cpu_clk = clk & ~finish;

// mux2t1
always @(*)
	if (finish)
		data_addr <= tb_data_addr;
	else
		data_addr <= cpu_data_addr;

// judge memory
task judge_memory(
	input integer fans
);
	begin
		tb_dmem_data = 32'h0000_0000;
		$fscanf(fans, "%h", tb_dmem_data);
		if (tb_dmem_data != read_data)
		begin
			$display("FAILUER: dmem 0x%0h expect 0x%0h but get 0x%0h",
				data_addr, tb_dmem_data, read_data);
			error_count = error_count + 1;
		end
	end
endtask


task testcase(
	input integer fans
);
	begin
		// $readmemh({`PATH_PREFIX, "data", name, ".bat"}, imem.RAM);

		wait(finish == 1'b1);
		repeat (DSIZE) begin
			@(negedge clk)
			judge_memory(fans);
			tb_data_addr = tb_data_addr + 4;
		end
	end
endtask


initial 
begin
	// ddl to finish simulation
	#500000 $display("FAILURE: Testbench Failed to finish before ddl!");
	error_count = error_count + 1;
	$finish;
end


// start test
initial
begin
    $display("READ FILE: %s\n", { `PATH_PREFIX, "data/", `NAME, ".ans"});
    fans = $fopen({ `PATH_PREFIX, "data/", `NAME, ".ans"}, "r");
    error_count = 0;

    tb_data_addr = 32'h0000_0000;
    tb_dmem_data = 32'h0000_0000;
    pc_finished = 32'hffff_ffff;
    $fscanf(fans, "%h", pc_finished);

	wait(reset == 1'b0);
	testcase(fans);
    $fclose(fans);
	$display("[Done]\n");
	$display("Find %d error(s)\n", error_count);
	$finish;
end

endmodule
