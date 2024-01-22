module VGA_CTRL(
	input clk, 
	input reset_n,
    input [2:0] cmd, // switch data
	output reg hsync, 
	output reg vsync, 
	output [3:0] vga_r, 
	output [3:0] vga_g, 
	output [3:0] vga_b,
    output reg [2:0] led
	);

    // reg [2:0] cmd_reg;

	reg hs_data_en, vs_data_en;
	reg [11:0] data_in;
	reg [9:0] hcount;
	reg [9:0] vcount;

	parameter H_Total = 800 - 1;
	parameter H_Sync = 96 - 1;
	parameter H_Back = 48 - 1;
	parameter H_Active = 640 - 1;
	parameter H_Front = 16 - 1;
	parameter H_Start = 144 - 1;
	parameter H_End = 784 - 1;

	parameter V_Total = 525 - 1;
	parameter V_Sync = 2 - 1;
	parameter V_Back = 33 - 1;
	parameter V_Active = 480 - 1;
	parameter V_Front = 10 - 1;
	parameter V_Start = 35 - 1;
	parameter V_End = 515 - 1;

    // led
    always @(posedge clk or posedge reset_n) begin
        if(reset_n)
            led <= 3'b000;
        else
            led <= cmd;
    end

	always @(posedge clk or posedge reset_n) begin
		if (reset_n) begin
			hcount <= 0;
		end
		else if (hcount == H_Total) begin
			hcount <= 0;
		end
		else begin
			hcount <= hcount + 1;
		end
	end

	always @(posedge clk or posedge reset_n) begin
		if (reset_n) begin
			vcount <= 0;
		end
		else if (vcount == V_Total) begin
			vcount <= 0;
		end
		else if (hcount == H_Total) begin
			vcount <= vcount + 1;
		end
		else begin
			vcount <= vcount;
		end
	end

	always @(posedge clk or posedge reset_n) begin
		if (reset_n) begin
			hsync <= 1;		
		end
		else if (hcount >= 0 && hcount < H_Sync) begin
			hsync <= 0;
		end
		else begin
			hsync <= 1;
		end
	end

	always @(posedge clk or posedge reset_n) begin
		if (reset_n) begin
			vsync <= 1;		
		end
		else if (vcount >= 0 && vcount < V_Sync) begin
			vsync <= 0;
		end
		else begin
			vsync <= 1;
		end
	end


	always @(posedge clk or posedge reset_n) begin
	    if(reset_n)
	        hs_data_en <= 1'b0;
	    else if(hcount >= H_Start && hcount < H_End)
	        hs_data_en <= 1'b1;
	    else
	        hs_data_en <= 1'b0;
	end

	always @(posedge clk or posedge reset_n) begin
	    if(reset_n)
	        vs_data_en <= 1'b0;
	    else if(vcount >= V_Start && vcount < V_End)
	        vs_data_en <= 1'b1;
	    else
	        vs_data_en <= 1'b0;
	end

	
	always @(*) begin

        case(cmd)
            3'b000: begin
                if(hcount >= H_Start && hcount < H_Start + 640)
                    data_in = 12'hfff;
                else
                    data_in = 12'hfff;
            end
            3'b001: begin
                if(hcount >= H_Start && hcount < H_Start + 640)
                    data_in = 12'hf00;
                else
                    data_in = 12'hfff;
            end
            3'b010: begin
                if(hcount >= H_Start && hcount < H_Start + 640)
                    data_in = 12'h0f0;
                else
                    data_in = 12'hfff;
            end
            3'b011: begin
                if(hcount >= H_Start && hcount < H_Start + 640)
                    data_in = 12'h00f;
                else
                    data_in = 12'hfff;
            end
            3'b100: begin
                if(hcount >= H_Start && hcount < H_Start + 160)
                    data_in <= 12'hf00;
                else if(hcount >= H_Start + 160 && hcount < H_Start + 320)
                    data_in <= 12'h0f0;
                else if(hcount >= H_Start + 320 && hcount < H_Start + 480)
                    data_in <= 12'h00f;
                else if(hcount >= H_Start + 480 && hcount < H_Start + 640)
                    data_in <= 12'hfff;
                else
                    data_in <= 12'hfff;
            end
            3'b101: begin
                if(vcount >= V_Start && vcount < V_Start + 120)
                    data_in <= 12'hf00;
                else if(vcount >= V_Start + 120 && vcount < V_Start + 240)
                    data_in <= 12'h0f0;
                else if(vcount >= V_Start + 240 && vcount < V_Start + 360)
                    data_in <= 12'h00f;
                else if(vcount >= V_Start + 360 && vcount < V_Start + 480)
                    data_in <= 12'hfff;
                else
                    data_in <= 12'hfff;
            end
            3'b110: begin
                if(hcount >= H_Start && hcount < H_Start + 160 && vcount >= V_Start && vcount < V_Start + 120)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start + 160 && hcount < H_Start + 320 && vcount >= V_Start && vcount < V_Start + 120)
                    data_in <= 12'h000;
                else if(hcount >= H_Start + 320 && hcount < H_Start + 480 && vcount >= V_Start && vcount < V_Start + 120)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start + 480 && hcount < H_Start + 640 && vcount >= V_Start && vcount < V_Start + 120)
                    data_in <= 12'h000;
                else if(hcount >= H_Start && hcount < H_Start + 160 && vcount >= V_Start + 120 && vcount < V_Start + 240)
                    data_in <= 12'h000;
                else if(hcount >= H_Start + 160 && hcount < H_Start + 320 && vcount >= V_Start + 120 && vcount < V_Start + 240)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start + 320 && hcount < H_Start + 480 && vcount >= V_Start + 120 && vcount < V_Start + 240)
                    data_in <= 12'h000;
                else if(hcount >= H_Start + 480 && hcount < H_Start + 640 && vcount >= V_Start + 120 && vcount < V_Start + 240)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start && hcount < H_Start + 160 && vcount >= V_Start + 240 && vcount < V_Start + 360)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start + 160 && hcount < H_Start + 320 && vcount >= V_Start + 240 && vcount < V_Start + 360)
                    data_in <= 12'h000;
                else if(hcount >= H_Start + 320 && hcount < H_Start + 480 && vcount >= V_Start + 240 && vcount < V_Start + 360)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start + 480 && hcount < H_Start + 640 && vcount >= V_Start + 240 && vcount < V_Start + 360)
                    data_in <= 12'h000;
                else if(hcount >= H_Start && hcount < H_Start + 160 && vcount >= V_Start + 360 && vcount < V_Start + 480)
                    data_in <= 12'h000;
                else if(hcount >= H_Start + 160 && hcount < H_Start + 320 && vcount >= V_Start + 360 && vcount < V_Start + 480)
                    data_in <= 12'hfff;
                else if(hcount >= H_Start + 320 && hcount < H_Start + 480 && vcount >= V_Start + 360 && vcount < V_Start + 480)
                    data_in <= 12'h000;
                else if(hcount >= H_Start + 480 && hcount < H_Start + 640 && vcount >= V_Start + 360 && vcount < V_Start + 480)
                    data_in <= 12'hfff;
                else
                    data_in <= 12'hfff;
            end
            default: begin
                data_in <= 12'hfff;
            end
        endcase
        
    end
	

	assign vga_r = (hs_data_en && vs_data_en) ?  data_in[11:8] : 0;
	assign vga_g = (hs_data_en && vs_data_en) ?  data_in[7:4]  : 0;
	assign vga_b = (hs_data_en && vs_data_en) ?  data_in[3:0]  : 0;
endmodule