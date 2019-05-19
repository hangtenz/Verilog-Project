`define color_red 12'b111000000000
`define color_blue 12'b000000110000
`define color_white 12'b111111111111
`define color_black 12'b000000000000
`define color_pink 12'b111110100000

`define state_reset 2'b00
`define state_player_select 2'b01
`define state_game 2'b10
`define state_pause 2'b11
// keys
`define key_player1_right 8'h23
`define key_player1_left 8'h1C

`define key_player2_right 8'h4B
`define key_player2_left 8'h3B

`define key_esc 8'h76
`define key_space 8'h29
`define key_1 8'h16
`define key_2 8'h1E

`define paddle_width 64
`define paddle_height 8

`define ball_width 8
`define ball_height 8

`define screen_width 640
`define screen_height 480

`define border_size 6
`define feature_size 11

`define ai_speed_default 4
module main(
	 input clock,
	 input ps2_data, 
	 input ps2_clock,
	 input reset,
    output hsync,
    output vsync,
	 output reg [11:0]color,
	 output [3:0] digit_selection,
	 output [7:0] segment_selection
);
// declaration defines
wire p_tick;
wire done;
reg old_done;
wire [7:0]tasta;
//reg clock;
reg border;
wire Inside;
wire [9:0] x_out, y_out;
reg game; // 1 daca e game si 0 pause

reg [3:0] score1, score2; // scorurile
wire enable_score;
wire [7:0] out_score;

reg [9:0] ball_x, ball_y;  		// position
reg [3:0] ball_vx, ball_vy;		// speed
reg ball_dx, ball_dy;				// direction: 1 pos, 0 neg

reg [9:0] paddle1_x, paddle1_y;	// position
reg [7:0] paddle1_vx, paddle1_vy;// speed

reg [9:0] paddle2_x, paddle2_y;	 // position
reg [7:0] paddle2_vx, paddle2_vy; //speed

reg [5:0] counter;
reg [5:0] speed;

reg [5:0] ai_counter;
reg [5:0] ai_speed;

reg player_number; // 0 = 1 player ; 1 = 2 players
reg [1:0] states; // states

// 0: reset
// 1: player_select (keyboard 1 or 2), highlight player's bar
// 2: game (space keyboard to begin)
// 3: pause (space keyboard to rebegin game / esc to reset)
reg [7:0] key;

keyboard keyb(.clock(clock),.ps2_clock(ps2_clock), .ps2_data(ps2_data),.done(done), .tasta(tasta));
vga_sync lcd(.clk(clock),.reset(reset),.hsync(hsync),.vsync(vsync),.Inside(Inside),.p_tick(p_tick),.x(x_out),.y(y_out));
//dashboard dashboard(.clock(clock),.score1(score1),.score2(score2),.digit_selection(digit_selection),.segment_selection(segment_selection));
Scor Scor(.clock(clock),.scor1(key[3:0]),.scor2(key[7:4]),.dec(digit_selection),.out(segment_selection),.enable(1));

reg state_hang = 0;
vh_sync(clock,reset,hsync,vsync,red,green,blue);

initial begin
	states <= `state_reset;
	speed <= 5;
	score1 <= 0;
	score2 <= 0;
	ai_speed <= `ai_speed_default;
