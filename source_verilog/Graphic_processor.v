`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2023 12:18:18
// Design Name: 
// Module Name: Graphic_processor
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


module Graphic_processor(in,clkin,ledr,ledc);
input clkin;
input wire [11:0]in;
wire [2:0]x[3:0];

assign x[0] = in[11:9];//paddle 1 center
assign x[1] = in[8:6];//paddle 2 center
assign x[2] = in[2:0];//row ball
assign x[3] = in[5:3];//col ball

output reg [7:0]ledr;
output reg [7:0]ledc;
reg [2:0]counter = 3'd0;

ClockDividerc d1(clkin,clkout);

// code for column refreshing

always@(posedge clkout)
begin
    
    case(counter)
    3'd0: ledc <= 8'b10000000;
    3'd1: ledc <= 8'b01000000;
    3'd2: ledc <= 8'b00100000;
    3'd3: ledc <= 8'b00010000;
    3'd4: ledc <= 8'b00001000;
    3'd5: ledc <= 8'b00000100;
    3'd6: ledc <= 8'b00000010;
    3'd7: ledc <= 8'b00000001;
    endcase
    if (counter == 3'd7)
    begin
        counter <= 3'd0;
    end
    else
    begin
        counter <= counter + 3'd1;
    end
end



// code for row outpur for the column

always@(posedge clkout)
begin
    case(counter)
        3'd0:
        begin ledr <= 8'b11111111;
            ledr[x[0]-1] <= 0;
            ledr[x[0]] <= 0;
            ledr[x[0]+1] <= 0;
            if (x[3] == 3'd0)
                ledr[x[2]] <= 0;
        end
        
        3'd1:
        begin ledr <= 8'b11111111;
            if (x[3] == 3'd1)
                ledr[x[2]] <= 0;
        end
        
        3'd2:
        begin ledr <= 8'b11111111;
            if (x[3] == 3'd2)
                ledr[x[2]] <= 0;
        end
        
        3'd3:
        begin ledr <= 8'b11111111;
            if (x[3] == 3'd3)
                ledr[x[2]] <= 0;
        end
        
        3'd4:
        begin ledr <= 8'b11111111;
            if (x[3] == 3'd4)
                ledr[x[2]] <= 0;
        end
        
        3'd5:
        begin ledr <= 8'b11111111;
            if (x[3] == 3'd5)
                ledr[x[2]] <= 0;
        end
        
        3'd6:
        begin ledr <= 8'b11111111;
            if (x[3] == 3'd6)
                ledr[x[2]] <= 0;
        end
        
        3'd7:
        begin ledr <= 8'b11111111;
            ledr[x[1]-1] <= 0;
            ledr[x[1]] <= 0;
            ledr[x[1]+1] <= 0;
            if (x[3] == 3'd7)
                ledr[x[2]] <= 0;
        end
        
    endcase
    
end
endmodule
