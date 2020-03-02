`define PATH_PREFIX "/home/sunflower/Downloads/project_1/"
`define NAME "benchtest/"

module cpu_tb();

wire mem_write, cpu_clk, finish, cpu_mem_write;
wire [31:0] pc, instr, read_data, write_data, cpu_data_addr;

reg clk, reset;
reg [31:0] tb_data_addr, tb_dmem_data, pc_finished;

parameter ISIZE = 32, DSIZE = 32;
string summary;
// test variables
integer fans, frun, fimem, fdmem, error_count, imem_counter, dmem_counter;

// module instances
mips mips(cpu_clk, reset, pc, instr, cpu_mem_write, cpu_data_addr, write_data, read_data);
imem #(ISIZE) imem(pc[7:2], instr);
dmem #(DSIZE) dmem(clk, mem_write, cpu_data_addr, write_data, read_data);

// clock and reset
always #20 clk = ~clk;

assign finish = ~|(pc ^ pc_finished);
assign cpu_clk = clk & ~finish;
assign mem_write = cpu_mem_write & ~finish;

task judge(
    input integer frun,
    input integer cycle,
    input string out
);
    string ans;
    $fscanf(frun, "%s\n", ans);
    if (ans != out)
        begin
            $display("[Error] PC: 0x%x Cycle: %d\tExpected: %0s, Got: %0s", pc, cycle, ans, out);
		    $stop;
        end
endtask

// judge memory
task judge_memory(
	input integer fans
);
    $display("========== In memory judge ==========");
    begin
        wait(finish == 1'b1);
        while(!$feof(fans))
            begin
                $fscanf(fans, "%h", tb_dmem_data);
                if (tb_dmem_data != dmem.RAM[tb_data_addr/4])
                    begin
                        $display("FAILUER: dmem 0x%0h expect 0x%0h but get 0x%0h",
                            tb_data_addr, tb_dmem_data, dmem.RAM[tb_data_addr/4]);
                        error_count = error_count + 1;
                    end
                tb_data_addr = tb_data_addr + 4;
            end
    end
endtask

task runtime_checker(
    input integer frun
);
    integer cycle;
    string out;
    cycle = 0;
    $display("========== In runtime checker ==========");
    while(!$feof(frun))
        begin@(negedge clk)
            cycle = cycle + 1;
            // $readmemh({`PATH_PREFIX, "data", name, ".bat"}, imem.RAM);
            if (mem_write)
                begin
                    $sformat(out, "[0x%x]=0x%x", cpu_data_addr, write_data);
                    judge(frun, cycle, out);
                end
        end    
endtask

initial 
begin
	// ddl to finish simulation
	#1000000 $display("FAILURE: Testbench Failed to finish before ddl!");
	error_count = error_count + 1;
	$finish;
end

task init(input string name);
    imem.RAM = '{ default: '0 };
    dmem.RAM = '{ default: '0 };
    fimem = $fopen({ `PATH_PREFIX, `NAME, name, "/", name, ".mem"}, "r");
    fdmem = $fopen({ `PATH_PREFIX, `NAME, name, "/", name, ".data"}, "r");
    if (fdmem != 0) 
        begin
            dmem_counter = 0;
                while(!$feof(fdmem))
                    begin
                        $fscanf(fdmem, "%x", dmem.RAM[dmem_counter]);
                        dmem_counter = dmem_counter + 1;
                    end
            $fclose(fdmem);
        end
    imem_counter = 0;
    $display("========== In init ==========");
    while(!$feof(fimem))
        begin
            $fscanf(fimem, "%x", imem.RAM[imem_counter]);
            imem_counter = imem_counter + 1;
        end
    $display("%d instructions in total", imem_counter);
    $fclose(fimem);
endtask

task grader(input string name);
    $display("========== Test: %0s ==========", name);
    init(name);
    begin
        reset = 1'b1;
        tb_dmem_data = 32'h0000_0000;
        tb_data_addr = 32'h0000_0000;
        pc_finished = 32'hffff_ffff;
        #50 reset = 1'b0;   
    end
    fans = $fopen({ `PATH_PREFIX, `NAME, name, "/", name, ".ans"}, "r");
    $fscanf(fans, "%h", pc_finished);
    frun = $fopen({ `PATH_PREFIX, `NAME, name, "/", name, ".run"}, "r");
    runtime_checker(frun);
    error_count = 0;
    $fclose(frun);
	judge_memory(fans);
    $fclose(fans);
    if (error_count != 0)
        $display("Find %d error(s)", error_count);
    else
        $display("Correct");
endtask

// start test
initial
begin
    clk = 1'b0;
    grader("factorial");
	$display("[Done]\n");
	$finish;
end

endmodule
