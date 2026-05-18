
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	smileyface_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,        // short pulse every start of frame 30Hz 
					input	logic	Y_direction,         //change the direction in Y to up  
					input	logic	toggleX, 	         //toggle the X direction 
					input logic collision,           //collision if smiley hits an object
					input logic flipperHit,
					input	logic	[3:0] HitEdgeCode,   //one bit per edge 
					input logic TrnglHit,
					input logic Fall,
					input logic raispeed,
					input logic [9:0] SpeedShot,
					input logic HitEE,

					output	 logic signed 	[10:0]	topLeftX,  // output the top left corner 
					output	 logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
					output logic HitBottom
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 570;
parameter int INITIAL_Y = 400;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int MAX_Y_SPEED = 230;
const int  Y_ACCEL = -2;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 32;

int Xspeed, topLeftX_FixedPoint;         // local parameters 
int Yspeed, topLeftY_FixedPoint;



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	else begin
					///// ball shot system ///
		if (raispeed) begin                  // button was stopped being pushed, to go upwards 
				Yspeed <= -SpeedShot ;         // change speed to go up as time pressed 
		end  
	// colision Calcultaion 
		// down border colliosion 
		if(Fall==1 )begin
			Yspeed	<= INITIAL_Y_SPEED;
			topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		end
		//hit bit map has one bit per edge:  Left-Top-Right-Bottom	 
		HitBottom <=0;
		// colision with EE
		if(collision && HitEE) begin
			Yspeed <= -200 ;
		end else
		if ((collision && HitEdgeCode [2] == 1 ))  	// hit top border of brick  
				if (Yspeed < 0) begin 						// while moving up
						Yspeed <= -Yspeed/2 ; 
				end	
		if ((collision && HitEdgeCode [0] == 1 && flipperHit)) begin		//hit bottom border of brick and flipper  	
			Yspeed <= -Yspeed -120 ; 
			HitBottom <=1'b1;
		end else	if ((collision && HitEdgeCode [0] == 1 )) begin				//hit bottom border of brick 
								Yspeed <= -15 ; 
								HitBottom <=1'b1;
					 end
			
		// perform  position and speed integral only 30 times per second 
		
		if (startOfFrame == 1'b1) begin 
		
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed;   		// position interpolation 
				
				if (Yspeed < MAX_Y_SPEED  ) 											//limit the spped while going down  && topLeftX<230
						Yspeed <= Yspeed  - Y_ACCEL ; 								//deAccelerate : slow the speed down every clock tick 
		
								
				if (Y_direction) begin 													// button was pushed to go upwards 	
							Yspeed <= -160 ;  											// change speed to go up 
						
				end  


		end
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	else begin
		// down border colliosion 
		if(Fall==1)begin
			Xspeed	<= INITIAL_X_SPEED;
			topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		end
				  
		if (TrnglHit)  
	
					Xspeed <= Yspeed; 
	// colision with EE
		if(collision && HitEE) begin
			Xspeed <= 130 ;
		end else begin
			// collisions with the sides 			
			if (collision && HitEdgeCode [3] == 1 ) begin  
						if (Xspeed < 0 ) 				// while moving left
								Xspeed <= -Xspeed ; // positive move right 
		end
			
		if (collision && HitEdgeCode [1] == 1 ) begin  			// hit right border of brick  
				if (Xspeed > 0 ) 											//  while moving right
						Xspeed <= -Xspeed   ;  							// negative move left  
				end else	if(collision && HitEdgeCode [1] == 1 )
								 Xspeed <= -Xspeed  ;	
		
		end
	   if (startOfFrame == 1'b1 )
				     topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
			
	
					
			
	end//else
	
end//always

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
