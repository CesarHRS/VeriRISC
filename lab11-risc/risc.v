module risc (
    input wire clk,
    input wire rst,
    output wire halt
);
    
    localparam integer AWIDTH = 5, DWITDH = 8;
    wire [2:0] phase, opcode;
    wire [AWIDTH-1:0] addr, data;
    wire [DWIDTH-1:0] acc_out, alu_out;

    // counter
    counter #(
        .WIDTH(3)
    ) counter_clk (
        .clk(clk),
        .rst(rst),
        .load(1'b0),
        .enab(!halt),
        .cnt_in(3'b0),
        .cnt_out(phase)
    );

    // pc (não é um registrador, mas um contador)
    counter #(
        .WIDTH(AWIDTH)
    ) counter_pc (
        .clk(clk),
        .rst(rst),
        .load(ld_pc),
        .enab(inc_pc),
        .cnt_in(ir_addr),
        .cnt_out(pc_addr)
    );

    //mux
    multiplexor #(
        .WIDTH(AWIDTH)
    ) mux (
        .sel(sel),
        .in0(ir_addr),
        .in1(pc_addr),
        .out(addr)
    );

    // main memory
    memory #(
        .AWIDTH(AWIDTH),
        .DWIDTH(DWITDH)
    ) main_memory (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data(data),
        .rd(rd),
        .wr(wr)
    );

    // ir
    register #(
        .WIDTH(AWIDTH)
    ) ir (
        .clk(clk),
        .rst(rst),
        .ld(ld_ir),
        .data_in(data),
        .data_out({opcode,ir_addr}) // opcode + ir, que resolta na instrução
    );

    // acc
    register #(
        .WIDTH(DWITDH)
    ) acc (
        .clk(clk),
        .rst(rst),
        .load(ld_ac),
        .data_in(alu_out),
        .data_out(acc_out)
    );

    //ula
    alu #(
        .WIDTH(DWITDH)
    ) alu_inst (
        .opcode(opcode),
        .in_a(acc_out),
        .in_b(data),
        .a_is_zero(zero),
        .alu_out(alu_out)
    );

    //driver
    driver #(
        .WIDTH(DWITDH)
    ) driver_inst (
        .clk(clk),
        .rst(rst),
        .data_in(alu_out),
        .data_out(data)
    );

endmodule