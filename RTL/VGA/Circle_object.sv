
// Created by Tal Oved & Safit levy may 2022
// (c) Technion IIT, Department of Electrical Engineering 2022 


module	Circle_object	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic	Renable ,
				   input    logic startOfFrame,	
				   input    logic step2,	
					
					output 	logic	[10:0] x0,// point valuse on the circle
					output 	logic	[10:0] y0
					
					
);
// base point
parameter  int xc = 200;
parameter  int yc = 200;
parameter  int R1 = 40;
parameter  int R2 = 30;

int x0tmp ; 
int y0tmp ;
int R ;

int alpha ;

//////// sin() and cos() definition --------------------------------------------------------=

int sin[71] = 
'{0,
17,
35,
53,
71,
89,
106,
124,
142,
160,
177,
195,
212,
230,
247,
264,
282,
299,
316,
333,
350,
366,
383,
399,
416,
432,
448,
464,
480,
496,
511,
527,
542,
557,
572,
587,
601,
615,
630,
644,
657,
671,
684,
698,
711,
723,
736,
748,
760,
772,
784,
795,
806,
817,
828,
838,
848,
858,
868,
877,
886,
895,
903,
912,
920,
927,
935,
942,
949,
955,
962};

int cos[71] = 
'{1024,
1023,
1023,
1022,
1021,
1020,
1018,
1016,
1014,
1011,
1008,
1005,
1001,
997,
993,
989,
984,
979,
973,
968,
962,
956,
949,
942,
935,
928,
920,
912,
904,
895,
886,
877,
868,
858,
849,
838,
828,
818,
807,
796,
784,
773,
761,
749,
736,
724,
711,
698,
685,
672,
658,
644,
630,
616,
602,
587,
573,
558,
543,
527,
512,
496,
481,
465,
449,
433,
417,
400,
384,
367,
350};

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		alpha <= 35 ;

	end
	else begin if (startOfFrame == 1'b1) begin 
			if (Renable==1'b1 && alpha>0) begin
				alpha <= alpha-1;
				end 
				else if (Renable==1'b0 && alpha <=35) begin
						alpha <= alpha+1;
						end
					
		  	  
			end
			
			end
		end
assign R = (step2) ? R2:R1;
assign x0tmp = (R*cos[alpha]) ;
assign y0tmp = (R*sin[alpha]);

assign x0 = xc -(x0tmp/(11'd1024));
assign y0 = yc + (y0tmp/(11'd1024));

endmodule 