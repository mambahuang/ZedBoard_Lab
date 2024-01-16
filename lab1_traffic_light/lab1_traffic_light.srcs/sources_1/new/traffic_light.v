`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 03:44:18 PM
// Design Name: 
// Module Name: traffic_light
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


module traffic_light(
   output reg [7:0] led,
   input clk,
   input reset,
   input switch
   );
    
   reg [25:0] counter;
   reg div_clk;
   reg [1:0] curr_state, next_state;
    
   parameter
   GREEN = 2'd0,
   YELLOW = 2'd1,
   RED = 2'd2;
    
   // clk divider
   always @(posedge clk or posedge reset)
   begin
       if(reset)
       begin
           counter <= 26'd0;
           div_clk <= 1'b1;
       end
       else
       begin
           if(counter == 26'd50000000)
           begin
               counter <= 26'd0;
               div_clk <= ~div_clk;
           end
           else
           begin
               counter <= counter + 1;
           end
       end
        
   end

   // state
   always @(posedge div_clk or posedge reset)
   begin
       if(reset)
       begin
           curr_state <= GREEN;
       end
       else
       begin
           curr_state <= next_state;
       end
   end

   always @(posedge div_clk or posedge reset)
   begin
        if(reset)
        begin
            if(switch)
            begin
                led[4:0] <= 5'd7;
            end
            else
            begin
                led[4:0] <= 5'd15;
            end
        end
        else
        begin
            if(curr_state == GREEN)
            begin
                if(led[4:0] == 1)
                begin
                    next_state <= YELLOW;
                end
                if(led[4:0] == 0)
                begin
                    led[4:0] <= 5'd1;
                end
                else
                begin
                    led[4:0] <= led[4:0] - 5'd1;
                end
            end
            else if(curr_state == YELLOW)
            begin
                if(led[4:0] == 1)
                begin
                    next_state <= RED;
                end
                
                if(led[4:0] == 0)
                begin
                    if(switch)
                    begin
                        led[4:0] <= 5'd8;
                    end
                    else
                    begin
                        led[4:0] <= 5'd16;
                    end
                end
                else
                begin
                    led[4:0] <= led[4:0] - 5'd1;
                end
            end
            else if(curr_state == RED)
            begin
                if(led[4:0] == 1)
                begin
                    next_state <= GREEN;
                end
                if(led[4:0] == 0)
                begin
                    if(switch)
                    begin
                        led[4:0] <= 5'd7;
                    end
                    else
                    begin
                        led[4:0] <= 5'd15;
                    end
                end
                else
                begin
                    led[4:0] <= led[4:0] - 5'd1;
                end
            end
        end
   end

   // traffic light control
   always @(*)
   begin
    
       case(curr_state)
           GREEN: 
           begin
               led[7:5] <= 3'b001;
           end
           YELLOW:
           begin
               led[7:5] <= 3'b010;
           end
           RED:
           begin
               led[7:5] <= 3'b100;
           end
       endcase
        
   end
    

endmodule


