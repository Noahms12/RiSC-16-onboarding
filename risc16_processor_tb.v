`timescale 1ns / 1ps

module risc16_processor_tb;

    // --- Testbench Signals ---
    reg clk;
    reg rst_n;

    // Instantiate the Unit Under Test (UUT)
    risc16_processor uut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // --- Clock Generation ---
    // Create a clock with a 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // --- Test Sequence ---
    initial begin
        $dumpfile("cpu_waves.vcd"); // Create a waveform file
        $dumpvars(0, risc16_processor_tb); // Dump all variables in the testbench
        
        // 1. Apply Reset
        $display("Starting simulation...");
        rst_n = 0; // Assert active-low reset
        #20;       // Hold reset for 20ns (2 clock cycles)
        rst_n = 1; // De-assert reset
        
        // 2. Let the processor run for some time
        #200;      // Run for 200ns (20 clock cycles)
        
        // 3. Stop Simulation
        $display("Simulation finished.");
        $stop;
    end

    // --- Monitoring ---
    // This is how we "see" what the processor is doing.
    // We need to access wires *inside* the 'uut'.
    // This is allowed in a testbench.
    initial begin
        // Start monitoring immediately. 
        // It will automatically print whenever a signal changes.
        $monitor(
            "Time=%0t | PC= %h | Instr= %h | rA=%d rB=%d rC=%d | reg_out1= %h | reg_out2= %h | ALU_Out= %h | Mem_Out= %h | WE_rf= %b",
            $time,
            uut.pc_out,         
            uut.instruction,    
            uut.rA, uut.rB, uut.rC, 
            uut.reg_out1,       
            uut.reg_out2,       
            uut.alu_out,        
            uut.mem_out,        
            uut.WE_rf           
        );
    end

endmodule
