// Created by Tal Oved & Safit levy may 2022
// (c) Technion IIT, Department of Electrical Engineering 2022 


module	Line_object2	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,// current VGA pixel 
					input 	logic signed	[10:0] pixelY,
					input 	logic signed	[10:0] x1, //first point 
					input 	logic	signed   [10:0] y1,  

					output	logic	drawingRequest, 
					output	logic	[7:0]	 RGBout //optional color output for mux 
);
 
// base point
parameter  int x2 = 300;
parameter  int y2 = 300;
parameter  int thick = 5;

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate variables
int signed a;
int signed b;
int signed ep;
assign a = (pixelY - y2)*(x1-x2);
assign b = (y1-y2)*(pixelX-x2);
assign ep = thick*(x1-x2);


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
		// calculate outputs
		if((b-ep) < a  && a<(b+ep) &&(((pixelX>=x1) && (pixelX<=x2) ) ||((pixelX<=x1) && (pixelX>=x2) )) ) begin 
			drawingRequest <=1'b1;
			RGBout <= 8'h0a;
		end
		else begin
					drawingRequest <=1'b0;
			  end 
	end
end 
endmodule 