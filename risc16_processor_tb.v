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
        // Wait for reset to finish
        @(negedge rst_n);
        @(posedge rst_n);
        
        // At every positive clock edge, print these values
        $monitor(
            "Time=%0t | PC= %h | Instr= %h | rA=%d rB=%d rC=%d | reg_out1= %h | reg_out2= %h | ALU_Out= %h | Mem_Out= %h | WE_rf= %b",
            $time,
            uut.pc_out,         // The current program counter
            uut.instruction,    // The instruction being executed
            uut.rA, uut.rB, uut.rC, // Decoded register addresses
            uut.reg_out1,       // Value from Reg[rB]
            uut.reg_out2,       // Value from Reg[rC or rA]
            uut.alu_out,        // Result from ALU
            uut.mem_out,        // Data from Data Memory
            uut.WE_rf           // Write-Enable for Register File
        );
    end

endmodule
