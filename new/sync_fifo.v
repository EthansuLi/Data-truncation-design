module sync_fifo#(parameter BUF_SIZE=8, BUF_WIDTH=8,DP_WD = 3,USE_BRAM= 1 ) (
    //FIFO的数据位宽默认为8bit
    //FIFO深度默认为8
    input                     i_clk,//输入时钟
    input                      i_rst,//复位信号
    input                      i_w_en,//写使能信号
    input                      i_r_en,//读使能信号
   input      [BUF_WIDTH-1:0] i_data,//写入数据

   output reg [BUF_WIDTH-1:0] o_data,//读出数据
    output reg                    o_buf_empty,//FIFO空标志
   output  reg                   o_buf_full,
	output reg [DP_WD:0] fifo_cnt);//FIFO满标志

  // reg [DP_WD:0] fifo_cnt;  //记录FIFO数据个数
    reg [DP_WD:0] r_ptr,w_ptr;  //数据指针为3位宽度，0-7索引，8个数据深度，循环指针0-7-0-7
	
  // (* ram_style="block" *)reg [BUF_WIDTH-1:0] buf_mem[0:BUF_SIZE-1]; //定义FIFO大小

 generate
      if (USE_BRAM) begin : use_bram
        (* ram_style = "block" *)reg [BUF_WIDTH-1:0] buf_mem [0:BUF_SIZE-1];
	    always@(posedge i_clk or posedge i_rst) //读数据
        begin
            if(i_rst)
                o_data<=8'd0;
            else if(!o_buf_empty&&i_r_en)
                o_data<=buf_mem[r_ptr];
        end

        always@(posedge i_clk)  //写数据
        begin
			if(!o_buf_full&&i_w_en)
                buf_mem[w_ptr]<=i_data;
        end
      end else begin : use_lutram
        (* ram_style = "distributed" *)reg [BUF_WIDTH-1:0] buf_mem [0:BUF_SIZE-1];
		always@(posedge i_clk or posedge i_rst) //读数据
        begin
            if(i_rst)
                o_data<=8'd0;
            else if(!o_buf_empty&&i_r_en)
                o_data<=buf_mem[r_ptr];
        end

        always@(posedge i_clk)  //写数据
        begin
			if(!o_buf_full&&i_w_en)
                buf_mem[w_ptr]<=i_data;
        end
      end
   endgenerate
//判断空满
    // assign o_buf_empty=(fifo_cnt==4'd0)?1'b1:1'b0;
   always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			o_buf_full <= 1'b0;
		else if(fifo_cnt == BUF_SIZE+1 && i_w_en)
			o_buf_full <= 1'b1;
		else
			o_buf_full <= 1'b0;
   end
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			o_buf_empty <= 1'b1;
		else if(fifo_cnt == 0)
			o_buf_empty <= 1'b1;
		else
			o_buf_empty <= 1'b0;
	end

    always@(posedge i_clk or posedge i_rst) //用于修改计数器
        begin
            if(i_rst)
                fifo_cnt<='d0;
            else if((!o_buf_full&&i_w_en)&&(!o_buf_empty&&i_r_en)) //同时读写，计数器不变
                fifo_cnt<=fifo_cnt;
            else if(!o_buf_full&&i_w_en) //写数据，计数器加1
                fifo_cnt<=fifo_cnt+1;
            else if(!o_buf_empty&&i_r_en) //读数据，计数器减1
                fifo_cnt<=fifo_cnt-1;
            else
                fifo_cnt <= fifo_cnt; //其他情况，计数器不变
        end

  

    always@(posedge i_clk or posedge i_rst) //读写地址指针变化
        begin
            if(i_rst) begin
                w_ptr <= 0;
                r_ptr <= 0;
            end
            else begin
			    if(w_ptr == BUF_SIZE-1)
					w_ptr <= 'd0;
                else if(!o_buf_full&&i_w_en) // 写数据，地址加1，溢出后自动回到0开始
                        w_ptr <= w_ptr + 1;
				if(r_ptr == BUF_SIZE-1)
					r_ptr <= 'd0;
                else if(!o_buf_empty&&i_r_en) // 读数据，地址加1，溢出后自动回到0开始
                        r_ptr <= r_ptr + 1;
            end
        end
endmodule