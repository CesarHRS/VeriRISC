module register #(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] data_in,  
    input wire load,
    input wire clk,
    input wire reset,    
    output reg [WIDTH-1:0] data_out
);

always @(posedge clk or posedge reset or posedge load) begin
    if (reset) begin
        data_out <= {WIDTH{1'b0}};
    end else if (load) begin
        data_out <= data_in;
    end else begin
        data_out <= data_out;
    end

    
endmodule