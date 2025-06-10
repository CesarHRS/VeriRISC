module driver #(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] data_in,
    input wire data_en, 
    output reg [WIDTH-1:0] data_out
);

always @(*) begin
    if (data_en) begin
        data_out = data_in;
    end else begin
        data_out = {WIDTH{1'bz}};
    end

end

endmodule