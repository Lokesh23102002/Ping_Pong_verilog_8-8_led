`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2023 11:53:16
// Design Name: 
// Module Name: ping_pong
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
module BCD(In,out);
input [3:0]In;
output reg[6:0]out;
always@(In)
begin
case(In)
4'd0: out <= 7'b0000001;
4'd1: out <= 7'b1001111;
4'd2: out <= 7'b0010010;
4'd3: out <= 7'b0000110;
4'd4: out <= 7'b1001100;
4'd5: out <= 7'b0100100;
4'd6: out <= 7'b0100000;
4'd7: out <= 7'b0001111;
4'd8: out <= 7'b0000000;
4'd9: out <= 7'b0000100;
endcase
end
endmodule



module ping_pong(up1,up2,down1,down2,start,clkin,ledr,ledc,clkout,outs,en);
input up1,up2,down1,down2,start;
input clkin;
output clkout;
reg [11:0]ploc=12'b001001100100;
reg vx = 1;
reg [1:0]vy = 2'd2;
reg [3:0]score1 = 4'd0;
reg [3:0]score2 = 4'd0;
output reg [6:0]outs;
output reg [3:0]en;





reg res = 0;
ClockDividerc C2(clkin, clkouts);
reg resetb = 0;
wire [6:0]ou1,ou2;
BCD B1(score1 , ou1);
BCD B2(score2, ou2);
always@(posedge clkouts)
begin
if (res == 0)
begin
    en = 4'b0111;
    outs <= ou1;
    res <= 1;
end
else if(res == 1)
begin
    en = 4'b1110;
    outs <= ou2;
    res <= 0;
end
end



output [7:0]ledr,ledc;

//x x x x x x x x
//x x x x x x x x
//x x x x x x x x
//0 x x x x x x x
//0 x x x 0 x x 0
//0 x x x x x x 0
//x x x x x x x 0
//x x x x x x x x

wire clkout;


Graphic_processor G1(ploc,clkin,ledr,ledc);
ClockDivider C1(clkin,clkout);

//paddle controls
always@(posedge clkout)
begin
    
    if (start == 1 )
    begin
        //control for player 1 paddle
        if (down1 == 1 & up1 == 1)
        begin
            ploc[11:9] = ploc[11:9];  
        end
        else
        begin
            if ((down1 == 1) & (ploc[11:9] != 3'd6))
            begin
                ploc[11:9] = ploc[11:9]+3'd1;           
            end
            
            if ((up1 == 1) & (ploc[11:9] != 3'd1))
            begin
                ploc[11:9] = ploc[11:9]-3'd1;         
            end
         end
         
        //control for player 2 paddle
        if (down2 == 1 & up2 == 1)
        begin
            ploc[8:6] = ploc[8:6]; 
        end
        else 
        begin 
            if ((down2 == 1) & (ploc[8:6] != 3'd6))
            begin
                ploc[8:6] = ploc[8:6]+3'd1;
                     
            end
            
            if ((up2 == 1) & (ploc[8:6] != 3'd1))
            begin
                ploc[8:6] = ploc[8:6]-3'd1;        
            end
        end
        
     end
        
    
end

//positon of ball changing according to velocity
always@(posedge clkout)
begin
    
    if ((start == 1) & (resetb==0))
    begin
// ball-x velocity
        if(vx == 0)
        begin
            ploc[5:3] <= ploc[5:3] +1;
        end
        else
        begin 
            ploc[5:3] <= ploc[5:3] - 1;
        end
        
        //ball-y velocity
        if(vy == 2'd0) // downward y velocity
        begin
            ploc[2:0] <= ploc[2:0] +1;
        end
        else if(vy == 2'd1) // upward y velocity
        begin
            ploc[2:0] <= ploc[2:0]-1;
        end
        else
        begin 
            ploc[2:0] <= ploc[2:0];
        end
    end
    else if((start ==1) & (resetb == 1) )
    begin
    ploc[5] <= 0;
    ploc[4]  <= 1;
    ploc[3]  <=1;
    ploc[2]  <=0;
    ploc[1]  <=1;
    ploc[0]  <=1;
    
    end
end



//ball collission
always@(negedge clkout)
begin
    //collision of ball on middle of each paddle than  x velocity
    if (ploc[5:3]== 3'd6)
    begin
        
        if ((ploc[2:0] == ploc[8:6]) & (ploc[2:0]!= 3'd0) & (ploc[2:0]!= 3'd7))
         begin 
            vy <= 2'd2;
            vx <= 1; 
         end
         
         else if ((ploc[2:0] == ploc[8:6]+1)& (ploc[2:0]!= 3'd0) & (ploc[2:0]!= 3'd7))
         begin 
            vy <= 2'd0;
            vx <= 1; 
         end
         
         else if ((ploc[2:0] == ploc[8:6]-1) & (ploc[2:0]!= 3'd0) & (ploc[2:0]!= 3'd7))
         begin 
            vy <= 2'd1;
            vx <= 1; 
         end
         else
         begin
            vx <= 0;
         end
         
    end
    else 
    
    if(ploc[5:3]== 3'd1)
    begin
         
        if ((ploc[2:0] == ploc[11:9]) & (ploc[2:0]!= 3'd0) & (ploc[2:0]!= 3'd7))
         begin 
            vy <= 2'd2;
            vx <= 0;
         end
         
         else if ((ploc[2:0] == ploc[11:9]+1) & (ploc[2:0]!= 3'd0) & (ploc[2:0]!= 3'd7))
         begin 
            vy <= 2'd0;
            vx <= 0;
         end
         
         else if ((ploc[2:0] == ploc[11:9]-1) & (ploc[2:0]!= 3'd0) & (ploc[2:0]!= 3'd7))
         begin 
            vy <= 2'd1;
            vx <= 0;
         end
         else
         begin
            vx <= 1;
         end
         
    end
    if (resetb == 0)
    begin
    //scoring criterion
        if(ploc[5:3]== 3'd7)
        begin
            score1 <= score1+1;
            vx <= 1;
            resetb <=1;
           
           
          
        end
        else if(ploc[5:3]== 3'd0)
        begin
            score2 <= score2+1;
            vx <= 0;
           resetb <= 1;
        
            
        end
    end
    else if((resetb == 1))
    begin
    resetb <= 0;
    end
    
   
    
    // boundary of the board
    if(ploc[2:0] == 3'd0)
    begin
        vy <= 2'd0;
    end 
    
    if(ploc[2:0] == 3'd7)
    begin
        vy <= 2'd1;
    end 
end


endmodule


//module sim();
//wire [7:0]ledr,ledc;
//wire clkout;
//wire [11:0]ploc;
//reg up1,up2,down1,down2,start,reset,clkin;
//wire [3:0]score1;
//wire [3:0]score2; 
//ping_pong g1(up1,up2,down1,down2,start,reset,clkin,ledr,ledc,clkout,ploc,score1,score2);

//initial begin
//clkin = 0;
//start = 1;
//#100000000
//$finish;
//end

//always 
//      #4  clkin =  ! clkin; 
//endmodule