end
// drawing
always @(posedge clock)
begin
	if(Inside) begin
		
		// scancode keyboard
		if(old_done != done) begin
			if(done) begin
				key <= tasta;
				
			end else
	
				
			old_done <= done;
		end
		
		// Game logic
		if(x_out == 1 && y_out == 1) begin

			// switch states
			case (states)
				`state_reset:
					begin
						ball_x <= `screen_width >> 1; // ball in the center of screen 
						ball_y <= `screen_height >> 1;
						
						paddle2_x <= `screen_width >> 1;
						paddle2_y <= `border_size << 2;
						
						paddle1_x <= `screen_width >> 1;
						paddle1_y <= `screen_height - (`border_size << 2);
						
						states <= `state_player_select;
						
						score1 <= 0;
						score2 <= 0;
					end
				`state_player_select: //Nameee
					begin
					   
						if (key == `key_space) begin
							key <= 0;
							states <= `state_game;
							
							// set ball speed
							ball_vx <= 3;
							ball_vy <= 2;
							ball_dx <= 1;
							ball_dy <= 1;
							speed <= 5;
						end
					end
				`state_game:
					begin
					
						if (key == `key_space) begin
							states <= `state_pause;
							key <= 0;
						end else if (key == `key_player1_left) begin 
							if (paddle1_x >= `feature_size + `ball_width + (`paddle_width >> 1))
								paddle1_x <= paddle1_x - `ball_width;
							key <= 0;										
						end else if (key == `key_player1_right) begin
							if (paddle1_x <= `screen_width - `feature_size - `ball_width - (`paddle_width >> 1))
								paddle1_x <= paddle1_x + `ball_width;
							key <= 0;
						end else if (key == `key_player2_left) begin 
								if (paddle2_x >= `feature_size + `ball_width + (`paddle_width >> 1))
									paddle2_x <= paddle2_x - `ball_width;
							key <= 0;										
						end else if (key == `key_player2_right) begin
								if (paddle2_x <= `screen_width - `feature_size - `ball_width - (`paddle_width >> 1))
									paddle2_x <= paddle2_x + `ball_width;
							key <= 0;
						end
							// TO BE CONTINUED
							
						if(counter == speed) begin
							counter <= 0;
							
							if(ball_dx) // to right
								if (ball_x <= `screen_width - `feature_size - `ball_width - (`ball_width >> 1))
									ball_x <= ball_x + `ball_width;
								else
									ball_dx <= 0;
							else       // to left
								if (ball_x >= `feature_size + `ball_width + (`ball_width >> 1))
									ball_x <= ball_x - `ball_width;
								else
									ball_dx <= 1;
									
						  if(ball_dy) // to down
								if ((ball_x >= paddle1_x - (`paddle_width >> 1)) && (ball_x <= paddle1_x + (`paddle_width >> 1)) && (ball_y == paddle1_y - `ball_width)) begin
									ball_dy <= 0;	
									if(speed > 1)
										speed <= speed - 1;
										
								end else if (ball_y <= `screen_height - `feature_size - `ball_width - (`ball_width >> 1))
									ball_y <= ball_y + `ball_width;
								else begin
									ball_dy <= 0;
									speed <= 5;
									score2 <= score2 + 1;
									if (score2 == 9) 
										states <= `state_reset;

								end
							else       // to up
								if ((ball_x >= paddle2_x - (`paddle_width >> 1)) && (ball_x <= paddle2_x + (`paddle_width >> 1)) && (ball_y == paddle2_y + `ball_width)) begin
									ball_dy <= 1;
									if(speed > 1)
										speed <= speed - 1;
										
								end else if (ball_y >= `feature_size + `ball_width + (`ball_width >> 1))
									ball_y <= ball_y - `ball_width;
								else begin
									ball_dy <= 1;
									speed <= 5;
									score1 <= score1 + 1;
									if (score1 == 9) 
										states <= `state_reset;
								end
								
							
						end else
							counter <= counter + 1;
												
					end
				`state_pause:
					begin
					
						if (key == `key_space) begin
							states <= `state_game;
							key <= 0;
						end else if (key == `key_esc) begin
							states <= `state_reset;
							key <= 0;
						end
					end
			endcase

		end
		
		//border
		if (x_out <= `border_size || x_out >= `screen_width - `border_size || (y_out > 1 && y_out <= `border_size) || y_out >= `screen_height - `border_size) 
			color <= `color_black;
		else if (x_out <= `feature_size || x_out >= `screen_width - `feature_size || (y_out > 1 && y_out <= `feature_size) || y_out >= `screen_height - `feature_size) 
			color <= `color_pink;
		
		//paddle1 bottom	
		else if (x_out >= paddle1_x  - (`paddle_width >> 1) && x_out <= paddle1_x + (`paddle_width >> 1) && y_out >= paddle1_y - (`paddle_height >> 1) && y_out <= paddle1_y  + (`paddle_height >> 1))
			color <= `color_red;
			
		//paddle2 top
		else if (x_out >= paddle2_x  - (`paddle_width >> 1) && x_out <= paddle2_x + (`paddle_width >> 1) && y_out >= paddle2_y - (`paddle_height >> 1) && y_out <= paddle2_y  + (`paddle_height >> 1))
			if(states == `state_player_select)
				if(player_number)
					color <= `color_red;
				else
					color <= `color_black;
			else
				color <= `color_red;
		
		//ball
		else if (x_out >= ball_x  - (`ball_width >> 1) && x_out <= ball_x + (`ball_width >> 1) && y_out >= ball_y - (`ball_height >> 1) && y_out <= ball_y  + (`ball_height >> 1))
			color <= `color_white;
		// background
		else
			color <= `color_black;		
	end
end



endmodule