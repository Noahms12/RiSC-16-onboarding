module instruction_memory (
    input wire [15:0] address,
    output wire [15:0] instruction
);

    // Internal storage for the 65536 memory locations (0 to 65535)
    reg [15:0] memory [0:65535];
    
    assign instruction = memory[address];

    // integer needed for the looping index
    integer i;

    initial begin
        //  Initialize all memory locations to 0
        for (i = 0; i <= 65535; i = i + 1) begin
            memory[i] = 16'h0000;
        end

    parameter MEM_FILE = "program.mem"; 
    //  Load the program data (this will overwrite the 0s at the specific addresses in the file)
    $readmemh(MEM_FILE, memory);
    end

endmodule
