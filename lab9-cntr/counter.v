module counter #(
    parameter WIDTH = 5
) (
    input wire [WIDTH-1:0] cnt_in,
    input wire enab,
    input wire load,
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] cnt_out
);

    function [WIDTH-1:0] next_count;
        input [WIDTH-1:0] cnt_in_f;
        input [WIDTH-1:0] cnt_out_f;
        input enab_f, load_f, rst_f;
        begin
            if (rst_f)
                next_count = {WIDTH{1'b0}};
            else if (load_f)
                next_count = cnt_in_f;
            else if (enab_f)
                next_count = cnt_out_f + 1;
            else
                next_count = cnt_out_f;
        end
    endfunction

    always @(posedge clk) begin
        cnt_out <= next_count(cnt_in, cnt_out, enab, load, rst);
    end

endmodule