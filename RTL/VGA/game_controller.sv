
// game controller Tal&Safit April 2022
// (c) Technion IIT, Department of Electrical Engineering 2022 
//updated --Tal & Safit May 2022


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input logic ResetUser,
			input	logic	startOfFrame,  								// short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,						// ball
			input	logic	drawing_request_1,							// square
			input logic drawing_request_2, 							// brackets
			input logic drawing_request_3, 							// HartMatrix objects
			input logic drawing_request_Flr, 						// flipper right
			input logic drawing_request_FlL, 						// flipper left
			input logic drawing_request_trngl, 						//traingle in the right top of the screen
			input logic shot, 											//down key is pressed for shooting
			input logic HitBottom,
			input logic BallBlockDR,
			input logic standDR,
			input logic [4:0] facultiesDR,
			
			output logic raispeed,  									//tells the ball movement unit to add velocity to ySpeed
			output logic collision, 									// active in case of collision between two objects
			output logic SingleHitPulse, 								// critical code, generating A single pulse in a frame 
			output logic FlipperHit,                           // active when the ball hit one of the flippers
			output logic TrnglHit,        							//active in case of collision between the ball and the top right traingle
			output logic [10:0] scoreall,            				//beign sent to the scoreAll unit dispay
			output logic [10:0] score,          				   //beign sent to the score by year unit dispay
			output logic [3:0] life,                   			//how many lives the ball has left
			output logic NextLevel,                            //active when it's time to switch to new level (according to the points)
			output logic Winning,                              //active when the the player reached to 160 points
			output logic Losing,											//active when the ball falls and hasn't left with more lives
			output logic [9:0] speedShot,                      //the increment to the ball speed after the player presses the shooting button
			output logic Fall ,       								   //active when the ball falls of the bottom section of the screen
			output logic  BallBlock,                           //active when the ball hit top right traingle
			output logic HitBio,
			output logic HitEE,
			output logic RandReset,										//active every fall
			output logic [10:0] Yshooter,								//calculate the Y pixel the pencil should be found according to the shooting press time.
			output logic step2
);



parameter MaxSpeed =530;

int HitTVal = 23'd900000; // Hit Timer Value 

logic [23:0] HitTimer; // Times between legal hits
logic [23:0] Load ;  // speed load to the shooting machine
logic raiflag;

// Drawing Request assigns

assign drawing_request_biology = facultiesDR[0];
assign drawing_request_cs = facultiesDR[1];
assign drawing_request_ee = facultiesDR[2];
assign drawing_request_math = facultiesDR[3];
assign drawing_request_physics = facultiesDR[4];


// collision logics
assign collision = ( drawing_request_Ball &&( ( drawing_request_1 )|| (drawing_request_2)|| (drawing_request_3) || 
(drawing_request_Flr) || (drawing_request_FlL )|| (drawing_request_trngl)||
( drawing_request_biology)||(drawing_request_cs)||(drawing_request_ee)||
(drawing_request_math)|| ( BallBlockDR && BallBlock)|| (standDR )||
(drawing_request_physics)));  // any collision 
	
assign HitBio = (drawing_request_Ball &&  drawing_request_biology ) ;
assign HitEE = (drawing_request_Ball &&  drawing_request_ee );	
assign HitMath = (drawing_request_Ball &&  drawing_request_math ) ;
assign HitPhysics = (drawing_request_Ball &&  drawing_request_physics );	
assign HitCS = (drawing_request_Ball &&  drawing_request_cs ) ;
assign bordercollision = (drawing_request_Ball &&  drawing_request_2 );	
assign FlipperHit = 	((drawing_request_Ball &&  drawing_request_Flr )|| (drawing_request_Ball &&  drawing_request_FlL))	;
assign TrnglHit =(drawing_request_Ball &&  drawing_request_trngl ) ;

// state machine decleration 
 enum logic [2:0] {s_idle, s_shooting, s_step1, s_step2, s_step3, s_step4,s_endgame } game_ps, game_ns;


logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN )
begin
	if(!resetN)
	begin
        game_ps <= s_idle;
		  scoreall <=11'd0;
	     score <= 11'd0;
		  life<=4'd3;	
		  speedShot<=10'd270;
		  flag	<= 1'b0;
		  SingleHitPulse <= 1'b0 ;
			HitTimer <=1'b0;
			Load<=23'd0;
			BallBlock <= 1'b0;
			Yshooter<=11'd394;
			raiflag <=1'b0;
	end 
	else begin 
	
         game_ps <= game_ns; // default	
			SingleHitPulse <= 1'b0 ; 
			if(TrnglHit == 1'b1) BallBlock <= 1'b1;
			if(Fall ==1'b1 ) begin
				BallBlock <= 1'b0;
				raiflag<=1'b0;
			end
			if(HitTimer >8'b0) HitTimer <= HitTimer-8'd1;
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
			if( game_ps == s_idle)begin
			speedShot <= 10'd300;
			end
			if(  shot == 1'b1 && speedShot<MaxSpeed && Load==23'd0 ) begin    // shooting speed load
					speedShot <= speedShot + 8'd1;
					Load <= 23'd150000;
					if(Yshooter <=11'd424) Yshooter <= Yshooter +11'd1;
			end 
			else  if( shot == 1'b1 && Load > 8'd0  ) begin 
								Load <= Load -23'd1;
							end 
							else if ( shot == 1'b0   && Yshooter > 11'd394) begin    // shooting speed de-load.
								Yshooter<= Yshooter-11'd1;
							end
					
				if( HitTimer ==1'b0 && (HitEE || HitCS || HitMath || HitPhysics || HitBio) )	HitTimer <= HitTVal;

///////////////steps///////////

////step 1/////
	if(game_ps == s_step1) begin 
		Fall<=1'b0;
		if(HitBio && HitTimer ==1'b0) begin
					score<=score+1;
					scoreall <=scoreall+1;				
		end else
		if(HitCS && HitTimer ==1'b0) begin
					score <=score+3;
					scoreall <=scoreall+3;
		end else
		if(HitEE && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+2;	
		end else
		if(HitMath && HitTimer ==1'b0) begin
					score <=score+4;
					scoreall <=scoreall+11'd4;
		end else
		if(HitPhysics && HitTimer ==1'b0) begin
					score <=score+3;
					scoreall <=scoreall+11'd3;
		end 
		if(bordercollision && HitBottom) begin
			life<=life-1'd1;
			Fall <=1'b1;
		
end
end

/////step 2 ////
else if(game_ps == s_step2)begin 
		Fall<=1'b0;
		if(score>=11'd40) begin 
					score <= scoreall -11'd40;
		end else
		if(HitBio && HitTimer ==1'b0) begin
					score<=score+1;
					scoreall <=scoreall+1;
		end else
		if(HitCS && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+2;
		end else
		if(HitEE && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+2;
		end else
		if(HitMath && HitTimer ==1'b0) begin
					score <=score+3;
					scoreall <=scoreall+11'd3;
		end else
		if(HitPhysics && HitTimer ==1'b0) begin
					score <=score+3;
					scoreall <=scoreall+11'd3;
			end
		if(bordercollision && HitBottom) begin
			life<=life-1'd1;
			Fall <=1'b1;
end
end

////step 3////
else if(game_ps == s_step3)begin
		Fall<=1'b0;
		if(score>=11'd40) begin 
					score <= scoreall -11'd80 ;
		end else
		if(HitBio && HitTimer ==1'b0) begin
					score<=score+1;
					scoreall <=scoreall+1;
		end else
		if(HitCS && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+2;
		end else
		if(HitEE && HitTimer ==1'b0) begin
					score <=score+4;
					scoreall <=scoreall+4;
		end else
		if(HitMath && HitTimer ==1'b0) begin
					score <=score+1;
					scoreall <=scoreall+11'd1;

		end else
		if(HitPhysics && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+11'd2;
			end
		if(bordercollision && HitBottom) begin
			life<=life-1'd1;
			Fall <=1'b1;
end
end

///step 4///
else if(game_ps == s_step4)begin 
		Fall<=1'b0;
		if(score>=11'd40) begin 
					score <= scoreall -11'd120 ;
		end else
		if(HitBio && HitTimer ==1'b0) begin
					score<=score+1;
					scoreall <=scoreall+1;
		end else
		if(HitCS && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+2;
		end else
		if(HitEE && HitTimer ==1'b0) begin
					score <=score+2;
					scoreall <=scoreall+2;
		end else
		if(HitMath && HitTimer ==1'b0) begin
					score <=score+1;
					scoreall <=scoreall+11'd1;
		end else
		if(HitPhysics && HitTimer ==1'b0) begin
					score <=score+1;
					scoreall <=scoreall+11'd1;
			end
		if(bordercollision && HitBottom) begin
			life<=life-1'd1;
			Fall <=1'b1;
end
end

////// collision with down border end ////
else if(!(bordercollision && HitBottom)) begin
			Fall <=1'b0;
end
//// reset user //////
if(ResetUser==1'b1 && game_ps==s_endgame) begin
		score <= 11'd0;
		scoreall <=11'd0;
		Fall <= 1'b1;
		life <=4'd3;
		BallBlock <= 1'b0;
end
//

if ( collision  && (flag == 1'b0)) begin 
			flag	<= 1'b1; 												// to enter only once 
			if( drawing_request_2 || drawing_request_3)begin
				SingleHitPulse <= 1'b1 ; 
			end
		
end 
	end
end // always_ff



always_comb 
	begin
	// set all default values 
		game_ns = game_ps; 
		NextLevel=1'b0;
		step2=1'b0;
		Winning =1'b0;
		Losing= 1'b0;
		raispeed=1'b0;
		RandReset =1'b0;
		case (game_ps)

			s_idle: begin
					if (life ==4'd0) game_ns = s_endgame;
					else if (life >4'd0 && shot == 1'b1) begin
						RandReset =1'b1;
						game_ns = s_shooting; 
					end 
				end			
			s_shooting: begin
					if (shot == 1'b0 && scoreall< 11'd40) begin 
						raispeed = 1'b1;
						game_ns = s_step1; 
					end  else if (shot == 1'b0 && scoreall>= 11'd40 && scoreall<11'd80) begin 
									raispeed = 1'b1;
									game_ns = s_step2; 
								 end  else  if (shot == 1'b0 && scoreall>= 11'd80 && scoreall<11'd120) begin 
													raispeed = 1'b1;
													game_ns = s_step3; 
												end  else if (shot == 1'b0 && scoreall>= 11'd120 && scoreall<11'd160) begin 
																	raispeed = 1'b1;
																	game_ns = s_step4; 
															 end   
				
					end // s_shooting
						
			s_step1: begin 
								NextLevel=1'b0;
								if(scoreall>=11'd40) begin 
									game_ns = s_step2 ;
									NextLevel=1'b1;
									step2=1'b1;
								end 
								if(bordercollision && HitBottom) begin
									game_ns = s_idle ;
								end
				
				end // step 1
					
			s_step2: begin
								NextLevel=1'b0;
								step2=1'b1;
								if(scoreall>=11'd80) begin 
									game_ns = s_step3 ;
									NextLevel=1'b1;
								end 
								if(bordercollision && HitBottom) begin
									game_ns = s_idle ;
								end

				
				end // step 2
				
			s_step3: begin 
								NextLevel=1'b0;
								if(scoreall>=11'd120) begin 
									game_ns = s_step4 ;
									NextLevel=1'b1;
								end 
								if(bordercollision && HitBottom) begin
									game_ns = s_idle ;
								end				

				
				end // step3
				
			s_step4: begin 
								NextLevel=1'b0;
								if(scoreall>=11'd160) begin 
									game_ns = s_endgame ;
									NextLevel=1'b1;
								end 
								if(bordercollision && HitBottom) begin
									game_ns = s_idle ;
								end
				
				end // step 4
						
			s_endgame: begin
							if(scoreall>=160) begin
							Winning =1'b1;
							end else begin Losing =1'b1;
										end
							if(ResetUser==1'b1) begin
								game_ns = s_idle ;
							end
						end // endgame
				
						
						
		endcase
	end // always comb
endmodule
