
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	Audio_Controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic HitBio,
			input	logic HitEE,
			input	logic FlipperHit,
			input	logic raiSpeed,
			input	logic Fall,
			
			output logic enable,
			output logic [3:0] freq

			
);

logic [23:0] short;   //short clock
logic [23:0] long ;   //long clock
logic flag ;


// state machine decleration 
 enum logic [3:0] {s_idle, s_bio, s_ee1, s_ee2, s_ee3, s_flipper,s_fall,s_shot1,s_shot2} audio_ps, audio_ns;

always_ff@(posedge clk or negedge resetN )
begin
	if(!resetN)
	begin
        audio_ps <= s_idle;
		  short <= 23'd1300000;
		  long <= 23'd1800000;
		  flag<=1'b0;
		  
	end 
	else begin 
	
         audio_ps <= audio_ns; // default	
		  if(audio_ps == s_idle ) flag<=1'b0;
	
	
		if(audio_ps == s_bio ) begin
			freq <= 4'h8;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
	end

	if(audio_ps == s_ee1 ) begin
			freq <= 4'h1;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
	end 
	if(audio_ps == s_ee2 ) begin
			freq <=  4'h2;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
		end  
	if(audio_ps == s_ee3 ) begin
			freq <=  4'h5;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
	end	
	if(audio_ps == s_fall ) begin
			freq <=  4'h9;
		   if(long > 23'd0 ) begin 
				long <= long -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					long <= 23'd1800000;
		  end		
	end	  
		if(audio_ps == s_flipper ) begin
			freq <=  4'h8;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
	end	  
		if(audio_ps == s_shot1 ) begin
			freq <=  4'h7;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
	end	  
		 if(audio_ps == s_shot2 ) begin
			freq <=  4'h7;
		   if(short > 23'd0 ) begin 
				short <= short -23'd1;
				flag <=1'b0;
		   end
		   else begin
					flag <=1'b1;
					short <= 23'd1300000;
		  end
	end	  
		  
		  
end					
end // always_ff

 

always_comb 
	begin
		audio_ns = audio_ps;
      enable=1'b0;		
		

		case (audio_ps)
		
			s_idle: begin
				
				if(HitBio==1'b1) audio_ns=s_bio;
				else if(HitEE==1'b1) audio_ns=s_ee1;
				else if(Fall==1'b1) audio_ns=s_fall;
				else if(raiSpeed==1'b1) audio_ns=s_shot1;
				else if(FlipperHit==1'b1) audio_ns=s_flipper;
			
				end			
			s_ee1: begin
						if (flag ==1'b1) audio_ns = s_ee2;
						enable=1'b1;	
					end 
						
			s_ee2: begin 
							
						if (flag ==1'b1) audio_ns = s_ee3;
						enable=1'b1;
				end 
					
			s_ee3: begin
						if (flag ==1'b1) audio_ns = s_idle;
						enable=1'b1;
				
				end 
				
			s_flipper: begin 
						if (flag ==1'b1) audio_ns = s_idle;
						enable=1'b1;
				
				end 
				
			s_fall: begin 
						if (flag ==1'b1) audio_ns = s_idle;
						enable=1'b1;
				end 
						
			s_bio: begin
						if (flag ==1'b1) audio_ns = s_idle;
						enable=1'b1;
						end 
			s_shot1: begin 
						if (flag ==1'b1) audio_ns = s_shot2;
						enable=1'b1;
						end
						
			s_shot2: begin
						if (flag ==1'b1) audio_ns = s_idle;
						enable=1'b1;
						end 	
						
						
		endcase
	end // always comb
endmodule
