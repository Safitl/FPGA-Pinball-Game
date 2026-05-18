//-- feb 2021 add all colors square 
// (c) Technion IIT, Department of Electrical Engineering 2021


module	back_ground_draw	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,
					input	logic nextlevel,

					output	logic	[7:0]	BG_RGB,
					output	logic		boardersDrawReq 
);

const int	xFrameSize	=	635;
const int	yFrameSize	=	475;
const int	bracketOffset =	30;
const int   COLOR_MARTIX_SIZE  = 16*8 ; 				// 128 

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;
logic [10:0] shift_pixelX;
logic [2:0] level ;


localparam logic [2:0] DARK_COLOR = 3'b111 ;			// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;		// bitmap of a light color


localparam  int White2_LEFT_X  = 352 ;
localparam  int GREEN_RIGHT_X  = 351 ;
localparam  int GREEN_LEFT_X  = 224 ;
localparam  int White1_RIGHT_X  = 224 ;
 
parameter  logic [10:0] COLOR_MATRIX_TOP_Y  = 100 ; 
parameter  logic [10:0] COLOR_MATRIX_LEFT_X = 100 ;

 

// this is a block to generate the background 
//it has four sub modules : 

	// 1. draw the yellow borders
	// 2. draw four lines with "bracketOffset" offset from the border 
	// 3. draw 3 rectangles across the screen 	

 
 
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR ;
				level <=3'd1;
	end 
	else begin

	//defaults 
		greenBits <= 3'b110 ; 
		redBits <= 3'b010 ;
		blueBits <= LIGHT_COLOR;
		boardersDrawReq <= 	1'b0 ; 
		if(nextlevel ==1'b1 && level <=3'd4) level <= level +1'd1 ; 
					
	//1. draw the yellow borders 
		if (pixelX == 0 || pixelY == 0  || pixelX == xFrameSize || pixelY == yFrameSize)
			begin 
					redBits <= 3'b111 ;	
					greenBits <= 3'b000  ;	
					blueBits <= 2'b10 ;	// 3rd bit will be truncated
			end
	//2. draw  four lines with "bracketOffset" offset from the border 
		
		if (        pixelX == bracketOffset ||
						pixelY == bracketOffset ||
						pixelX == (xFrameSize-bracketOffset) || 
						pixelY == (yFrameSize-bracketOffset)) 
			begin 
					redBits <= 3'b111 ;	
					greenBits <= 3'b000  ;	
					blueBits <= 2'b10 ;
					boardersDrawReq <= 	1'b1 ; // pulse if drawing the boarders
					
	//3. Draw 3 rectangles across the screen		
			end else if (pixelX <= White1_RIGHT_X)begin 
								greenBits <= 3'b111 ; 
								redBits <= 3'b101 ;
								blueBits <= 2'b11;
						end else	if (pixelX <=GREEN_RIGHT_X && pixelX >=GREEN_LEFT_X ) begin
									if(level ==3'd1)begin		
														greenBits <= 3'b111 ; 
														redBits <= 3'b100 ;
														blueBits <= 2'b11; 
									end else
									if(level ==3'd2)begin		             //green 190
														greenBits <= 3'b111 ; 
														redBits <= 3'b101 ;
														blueBits <= 2'b10; 
									end else
									if(level ==3'd3)begin		            //pink 251
														greenBits <= 3'b110 ; 
														redBits <= 3'b111 ;
														blueBits <= 2'b11; 
									end else
									if(level ==3'd4)begin		
														greenBits <= 3'b111 ; 
														redBits <= 3'b100 ;
														blueBits <= 2'b11; 
									end
									end else if (pixelX >=   White2_LEFT_X ) begin   
														greenBits <= 3'b111 ; 
														redBits <= 3'b101 ;
														blueBits <= 2'b11;
									end	

	
	BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 
			

	end //else
end //always_ff
endmodule

