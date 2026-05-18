// (c) Technion IIT, Department of Electrical Engineering 2021 
module randomFaculties 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input logic  startOfFrame,
	output logic unsigned [SIZE_BITS-1:0] dout,
	output logic unsigned [10:0] CStopLeftX,
	output logic unsigned [10:0] CStopLeftY,
	output logic unsigned [10:0] MathtopLeftX,
	output logic unsigned [10:0] MathtopLeftY,
	output logic unsigned [10:0] PhytopLeftX,
	output logic unsigned [10:0] PhytopLeftY	
  ) ;

  
  
parameter SIZE_BITS = 8;
parameter unsigned  MIN_VAL = 0;  //set the min and max values 
parameter unsigned MAX_VAL = 30;

	logic unsigned  [SIZE_BITS-1:0] counter/* synthesis keep = 1 */;
	logic [10:0] count;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			dout <= (MAX_VAL-MIN_VAL)/2;
			counter <= MIN_VAL;
		end
		
		else begin
			if(startOfFrame && count <11'd420) count <=count+1;                    //Every 7 sec we choose a random number and 
			counter <= counter+1;                                                  //each range: 0-10, 11-20,21-30 that the number
			if ( counter >= MAX_VAL ) // the +1 is done on the next clock          //belongs to presents different arrangement to  
				counter <=  MIN_VAL ; // set min and max mvalues                    //Math, Physics and CS faculties on the screen.
			
			if (count == 11'd420)begin // rising edge 
				dout <= counter;
				count<=11'd0;
				end
			
			if(dout<=8'd10) begin
					CStopLeftX<=11'd160;
					CStopLeftY<=11'd128;
					MathtopLeftX<=11'd320;
					MathtopLeftY<=11'd128;
					PhytopLeftX<=11'd448;
					PhytopLeftY<=11'd256;
			end else if(dout<=8'd20) begin 
							CStopLeftX<=11'd320;
							CStopLeftY<=11'd128;
							MathtopLeftX<=11'd448;
							MathtopLeftY<=11'd256;
							PhytopLeftX<=11'd160;
							PhytopLeftY<=11'd128;
						end else begin
								 CStopLeftX<=11'd448;
								 CStopLeftY<=11'd256;
								 MathtopLeftX<=11'd160;
								 MathtopLeftY<=11'd128;
								 PhytopLeftX<=11'd320;
								 PhytopLeftY<=11'd128;
						       end
					
		end
	
	end
 
endmodule

