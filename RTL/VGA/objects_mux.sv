
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // ball 
					input		logic	smileyDrawingRequest, 
					input		logic	[7:0] smileyRGB, 
					     
		  // obstacles
		  			input		logic	squareDrawingRequest, 
					input		logic	[7:0] squareRGB,
				   input		logic	traingleDrawingRequest, // traingle
					input		logic	[7:0] traingleRGB,	
			
			// flipers
			 		input		logic	RfDrawingRequest, 		// right flipper
					input		logic	[7:0] RfRGB,
					input		logic	LfDrawingRequest, 		// left flipper
					input		logic	[7:0] LfRGB,
			  
		  ////////////////////////
	
					input    logic HartDrawingRequest, 		// obstacles on the screen
					input		logic	[7:0] hartRGB,   
					input		logic	[7:0] backGroundRGB,   
					
			//faculties
			      input    logic [4:0] facultiesDR,
					input		logic	[7:0] biologyRGB,
					input		logic	[7:0] csRGB,
					input		logic	[7:0] eeRGB,
					input		logic	[7:0] mathRGB,
				  
					
			// nbumbers 
					input    logic LifeDrawingRequest,
					input		logic	[7:0] LifeRGB,
					
					input		logic unitsDrawingRequest,
					input		logic [7:0] unitsRGB,
					input		logic tensDrawingRequest,
					input		logic [7:0] tensRGB,
					input		logic hundredsDrawingRequest,
					input		logic [7:0] hundredsRGB,
					
					input		logic yearunitsDrawingRequest,
					input		logic [7:0] yearunitsRGB,
					input		logic yeartensDrawingRequest,
					input		logic [7:0] yeartensRGB,
					
			//symbols
			      input		logic heartIconDrawingRequest,			//Heart
					input		logic [7:0] heartIconRGB,
					
					input		logic WinDrawingRequest,					//Winning
					input		logic [7:0] WinRGB,
				   input		logic LostDrawingRequest,					//Losing
					input		logic [7:0] LostRGB,
				   input		logic BallBlockDrawingRequest,			
					input		logic [7:0] BallBlockRGB,
					input		logic standDR,
					input		logic [7:0] standRGB,
				
			//additional faculty	
			
					input		logic	[7:0] physicsRGB,
					
					
			
					output	logic	[7:0] RGBOut
);




// faculties assign 
assign drawing_request_biology = facultiesDR[0];
assign drawing_request_cs = facultiesDR[1];
assign drawing_request_ee = facultiesDR[2];
assign drawing_request_math = facultiesDR[3];
assign drawing_request_physics = facultiesDR[4];


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (smileyDrawingRequest == 1'b1 )   
			RGBOut <= smileyRGB;  //first priority 
			else if (RfDrawingRequest == 1'b1)   //Right Flipper
						RGBOut <= RfRGB;
						else if (LfDrawingRequest == 1'b1)  //Left Flipper
							RGBOut <= LfRGB;
							else if (LifeDrawingRequest == 1'b1)  //Life display
								RGBOut <= LifeRGB;
								  //Total score display
								  else if (unitsDrawingRequest == 1'b1)  
											RGBOut <= unitsRGB;
										  else if (tensDrawingRequest == 1'b1)
															RGBOut <= tensRGB;
												 else if (hundredsDrawingRequest == 1'b1)
																RGBOut <= hundredsRGB;	
															//Single year score display
															else if (yearunitsDrawingRequest == 1'b1)
																	RGBOut <= yearunitsRGB;
																else if(yeartensDrawingRequest==1'b1)
																			RGBOut <= yeartensRGB;
																				else if (WinDrawingRequest == 1'b1) //winning symbol
																							RGBOut <= WinRGB;
																						else if(LostDrawingRequest==1'b1) //losing symbol
																									RGBOut <= LostRGB;
																									else if (squareDrawingRequest == 1'b1) //square
																												RGBOut <= squareRGB;
																											else if(traingleDrawingRequest==1'b1) //traingle
																														RGBOut <= traingleRGB; 
																													else if(drawing_request_biology==1'b1) //Biology
																																RGBOut <= biologyRGB;
																															else if(drawing_request_cs==1'b1) //CS  
																																			RGBOut<=csRGB;
																																	else if(drawing_request_ee==1'b1) //EE
																																				RGBOut<=eeRGB;
																																			else if(drawing_request_math==1'b1) //Math
																																						RGBOut<=mathRGB;
																																						else if(drawing_request_physics==1'b1) //Physics
																																									RGBOut<=physicsRGB;
																																								else if(heartIconDrawingRequest==1'b1) //heart icon
																																										  RGBOut<=heartIconRGB;
																																										else if (HartDrawingRequest == 1'b1) //hart matrix
																																													RGBOut <= hartRGB;
																																													else if (standDR == 1'b1)   //stand for the ball
																																													RGBOut <= standRGB;
																																															else if (BallBlockDrawingRequest == 1'b1) //ball block
																																																		RGBOut<=BallBlockRGB;		
																																																	else 
																																																			RGBOut <= backGroundRGB ; // last priority 
			end 
	end

endmodule


