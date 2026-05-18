//ScoreCalculator Tal&Safit April 2022
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Tal & Safit May 2022

module	ScoreCalculator	(	
					input		logic	clk,
					input		logic	resetN,
					input logic [10:0] scoreall,    //Total score        				
					input logic [10:0] score,       //Score of single year
					
					output logic [3:0] units,
					output logic [3:0] tens,
					output logic [3:0] hundreds,
					output logic [3:0] yearunits,
					output logic [3:0] yeartens
);


logic [10:0] reduce;       //If scoreall is above 100 then reduce=100, else reduce=0


always_comb
begin
		  
		//scoreall
		if(scoreall>=100) begin
			hundreds=4'd1;
			reduce=11'd100;
		end else begin
		reduce=0;
		hundreds=4'd0;
		end
		
		if((scoreall-reduce)<11'd10) begin 
												units = scoreall-reduce;
												tens = 4'd0;
												end
		else if((scoreall-reduce)>=11'd10 && (scoreall-reduce)<11'd20) begin 
					units=scoreall-reduce-11'd10;
					tens=4'd1;
			  end
			  else if((scoreall-reduce)>=11'd20 && (scoreall-reduce)<11'd30) begin 
							units = scoreall-reduce-11'd20;
							tens =4'd2;
					 end
				    else if((scoreall-reduce)>=11'd30 && (scoreall-reduce)<11'd40) begin 
									units=scoreall-reduce-11'd30;
									tens=4'd3;
							end
						   else if((scoreall-reduce)>=11'd40 && (scoreall-reduce)<11'd50) begin 
											units=scoreall-reduce-11'd40;
											tens=4'd4;
								  end
						        else if((scoreall-reduce)>=11'd50 && (scoreall-reduce)<11'd60) begin 
												units=scoreall-reduce-11'd50;
												tens=4'd5;
										  end
										  else if((scoreall-reduce)>=11'd60 && (scoreall-reduce)<11'd70) begin 
														units=scoreall-reduce-11'd60;
														tens=4'd6;
												 end
												 else if((scoreall-reduce)>=11'd70 && (scoreall-reduce)<11'd80) begin 
																units=scoreall-reduce-11'd70;
																tens=4'd7;
														end
														else if((scoreall-reduce)>=11'd80 && (scoreall-reduce)<11'd90) begin 
																		units=scoreall-reduce-11'd80;
																		tens=4'd8;
															  end
															  else if((scoreall-reduce)>=11'd90 && (scoreall-reduce)<11'd100) begin 
																			units=scoreall-reduce-11'd90;
																			tens=4'd9;
																	 end else begin 
																					units=4'd0;
																					tens=4'd0;
																				 end
				
     
		//score by year

		if(score<11'd10) begin 
								yearunits=score;
								yeartens=4'd0;
								end
		else if(score>=11'd10 && score<11'd20) begin
						yeartens=4'd1;
						yearunits=score-11'd10;
				end
				else if(score>=11'd20 && score<11'd30) begin
							yeartens=4'd2;
							yearunits=score-11'd20;
						end
						else if(score>=11'd30 && score<11'd40) begin
										yeartens=4'd3;
										yearunits=score-11'd30;
							  end
							  else if(score>=11'd40 && score<11'd50) begin
											yeartens=4'd4;
											yearunits=score-11'd40;
									 end else begin 
														yeartens=4'd0;
														yearunits=score-11'd0;
												 end
				
  
	
end //always_comb
 

endmodule 