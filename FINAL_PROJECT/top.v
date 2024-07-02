`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:47:49 12/25/2023 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,        // 输入时钟信号
    input rstn,       // 复位信号
    input ps2_clk,    // PS2时钟信号
    input ps2_data,   // PS2数据信号
    output hs,        // 水平同步信号
    output vs,        // 垂直同步信号
    output [3:0] r,    // 红色信号
    output [3:0] g,    // 绿色信号
    output [3:0] b,    // 蓝色信号
    output SEGLED_CLK, // 7段LED时钟信号
    output SEGLED_CLR, // 7段LED清除信号
    output SEGLED_DO,  // 7段LED数据输出信号
    output SEGLED_PEN  // 7段LED使能信号
);

reg dead =0;
reg start=0;

reg [31:0] clkdiv;
reg [11:0] vga_data;
wire [9:0] col_addr;
wire [8:0] row_addr;

wire key_down;
wire [7:0] keyboard;

reg [31:0] score = 32'b0;
wire [3:0] sout;

reg[8:0] random=9'b101011010;

always @(posedge clk) begin    
    clkdiv <= clkdiv + 1'b1;
end// 在每个上升沿时，递增clkdiv


reg [8:0] loopy_x = 10'd80;
reg [9:0] loopy_y = 10'd240;
reg [8:0] door1_x = 10'd200;
reg [9:0] door1_y = 10'd300;
reg [8:0] door2_x = 10'd400;
reg [9:0] door2_y = 10'd200;
reg [8:0] door3_x = 10'd300;
reg [9:0] door3_y = 10'd400;
reg [8:0] door4_x = 10'd520;
reg [9:0] door4_y = 10'd100;
reg [8:0] mine1_x = 10'd150;
reg [9:0] mine1_y = 10'd400;
reg [8:0] mine2_x = 10'd1;
reg [9:0] mine2_y = 10'd1;
reg [8:0] mine3_x = 10'd500;
reg [9:0] mine3_y = 10'd200;
reg [8:0] mine4_x = 10'd230;
reg [9:0] mine4_y = 10'd100;
reg [8:0] mine5_x = 10'd480;
reg [9:0] mine5_y = 10'd300;

reg [31:0] cnt=0;
reg [31:0] cnt_score=0;


reg wasReady =0;
reg [7:0] last_key=0;


//----------------------------------------------------------
//调用模块

vgac v0 (
    .vga_clk(clkdiv[1]), // VGA时钟信号
    .clrn(1'b1),          // VGA清零信号
    .d_in(vga_data),      // VGA数据输入信号
    .row_addr(row_addr),  // VGA行地址信号
    .col_addr(col_addr),  // VGA列地址信号
    .r(r),                // VGA红色信号
    .g(g),                // VGA绿色信号
    .b(b),                // VGA蓝色信号
    .hs(hs),              // VGA水平同步信号
    .vs(vs)               // VGA垂直同步信号
); // 调用 VGA 核心模块


PS2 p0(.clk(clk),.rst(1'b0),.ps2_clk(ps2_clk),.ps2_data(ps2_data),.data_out(keyboard),.ready(key_down));


	


Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),.data(score), .point(8'h0), .LES(8'h0),.sout(sout));
assign SEGLED_CLK = sout[3];
assign SEGLED_DO =  sout[2];
assign SEGLED_PEN = sout[1];
assign SEGLED_CLR = sout[0];
//---------------------------------------------------------------



reg [2:0] speed = 1;
reg flag = 1;//1 up 0 down
always @(posedge clk )begin


	if(cnt<100_000_000)begin
		cnt<=cnt+1;
	end
	else begin
		cnt<=0;
	end

	if(cnt_score<1000_000_000)begin
		cnt_score<=cnt_score+1;
	end
	else begin
		cnt_score<=0;
	end
	
	
	
	// 更新障碍物位置
	if(dead==0 && start==1)begin
		random<={random[7:0],random[7]^random[5]^random[4]^random[3]};

		if (wasReady==0&&key_down==1&&keyboard!=last_key) begin
		
			case (keyboard)
				8'h 3b:begin
					speed<=3'b 10;
				end
				8'h 42:begin 
					speed<=1;
				end
				8'h 4b:begin
					if(flag==0)
						flag<=1;
					else
						flag<=0;
				end
				default: ;
			endcase
			
			last_key <= keyboard;
		end else if(wasReady==0&&key_down==1)
			last_key <= 8'b0;
		wasReady <= key_down;	
		
		
			if (!((loopy_x + 30 < mine1_x) || // 角色在mine左边时
					(loopy_x > mine1_x + 50) || // 角色在mine右边时
					(loopy_y + 30 < mine1_y) || // 角色在mine上方时
					(loopy_y > mine1_y + 50))) begin // 角色在mine下方时
				 // 如果碰到 mine，将score记为1111，把dead置1
				 dead<=1;
			end 
			if (!((loopy_x + 30 < mine2_x) || // 角色在mine左边时
					(loopy_x > mine2_x + 50) || // 角色在mine右边时
					(loopy_y + 30 < mine2_y) || // 角色在mine上方时
					(loopy_y > mine2_y + 50))) begin // 角色在mine下方时
				 // 如果碰到 mine，将score记为1111，把dead置1
				 dead<=1;
			end 
   		if (!((loopy_x + 30 < mine3_x) || // 角色在mine左边时
					(loopy_x > mine3_x + 50) || // 角色在mine右边时
					(loopy_y + 30 < mine3_y) || // 角色在mine上方时
					(loopy_y > mine3_y + 50))) begin // 角色在mine下方时
				 // 如果碰到 mine，将score记为1111，把dead置1
				 dead<=1;
			end	
   		if (!((loopy_x + 30 < mine5_x) || // 角色在mine左边时
					(loopy_x > mine5_x + 50) || // 角色在mine右边时
					(loopy_y + 30 < mine5_y) || // 角色在mine上方时
					(loopy_y > mine5_y + 50))) begin // 角色在mine下方时
				 // 如果碰到 mine，将score记为1111，把dead置1
				 dead<=1;
			end		
   		if (!((loopy_x + 30 < mine4_x) || // 角色在mine左边时
					(loopy_x > mine4_x + 50) || // 角色在mine右边时
					(loopy_y + 30 < mine4_y) || // 角色在mine上方时
					(loopy_y > mine4_y + 50))) begin // 角色在mine下方时
				 // 如果碰到 mine，将score记为1111，把dead置1
				 dead<=1;
			end	
		
		
		
		
		
		
		if(mine1_x==10'd0) begin
			//mine1_x <= 10'd609;
			mine1_y <= random%460;
		end
		if(mine2_x==10'd0) begin
			//mine2_x <= 10'd639;
			mine2_y <= random%460;
		end
		 if(mine3_x==10'd0) begin
			//mine3_x <= 10'd639;
			mine3_y <= random%460;
		end
		 if(mine4_x==10'd0) begin
			//mine4_x <= 10'd639;
			mine4_y <= random%460;
		end
		 if(mine5_x==10'd0) begin
			//mine5_x <= 10'd639;
			mine5_y <= random%460;
		end		
		if(door1_x==10'd0) begin
			//door1_x <= 10'd639;
			door1_y <= random%460;
		end
		if(door2_x==10'd0) begin
			//door2_x <= 10'd639;
			door2_y <= random%460;
		end
		if(door3_x==10'd0) begin
			//door3_x <= 10'd639;
			door3_y <= random%460;
		end
		if(door4_x==10'd0) begin
			//door4_x <= 10'd639;
			door4_y <= random%460;
		end
		
		 //loopy判断触底触顶
		 if(loopy_y==10'd0) begin
			  flag <= 0;
		 end
		 else if(loopy_y==10'd480) begin
			  flag <= 1;
		 end 

		 // 更新门位置
		 if(cnt%2_000_000==0) begin

			  mine1_x <= mine1_x - 2;
			  mine2_x <= mine2_x - 2; 
			  mine3_x <= mine3_x - 2;
			  mine4_x <= mine4_x - 2;
			  mine5_x <= mine5_x - 2;
			  door1_x <= door1_x - 2;
			  door2_x <= door2_x - 2;
			  door3_x <= door3_x - 2;
			  door4_x <= door4_x - 2;
			  
			  if(flag == 1) begin
					loopy_y <= loopy_y - speed;
			  end
			  else if(flag == 0) begin
					loopy_y <= loopy_y + speed;
			  end
			  
				if (!((loopy_x + 30 < door1_x) || // 角色在门左边时
						(loopy_x > door1_x + 99) || // 角色在门右边时
						(loopy_y + 30 < door1_y) || // 角色在门上方时
						(loopy_y > door1_y + 5))) begin // 角色在门下方时
					 // 如果碰到 door，则增加分数
					 score <= score + 32'b1;
				end
				
				if (!((loopy_x + 30 < door2_x) || // 角色在门左边时
						(loopy_x > door2_x + 99) || // 角色在门右边时
						(loopy_y + 30 < door2_y) || // 角色在门上方时
						(loopy_y > door2_y + 5))) begin // 角色在门下方时
					 // 如果碰到 door，则增加分数
					 score <= score + 32'b1;
				end
				
				if (!((loopy_x + 30 < door3_x) || // 角色在门左边时
						(loopy_x > door3_x + 99) || // 角色在门右边时
						(loopy_y + 30 < door3_y) || // 角色在门上方时
						(loopy_y > door3_y + 5))) begin // 角色在门下方时
					 // 如果碰到 door，则增加分数
					 score <= score + 32'b1;
				end
				
				if (!((loopy_x + 30 < door4_x) || // 角色在门左边时
						(loopy_x > door4_x + 99) || // 角色在门右边时
						(loopy_y + 30 < door4_y) || // 角色在门上方时
						(loopy_y > door4_y + 5))) begin // 角色在门下方时
					 // 如果碰到 door，则增加分数
					 score <= score + 32'b1;
				end
		 end
		 
		 if(cnt_score%200_000_000==0)begin
			score<=score+1;
		 end		
	end
   else if(dead==1) begin
		if (key_down) begin
			dead<=0;
			loopy_x <= 10'd80;
			loopy_y <= 10'd240;
			door1_x <= 10'd200;
			door1_y <= 10'd300;
			door2_x <= 10'd400;
			door2_y <= 10'd200;
			door3_x <= 10'd300;
			door3_y <= 10'd400;
			door4_x <= 10'd520;
			door4_y <= 10'd100;			
			mine1_x <= 10'd150;
			mine1_y <= 10'd400;
			mine2_x <= 10'd1;
			mine2_y <= 10'd1;
			mine3_x <= 10'd500;
			mine3_y <= 10'd200;
			mine4_x <= 10'd230;
			mine4_y <= 10'd100;
			mine5_x <= 10'd480;
			mine5_y <= 10'd300;			
			score <= 32'b0;			
			cnt<=32'b0;			
			cnt_score<=32'b0;
			speed<=1;
			last_key<=0;
			score<=0;
			start<=0;
		end 
	end
	else begin
	   if(key_down==1)begin
			start<=1;
		end
	end
end



//----------------------------------------------
//用于显示的临时变量声明
	reg [18:0] background_addr;
	wire [11:0] background_rgb;

	reg [18:0] end_background_addr;
	wire [11:0] end_background_rgb;
	
	reg [18:0] begin_background_addr;
	wire [11:0] begin_background_rgb;
	
	reg [9:0] loopy_addr;
	wire [11:0] loopy_rgb;
	
	reg [8:0] door1_addr;
	wire [11:0] door1_rgb;
	
	reg [8:0] door2_addr;
	wire [11:0] door2_rgb;
	
	reg [8:0] door3_addr;
	wire [11:0] door3_rgb;
	
	reg [8:0] door4_addr;
	wire [11:0] door4_rgb;
	
	reg [11:0] mine1_addr;
	wire [11:0] mine1_rgb;
	
	reg [11:0] mine2_addr;
	wire [11:0] mine2_rgb;
	
	reg [11:0] mine3_addr;
	wire [11:0] mine3_rgb;
	
	reg [11:0] mine4_addr;
	wire [11:0] mine4_rgb;
	
	reg [11:0] mine5_addr;
	wire [11:0] mine5_rgb;

//---------------------------------------------


//---------------------------------------
//图片地址计算
	always@(posedge clk) begin
	background_addr<=(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)? (480-row_addr)*640+col_addr:0;
	begin_background_addr<=(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)? (480-row_addr)*640+col_addr:0;
	end_background_addr<=(col_addr>=0&&col_addr<=639&&row_addr>=0&&row_addr<=479)? (480-row_addr)*640+col_addr:0;
   loopy_addr<=(col_addr>=loopy_x && col_addr<=loopy_x+29 && row_addr>=loopy_y && row_addr<=loopy_y+29)?(29-(row_addr-loopy_y))*30+(col_addr-loopy_x):0;
	door1_addr<=(col_addr>=door1_x && col_addr<=door1_x+98 && row_addr>=door1_y && row_addr<=door1_y+4)?(4-(row_addr-door1_y))*99+(col_addr-door1_x):0;
	door2_addr<=(col_addr>=door2_x && col_addr<=door2_x+98 && row_addr>=door2_y && row_addr<=door2_y+4)?(4-(row_addr-door2_y))*99+(col_addr-door2_x):0;
	door3_addr<=(col_addr>=door3_x && col_addr<=door3_x+98 && row_addr>=door3_y && row_addr<=door3_y+4)?(4-(row_addr-door3_y))*99+(col_addr-door3_x):0;
	door4_addr<=(col_addr>=door4_x && col_addr<=door4_x+98 && row_addr>=door4_y && row_addr<=door4_y+4)?(4-(row_addr-door4_y))*99+(col_addr-door4_x):0;
	mine1_addr<=(col_addr>=mine1_x && col_addr<=mine1_x+49 && row_addr>=mine1_y && row_addr<=mine1_y+49)?(49-(row_addr-mine1_y))*50+(col_addr-mine1_x):0;
	mine2_addr<=(col_addr>=mine2_x && col_addr<=mine2_x+49 && row_addr>=mine2_y && row_addr<=mine2_y+49)?(49-(row_addr-mine2_y))*50+(col_addr-mine2_x):0;
	mine3_addr<=(col_addr>=mine3_x && col_addr<=mine3_x+49 && row_addr>=mine3_y && row_addr<=mine3_y+49)?(49-(row_addr-mine3_y))*50+(col_addr-mine3_x):0;
   mine4_addr<=(col_addr>=mine4_x && col_addr<=mine4_x+49 && row_addr>=mine4_y && row_addr<=mine4_y+49)?(49-(row_addr-mine4_y))*50+(col_addr-mine4_x):0;
	mine5_addr<=(col_addr>=mine5_x && col_addr<=mine5_x+49 && row_addr>=mine5_y && row_addr<=mine5_y+49)?(49-(row_addr-mine5_y))*50+(col_addr-mine5_x):0;
	end
//------------------------------------------------


//------------------------------------------
//图片rgb返回
	background a1(.clka(clkdiv[1]),.addra(background_addr),.douta(background_rgb));
	begin_background a13(.clka(clkdiv[1]),.addra(begin_background_addr),.douta(begin_background_rgb));
	end_background a2(.clka(clkdiv[1]),.addra(end_background_addr),.douta(end_background_rgb));
	loopy a3(.clka(clkdiv[1]),.addra(loopy_addr),.douta(loopy_rgb));
	door a4(.clka(clkdiv[1]),.addra(door1_addr),.douta(door1_rgb));
	door a5(.clka(clkdiv[1]),.addra(door2_addr),.douta(door2_rgb));
	mine a6(.clka(clkdiv[1]),.addra(mine1_addr),.douta(mine1_rgb));
	mine a7(.clka(clkdiv[1]),.addra(mine2_addr),.douta(mine2_rgb));
	mine a8(.clka(clkdiv[1]),.addra(mine3_addr),.douta(mine3_rgb));
	mine a9(.clka(clkdiv[1]),.addra(mine4_addr),.douta(mine4_rgb));
	mine a10(.clka(clkdiv[1]),.addra(mine5_addr),.douta(mine5_rgb));
	door a11(.clka(clkdiv[1]),.addra(door3_addr),.douta(door3_rgb));
	door a12(.clka(clkdiv[1]),.addra(door4_addr),.douta(door4_rgb));
//-------------------------------------------


//-------------------------------------------
//最终显色
always @(*) begin
	 if(dead==0&&start==1)begin
		 if(col_addr >= 0 && col_addr <= 639 && row_addr >= 0 && row_addr <= 479)
			  vga_data <= background_rgb; //背景图片颜色
			  
		 if(col_addr>=door1_x && col_addr<=door1_x+98 && row_addr>=door1_y && row_addr<=door1_y+4)
			  vga_data<= door1_rgb;//穿越门
			  
		 if(col_addr>=door2_x && col_addr<=door2_x+98 && row_addr>=door2_y && row_addr<=door2_y+4)
			  vga_data<= door2_rgb;//穿越门
			  
		 if(col_addr>=door3_x && col_addr<=door3_x+98 && row_addr>=door3_y && row_addr<=door3_y+4)
			  vga_data<= door3_rgb;//穿越门
			  
		 if(col_addr>=door4_x && col_addr<=door4_x+98 && row_addr>=door4_y && row_addr<=door4_y+4)
			  vga_data<= door4_rgb;//穿越门			  
			  
		 if(col_addr>=mine1_x && col_addr<=mine1_x+49 && row_addr>=mine1_y && row_addr<=mine1_y+49)	  
			  vga_data<= mine1_rgb;//地雷

		 if(col_addr>=mine2_x && col_addr<=mine2_x+49 && row_addr>=mine2_y && row_addr<=mine2_y+49)	  
			  vga_data<= mine2_rgb;//地雷
			  
		 if(col_addr>=mine3_x && col_addr<=mine3_x+49 && row_addr>=mine3_y && row_addr<=mine3_y+49)	  
			  vga_data<= mine3_rgb;//地雷

		 if(col_addr>=mine4_x && col_addr<=mine4_x+49 && row_addr>=mine4_y && row_addr<=mine4_y+49)	  
			  vga_data<= mine4_rgb;//地雷
			  
		 if(col_addr>=mine5_x && col_addr<=mine5_x+49 && row_addr>=mine5_y && row_addr<=mine5_y+49)	  
			  vga_data<= mine5_rgb;//地雷
			  
		 if(col_addr>=loopy_x && col_addr<=loopy_x+29 && row_addr>=loopy_y && row_addr<=loopy_y+29&&loopy_rgb!=12'h fff)
			  vga_data<= loopy_rgb;//人物
	 end
	 else if (dead==1)begin
		if(col_addr >= 0 && col_addr <= 639 && row_addr >= 0 && row_addr <= 479)
			  vga_data <= end_background_rgb; //背景图片颜色
	 end
	 else begin
		 if(col_addr >= 0 && col_addr <= 639 && row_addr >= 0 && row_addr <= 479)
			  vga_data <= begin_background_rgb; //背景图片颜色		
	 end
end

//---------------------------------------------



endmodule