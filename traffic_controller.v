module traffic_controller (
	input clk,
	input reset,
	output reg [2:0] out
	);

	localparam [1:0] red = 2'd0, yellow = 2'd1, green = 2'd2;

	reg [1:0] state, next_state;
	reg [3:0] counter;

	// Combinational logic
	always @(*) begin
		case(state)
			red: next_state = green;
			yellow: next_state = red;
			green: next_state = yellow;
			default: next_state = red;
		endcase
	end

	// 4-bit clock (16s max) | reset and clk
	always @(posedge clk) begin
		if (reset) begin
			state <= red;
			counter <= 0;
		end else if (counter == 4'd15) begin
			state <= next_state;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end	
	end
	
	// Output using one hot encoding
	always @(*) begin
		case (state)
			red: out = 3'b100;
			yellow: out = 3'b010;
			green: out = 3'b001;
			default: out = 3'bxxx;
		endcase
	end

endmodule
