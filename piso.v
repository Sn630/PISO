`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2026 16:02:29
// Design Name: 
// Module Name: piso
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

module fsm( 
    input wire clk, 
    input wire rst, 
    input wire s_l, 
    input wire [13:0] p_in, 
    output wire d_out  
); 
     
    wire clk_div; 

    clk_divider inst (  
        .clk(clk), 
        .rst(rst), 
        .led(clk_div)  
    ); 
 
    wire [2:0] d; 
    wire [2:0] q; 
    wire in;                 
    
    PISO piso_inst ( 
        .clk(clk_div),     
        .rst(rst), 
        .s_l(s_l), 
        .p_in(p_in), 
        .serial_out(in) 
    ); 
 
    assign d[2] = ((~q[2]) & q[1] & q[0] & in); 
    assign d[1] = ((~q[2]) & (~q[1]) & q[0] & in) | 
                  ((~q[2]) & q[1] & (~q[0]) & (~in)) | 
                  (q[2] & (~q[1]) & (~q[0]) & (~in)); 
    assign d[0] = ((~q[2]) & (~in)) | 
                  ((~q[1]) & (~q[0]) & (~in)); 
 
    assign d_out = q[2] & (~q[1]) & (~q[0]) & (~in); 
 
    dff d2 (clk_div, rst, d[2], q[2]); 
    dff d1 (clk_div, rst, d[1], q[1]); 
    dff d0 (clk_div, rst, d[0], q[0]); 
 
endmodule 
 

module PISO( 
    input clk, 
    input rst, 
    input s_l, 
    input [13:0] p_in, 
    output serial_out 
); 

    wire [13:0] q; 
    wire [13:0] d_in;            
 
    assign d_in[13] = (s_l) ? 1'b0  : p_in[13]; 
    assign d_in[12] = (s_l) ? q[13] : p_in[12]; 
    assign d_in[11] = (s_l) ? q[12] : p_in[11]; 
    assign d_in[10] = (s_l) ? q[11] : p_in[10]; 
    assign d_in[9]  = (s_l) ? q[10] : p_in[9]; 
    assign d_in[8]  = (s_l) ? q[9]  : p_in[8]; 
    assign d_in[7]  = (s_l) ? q[8]  : p_in[7]; 
    assign d_in[6]  = (s_l) ? q[7]  : p_in[6]; 
    assign d_in[5]  = (s_l) ? q[6]  : p_in[5]; 
    assign d_in[4]  = (s_l) ? q[5]  : p_in[4]; 
    assign d_in[3]  = (s_l) ? q[4]  : p_in[3]; 
    assign d_in[2]  = (s_l) ? q[3]  : p_in[2]; 
    assign d_in[1]  = (s_l) ? q[2]  : p_in[1]; 
    assign d_in[0]  = (s_l) ? q[1]  : p_in[0];   
 
    assign serial_out = (s_l) ? q[0] : 1'b0; 
  
    dff s1 (clk, rst, d_in[0],  q[0]); 
    dff s2 (clk, rst, d_in[1],  q[1]); 
    dff s3 (clk, rst, d_in[2],  q[2]); 
    dff s4 (clk, rst, d_in[3],  q[3]); 
    dff s5 (clk, rst, d_in[4],  q[4]); 
    dff s6 (clk, rst, d_in[5],  q[5]); 
    dff s7 (clk, rst, d_in[6],  q[6]); 
    dff s8 (clk, rst, d_in[7],  q[7]); 
    dff s9 (clk, rst, d_in[8],  q[8]); 
    dff s10(clk, rst, d_in[9],  q[9]); 
    dff s11(clk, rst, d_in[10], q[10]); 
    dff s12(clk, rst, d_in[11], q[11]); 
    dff s13(clk, rst, d_in[12], q[12]); 
    dff s14(clk, rst, d_in[13], q[13]); 

endmodule 
 

module dff( 
    input clk, 
    input rst, 
    input d, 
    output reg q 
); 
    always @(posedge clk) begin 
        if (rst) 
            q <= 0; 
        else 
            q <= d; 
    end 
endmodule 
 
 
module clk_divider( 
    input wire clk, 
    input wire rst, 
    output reg led 
); 
    localparam integer COUNT = 100 - 1; 
    reg [25:0] counter = 0; 
 
    always @(posedge clk ) begin 
        if (rst) begin 
            counter <= 0; 
            led <= 1'b0; 
        end else begin 
            if (counter == COUNT) begin 
                counter <= 0; 
                led <= ~led; 
            end else begin 
                counter <= counter + 1; 
            end 
        end // Added missing end for outer 'else begin'
    end // Added missing end for 'always' block
endmodule // Added missing endmodule