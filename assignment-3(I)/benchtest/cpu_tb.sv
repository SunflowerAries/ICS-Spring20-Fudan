`define PATH_PREFIX "../../../../"
`define NAME "benchtest/"

module cpu_tb();

logic mem_write, cpu_clk, finish, cpu_mem_write;
logic [31:0] pc, instr, read_data, write_data, cpu_data_addr;

reg clk, reset;
reg [31:0] tb_data_addr, tb_dmem_data, pc_finished;

//parameter ISIZE = 32, DSIZE = 32;


string summary;
// test variables
integer fans, frun, fimem, fdmem, error_count, imem_counter, dmem_counter;
integer cycle = 0, instr_count = 0;
logic running;

`ifdef checking
    integer error_test = 0;
`endif
logic ihit, dhit, stall, dcen;
logic finish1, finish2, ireset;
logic [31:0]cpu_wd, cpu_rd, m_wd, m_rd, cpu_instr, m_data_addr, i_ad;

// module instances
mips mips(.clk(cpu_clk), .reset(reset | ireset), .pc(pc), .instr(cpu_instr), .memwrite(cpu_mem_write),
          .aluout(cpu_data_addr), .writedata(cpu_wd), .readdata(cpu_rd), .ihit(ihit), .dhit(dhit), .dcen(dcen));
imem imem(.a(i_ad[7:2]), .rd(instr));
dmem dmem(.clk(clk), .we(mem_write), .a(m_data_addr), .wd(m_wd), .rd(m_rd));
cache icache(.clk(clk), .reset(reset | ireset), .stall(stall), .input_ready(1'b1), .addr(pc),
             .write_data(cpu_wd), .w_en(1'b0), .hit(ihit), .read_data(cpu_instr),
             .maddr(i_ad), .mread_data(instr));
cache dcache(.clk(clk), .reset(reset), .stall(stall), .input_ready(dcen), .addr(cpu_data_addr),
             .write_data(cpu_wd), .w_en(cpu_mem_write), .hit(dhit), .read_data(cpu_rd),
             .maddr(m_data_addr),.mwrite_data(m_wd),.m_wen(mem_write),.mread_data(m_rd));

// clock and reset
always #20 clk = ~clk;

always_ff @( posedge clk, negedge clk ) begin 
    cpu_clk <= clk & ~finish & ~stall;
end

// assign mem_write = cpu_mem_write & ~finish;
assign finish = ~|(pc ^ pc_finished);
assign stall = ~(ihit & (~dcen | dhit));

task judge(
    input integer frun,
    input integer cycle,
    input string out
);
    string ans;
    ans = "";
    $fscanf(frun, "%s\n", ans);
    if (ans != out)
        begin
            `ifdef checking
		      error_count = error_count + 1;
		    `else
		      begin
		          $display("[Error] PC: 0x%x Cycle: %0d\tExpected: %0s, Got: %0s", pc, cycle, ans, out);
		          $stop;
              end
		    `endif
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
                tb_dmem_data = 32'h0000_0000;
                $fscanf(fans, "%h", tb_dmem_data);
                if (tb_dmem_data != dmem.RAM[tb_data_addr/4])
                    begin
                        $display("FAILURE: dmem 0x%0h expect 0x%0h but get 0x%0h",
                            tb_data_addr, tb_dmem_data, dmem.RAM[tb_data_addr/4]);
                        error_count = error_count + 1;
                    end
                tb_data_addr = tb_data_addr + 4;
            end
        `ifndef checking
            $display("successfully pass memory judge");
        `endif
    end
endtask

always_ff @(negedge clk) begin
	if (running)
		cycle <= cycle + 1;
	else
		cycle <= cycle;
end

// check runtime
task runtime_checker(
    input integer frun
);
    string out;
    $display("========== In runtime checker ==========");
	running = 1'b1;
    if(frun)
    while(!$feof(frun))
        begin@(negedge cpu_clk)
            // cycle = cycle + 1;
            
            if (~mips.dp.flushD & ~mips.dp.haz.stallD)
                instr_count = instr_count + 1;

            if (cpu_mem_write)
                begin
                    $sformat(out, "[0x%x]=0x%x", m_data_addr, cpu_wd);
//                    $display("out: %0s", out);
                    judge(frun, cycle, out);
                end
        end
	running = 1'b0;
    `ifndef checking
        $display("successfully pass runtime checker");
    `endif
endtask

initial 
begin
	// ddl to finish simulation
	#10000000 $display("FAILURE: Testbench Failed to finish before ddl!");
	error_count = error_count + 1;
	$finish;
end

// init memory
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
                        dmem.RAM[dmem_counter] = 32'h0000_0000;
                        $fscanf(fdmem, "%x", dmem.RAM[dmem_counter]);
                        dmem_counter = dmem_counter + 1;
                    end
            $fclose(fdmem);
        end
    imem_counter = 0;
    $display("========== In init ==========");
    while(!$feof(fimem))
        begin
            imem.RAM[imem_counter] = 32'h0000_0000;
            $fscanf(fimem, "%x", imem.RAM[imem_counter]);
            imem_counter = imem_counter + 1;
        end
    $display("%0d instructions in total", imem_counter);
    $fclose(fimem);
endtask

task finishing();
    wait(finish == 1'b1);
    ireset = 1;
    #50 ireset = 0; 
	pc_finished = 32'h0000_001c;
    imem.RAM = '{ default: '0 };
    fimem = $fopen({ `PATH_PREFIX, `NAME, "writeback", "/", "writeback", ".mem"}, "r");
    imem_counter = 0;
    while(!$feof(fimem))
        begin
            imem.RAM[imem_counter] = 32'h0000_0000;
            $fscanf(fimem, "%x", imem.RAM[imem_counter]);
            imem_counter = imem_counter + 1;
        end
    $fclose(fimem);
endtask

task grader(input string name);
    $display("========== Test: %0s ==========", name);
    begin
        reset = 1'b1;
        tb_dmem_data = 32'h0000_0000;
        tb_data_addr = 32'h0000_0000;
        pc_finished = 32'hffff_ffff;
        #50 reset = 1'b0; 
    end
    init(name);
    fans = $fopen({ `PATH_PREFIX, `NAME, name, "/", name, ".ans"}, "r");
    $fscanf(fans, "%h", pc_finished);
    frun = $fopen({ `PATH_PREFIX, `NAME, name, "/", name, ".run"}, "r");
    error_count = 0;
    runtime_checker(frun);
    $fclose(frun);
    finishing();
	judge_memory(fans);
    $fclose(fans);
    if (error_count != 0)
        begin
            $display("Find %0d error(s)", error_count);
            `ifdef checking
                error_test = error_test + 1;
                $display("[ERROR] %0s\n", name);
            `endif
        end
    else
        $display("[OK] %0s\n", name);
endtask

// start test
initial
begin
    clk = 1'b0;
    grader("ad hoc");
    grader("factorial");
    grader("bubble sort");
    grader("gcd");
    grader("quick multiply");
    grader("bisection");
    grader("mutual recursion");
    grader("testjr");
    grader("en & clear");
    grader("i-type");
	$display("[Done]\n");
    $display("CPI = %0f\n", $bitstoreal(cycle) / $bitstoreal(instr_count));
	`ifdef checking
	   $display("Error test: %0d\n", error_test);
	`endif
    $finish;
end

endmodule

