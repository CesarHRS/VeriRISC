module memory #(
    parameter AWIDTH = 5,
    parameter DWIDTH = 8
) (
    input wire [AWIDTH-1:0] addr,
    input wire clk,
    input wire wr,
    input wire rd,
    inout wire [DWIDTH-1:0] data
);

    reg [DWIDTH-1:0] array [0:2**AWIDTH-1];

    always @(posedge clk) begin
        if (wr) begin
            array[addr] <= data;
        end
    end

    assign data = rd ? array[addr] : {DWIDTH{1'bz}};

endmodule