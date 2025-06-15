`ifndef USE_CASE
  `ifndef USE_IF
    `define USE_IF
  `endif
`else
  `ifdef USE_IF
    `undef USE_IF
  `endif
`endif

module mux
(
    input wire select[1:0],
    input wire in1, in2, in3, clk,
    
    output reg mux_out
);
    reg temp;
    always @(postedge clk) begin
        mux_out <= temp;
    end

    always @* begin
        `ifnfef USE_IF
            if (select <= 1) 
                temp = in1;
            else if (select == 2) 
                temp = in2;
            else if (select >= 3) 
                temp = in3;
        `endif
        `ifdef USE_CASE
            case (1)
                (select <= 1) : temp = in1;
                (select == 2) : temp = in2;
                (select >= 3) : temp = in3;
            endcase
        `endif
    end

endmodule


`undef USE_CASE
`undef USE_IF
