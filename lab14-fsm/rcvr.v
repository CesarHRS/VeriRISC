module rcvr
(
  input  wire      clock   ,
  input  wire      reset   ,
  input  wire      data_in ,
  input  wire      reading ,
  output reg       ready   ,
  output reg       overrun ,
  output reg [7:0] data_out
);

  // For proper operation the FSM must hard-code the MATCH
  localparam [7:0] MATCH = 8'hA5 ; // 10100101
  // Opportunity for Gray encoding as path is mostly linear
  localparam [3:0] HEAD1=4'b0000, HEAD2=4'b0001, HEAD3=4'b0011, HEAD4=4'b0010,
                   HEAD5=4'b0110, HEAD6=4'b0111, HEAD7=4'b0101, HEAD8=4'b0100,
                   BODY1=4'b1100, BODY2=4'b1101, BODY3=4'b1111, BODY4=4'b1110,
                   BODY5=4'b1010, BODY6=4'b1011, BODY7=4'b1001, BODY8=4'b1000;

  reg [3:0] state ;
  reg [6:0] body_reg ;

  always @(posedge clock)

    if (reset) begin

        // CLEAR ALL CONTROL REGISTERS TO INACTIVE STATE (IGNORE DATA REGISTERS)
        state <= HEAD1;
        ready <= 1'b0;
        overrun <= 1'b0;

      end

    else begin

        // WHEN IN EACH STATE WHAT MOVES FSM TO WHAT NEXT STATE?
        case ( state )

          HEAD1: state <= ( data_in) ? HEAD2 : HEAD1 ; 
          HEAD2: state <= (!data_in) ? HEAD3 : HEAD2 ; 
          HEAD3: state <= ( data_in) ? HEAD4 : HEAD3 ; 
          HEAD4: state <= (!data_in) ? HEAD5 : HEAD4 ; 
          HEAD5: state <= (!data_in) ? HEAD6 : HEAD5 ; 
          HEAD6: state <= ( data_in) ? HEAD7 : HEAD6 ; 
          HEAD7: state <= (!data_in) ? HEAD8 : HEAD7 ; 
          HEAD8: state <= ( data_in) ? BODY1 : HEAD8 ; 

          BODY1: state <= BODY2 ;
          BODY2: state <= BODY3 ;
          BODY3: state <= BODY4 ;
          BODY4: state <= BODY5 ;
          BODY5: state <= BODY6 ;
          BODY6: state <= BODY7 ;
          BODY7: state <= BODY8 ;
          BODY8: state <= HEAD1 ;
        
        endcase

        // IF STATE IS BODY? THEN SHIFT DATA INPUT LEFT INTO BODY REGISTER
        if(state == BODY1 || state == BODY2 || state == BODY3 ||
           state == BODY4 || state == BODY5 || state == BODY6 ||
           state == BODY7 || state == BODY8) 
        begin
          body_reg <= {body_reg, data_in};
        end

        // IF STATE IS BODY8 THEN COPY CONCATENATION OF BODY REGISTER AND INPUT
        // DATA TO OUTPUT REGISTER
        if(state == BODY8) begin
          data_out <= {body_reg, data_in};
        end

        // IF STATE IS BODY8 THEN SET READY ELSE IF READING THEN CLEAR READY
        if(state == BODY8) begin
          ready <= 1;        
        end else if (reading) begin
          ready <= 0;
        end

        // IF READING THEN CLEAR OVERRUN, ELSE
        // IF STATE IS BODY8 AND STILL READY THEN SET OVERRUN
        if(reading) begin
          overrun <= 0;;        
        end else if (state == BODY8 && ready) begin
          overrun <= 1;
        end      

      end

endmodule
