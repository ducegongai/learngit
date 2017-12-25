`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/24 14:48:54
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
input wire rd_trig,
input wire rst,
input wire clk,
input wire wr_trig,
output wire [7:0] dout,
output wire empty,
output wire full
    );
reg[7:0]data_in[15:0];
initial
begin
data_in[15] = 8'h0f; data_in[14] = 8'h0e; data_in[13] = 8'h0d; data_in[12] = 8'h0c;
data_in[11] = 8'h0b; data_in[10] = 8'h0a; data_in[9] = 8'h09; data_in[8] = 8'h08;
data_in[7] = 8'h07; data_in[6] = 8'h06; data_in[5] = 8'h05; data_in[4] = 8'h04;
data_in[3] = 8'h03; data_in[2] = 8'h02; data_in[1] = 8'h01; data_in[0] = 8'h00;
end
reg[1:0] next_state;
parameter ini = 2'b00, wr_fifo = 2'b01 , ready = 2'b11 , rd_fifo = 2'b10;
reg wr_en;
reg rd_en;
reg[7:0] din;
reg[3:0] j;
fifo_generator_0 Inst_fifo1(
    .clk(clk),
    .rst(rst),
    .din(din),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .dout(dout),
    .full(full),
    .empty(empty)
);
always@(posedge rst or posedge clk)
begin
    if(rst)
        begin
            next_state<=ini;
            j<=0;
            rd_en<=1'b0;
            wr_en<=1'b0;
         end
     else
        begin
            case(next_state)
                ini:
                    begin
                        j<=0;
                        rd_en<=1'b0;
                    if(wr_trig == 1'b1)
                        next_state<=wr_fifo;
                    end
                 wr_fifo:
                 begin
                    din<=data_in[j];
                     if(j == 15)
                        next_state<=ready;
                     else
                        begin
                            j<=j+1;
                            wr_en<=1'b1;
                            next_state<=wr_fifo;
                        end
        end
      ready:
        begin
            j <= 0;
            wr_en<=1'b0;
                if(rd_trig == 1'b1)
                    next_state <= rd_fifo;
                else
                    next_state<=ready;
        end
       rd_fifo:
        begin
            if(j == 15)
                next_state<=ini;
            else
                begin
                j<=j+1;
                rd_en<=1'b1;
                next_state<=rd_fifo;
          end
      end
  endcase
end
end
endmodule








