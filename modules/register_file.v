
module register_file (
    input wire clk,
    input wire [1:0] MUX_tgt,
    input wire MUX_rf,
    input wire WE_rf,
    input wire [15:0] mem_out,
    input wire [15:0] alu_out,
    input wire [15:0] pc,
    input wire [2:0] rA, // Register A address
    input wire [2:0] rB, // Register B address
    input wire [2:0] rC, // Register C address
    output wire [15:0] reg_out1,
    output wire [15:0] reg_out2
);

    // Internal storage for the 8 registers.
    reg [15:0] register_file [0:7];

    // Wires for address selection and write data
    wire [2:0] dest_addr;
    wire [2:0] reg_out2_addr; // Address for the second read port, selected by MUX_rf
    wire [15:0] write_data;

    // --- ADDRESSING LOGIC ---
    // The destination register for any write-back operation is always rA.
    assign dest_addr = rA;


    // --- READ LOGIC (Asynchronous and MUXed) ---

    // reg_out1 consistently reads from rB, which is the first source operand for the ALU.
    assign reg_out1 = register_file[rB];

    // The address for the second read port (reg_out2) depends on the MUX_rf signal.
    // MUX_rf = 0: Selects rC (for ADD/NAND)
    // MUX_rf = 1: Selects rA (for SW/BEQ)
    assign reg_out2_addr = (MUX_rf == 1'b0) ? rC : rA;
    
    // reg_out2 reads from the MUXed address.
    assign reg_out2 = (reg_out2_addr == 3'b000) ? 16'h0000 : register_file[reg_out2_addr];

    // --- WRITE LOGIC (Synchronous) ---
    // The MUX_tgt signal selects which value gets written back to the register file.
    assign write_data = (MUX_tgt == 2'b00) ? mem_out :      // For LW
                      (MUX_tgt == 2'b01) ? alu_out :      // For ADD, ADDI, NAND, LUI
                      (MUX_tgt == 2'b10) ? pc + 16'h0001 : // For JALR
                      16'hXXXX;

    always @(posedge clk) begin
        // A write only occurs if the write enable (WE_rf) is high and the destination is not R0.
        if (WE_rf && (dest_addr != 3'b000)) begin
            register_file[dest_addr] <= write_data;
        end
    end

    // --- INITIALIZATION ---
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            register_file[i] = 16'h0000;
        end
    end

endmodule
