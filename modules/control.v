
module control (
    input wire [2:0] op,
    input wire EQ,
    output reg MUX_alu1, MUX_alu2, MUX_rf, WE_rf, WE_dmem,
    output reg [1:0] FUNC_alu, MUX_pc, MUX_tgt
);

parameter ADD = 3'b000;
parameter ADDI = 3'b001;
parameter NAND = 3'b010;
parameter LUI  = 3'b011;
parameter LW = 3'b100;
parameter SW = 3'b101;
parameter BEQ = 3'b110;
parameter JALR = 3'b111;

always @(*) begin
    case(op)
        ADD: begin 
            FUNC_alu <= 2'b00;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 0;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b00;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 0;         // 0:rC  1:rA
            MUX_tgt = 2'b01;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 1;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end
        ADDI: begin 
            FUNC_alu = 2'b00;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 1;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b00;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 0;         // 0:rC  1:rA
            MUX_tgt = 2'b01;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 1;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end
        NAND: begin 
            FUNC_alu = 2'b01;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 0;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b00;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 0;         // 0:rC  1:rA
            MUX_tgt = 2'b01;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 1;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end
        LUI: begin 
            FUNC_alu = 2'b10;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 1;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 0;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b00;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 0;         // 0:rC  1:rA
            MUX_tgt = 2'b01;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 1;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end
        LW: begin 
            FUNC_alu = 2'b00;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 1;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b00;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 0;         // 0:rC  1:rA
            MUX_tgt = 2'b00;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 1;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end
        SW: begin 
            FUNC_alu = 2'b00;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 1;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b00;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 1;         // 0:rC  1:rA
            MUX_tgt = 2'b00;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 0;          // 0:off 1:on
            WE_dmem = 1;        // 0:off 1:on
        end
        BEQ: begin 
            FUNC_alu = 2'b11;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 0;       // 0:src2_reg, 1: sgn_ext_imm
            if(EQ) MUX_pc = 2'b01;     // 00:PC+1   01:PC+1+imm   10:alu_out
            else MUX_pc = 2'b00;
            MUX_rf = 1;         // 0:rC  1:rA
            MUX_tgt = 2'b00;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 0;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end
        JALR: begin 
            FUNC_alu = 2'b10;   // 00:ADD, 01:NAND, 10:PASS1, 11:EQL
            MUX_alu1 = 0;       // 0:src1_reg, 1: lft_shft_imm
            MUX_alu2 = 0;       // 0:src2_reg, 1: sgn_ext_imm
            MUX_pc = 2'b10;     // 00:PC+1   01:PC+1+imm   10:alu_out
            MUX_rf = 0;         // 0:rC  1:rA
            MUX_tgt = 2'b10;    // 00:mem_out   01:alu_out  10:PC+1
            WE_rf = 1;          // 0:off 1:on
            WE_dmem = 0;        // 0:off 1:on
        end

    endcase
end
endmodule  
