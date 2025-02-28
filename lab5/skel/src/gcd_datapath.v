//=========================================================================
// RTL Model of GCD Unit Datpath
//-------------------------------------------------------------------------
//

module gcd_datapath #( parameter W = 16 )
( 

	//data inputs/outputs
	input [W-1:0] operands_bits_A,
	input [W-1:0] operands_bits_B,
	output [W-1:0] result_bits_data,

	//global inputs
	input clk, reset,

	//control signal inputs and outputs
	input B_mux_sel, A_en, B_en,
	input [1:0] A_mux_sel,
	output B_zero,
	output A_lt_B
);


wire [W-1:0] A_reg;
wire [W-1:0] B_reg;
wire [W-1:0] A_next;
wire [W-1:0] B_next;
wire [W-1:0] sub_out;

// Combinational
// ------------
assign A_next
	= A_mux_sel == 0 ? operands_bits_A
	: A_mux_sel == 1 ? B_reg
	: A_mux_sel == 2 ? sub_out
	: {W{1'bx}};

assign B_next
	= B_mux_sel == 0 ? operands_bits_B
	: B_mux_sel == 1 ? A_reg
	: {W{1'bx}};

// Subtract
assign sub_out = A_reg - B_reg;

// Zero?
assign B_zero = (B_reg == 0) ? 1'b1 : 1'b0;

// LT
assign A_lt_B = (A_reg < B_reg) ? 1'b1 : 1'b0;

// Assign output
assign result_bits_data = A_reg;



// Sequential
// ---------
// always @ (posedge clk or posedge reset) begin

// 	if(reset) begin
// 		A_reg <= 0;
// 		B_reg <= 0;
// 	end else begin
// 		if (A_en) A_reg <= A_next;
// 		if (B_en) B_reg <= B_next;
// 	end

// end

REGISTER_R_CE #(.N(W)) A_register (.q(A_reg), .d(A_next), .rst(reset), .ce(A_en), .clk(clk));
REGISTER_R_CE #(.N(W)) B_register (.q(B_reg), .d(B_next), .rst(reset), .ce(B_en), .clk(clk));

endmodule

