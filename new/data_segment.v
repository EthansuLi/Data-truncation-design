module data_segment#(
	parameter MAX_CNT = 100,
	parameter SKIP_MAX=50,
	parameter USE_BRAM = 1
) (
    input  wire                     clk,            // 主时钟
    input  wire                     rst_n,          // 异步复位
    
    // 输入AXI Stream接口 (64位)
    input  wire [75:0]              s_axis_tdata,   // {real[31:0], imag[31:0]}
    input  wire                     s_axis_tvalid,  // 数据有效
    input  wire                     s_axis_tlast,   // 输入流结束标志
    output wire                     s_axis_tready,  // 准备好接收
    
    // 输出AXI Stream接口 (64位)
    output wire [75:0]              m_axis_tdata,   // {real[31:0], imag[31:0]}
    output wire                     m_axis_tvalid,  // 数据有效
    output wire                     m_axis_tlast,   // 周期结束标志
    input  wire                     m_axis_tready,   // 下游准备好
	
	output wire	[75:0]				m_first_axis_tdata,
	output wire						m_first_axis_tvalid,
	output wire						m_first_axis_tlast,
	input  wire						m_first_axis_tready
	
);

localparam IDLE = 0;
localparam READ = 1;
localparam WAIT = 2;
localparam DP_WD = clog2(MAX_CNT);
reg [1:0] state;
reg [12:0] skip_cnt; //跳过5000个数据
reg skip_init_done;
reg skip_init_done_pre;
wire skip_init_done_rise;
reg [31:0] data_cnt;
reg [15:0] window_cnt;
wire window_last;
reg [31:0] remain_cnt_reg;
wire [DP_WD : 0] fifo_cnt;
wire rd_flag;
reg rd_flag_d0;
wire [76:0] fifo_dout;
reg [76:0] fifo_dout_d0;
wire i_axi_vld;
wire fifo_wen;
reg o_data_vld;
reg o_devide_rdy;
assign i_axi_vld = s_axis_tvalid && s_axis_tready;
assign window_last = data_cnt == MAX_CNT-1 && i_axi_vld && skip_init_done;
reg s_axis_tvalid_d0;
wire fifo_rst;
// wire [15:0] fifo_window_cnt;
reg first_window_cnt;
always@(posedge clk) begin
	s_axis_tvalid_d0 <= s_axis_tvalid;
end
assign fifo_rst = s_axis_tvalid && ~s_axis_tvalid_d0;

//============================ skip ============================//
always @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		skip_cnt <= 'd0;
	else if(i_axi_vld && skip_cnt == SKIP_MAX-1)
		skip_cnt <= 'd0;
	else if(i_axi_vld)
		skip_cnt <= skip_cnt + 1'b1;
	else
		skip_cnt <= skip_cnt;
end
always @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		skip_init_done <= 1'b0;
	else if(i_axi_vld && s_axis_tlast)
		skip_init_done <= 1'b0;
	else if(skip_cnt == SKIP_MAX-1)
		skip_init_done <= 1'b1;
end
always @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		skip_init_done_pre <= 1'b0;
	else if(i_axi_vld && s_axis_tlast)
		skip_init_done_pre <= 1'b0;
	else if(skip_cnt == SKIP_MAX-2)
		skip_init_done_pre <= 1'b1;
end
assign skip_init_done_rise = skip_init_done_pre && ~skip_init_done;
//======================= devide windows =======================//
always @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		data_cnt <= 'd0;
	else if(s_axis_tlast) // 下一包数据回0
		data_cnt <= 'd0;
	else if(i_axi_vld && data_cnt == MAX_CNT-1 && skip_init_done)
		data_cnt <= 'd0;
	else if(i_axi_vld &&  skip_init_done)
		data_cnt <= data_cnt + 1'b1;
	else
		data_cnt <= data_cnt;
end
always @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		window_cnt <= 'd0;
	else if(i_axi_vld && s_axis_tlast && skip_init_done)
		window_cnt <= 'd0;
	else if(i_axi_vld && data_cnt == MAX_CNT-1 && skip_init_done)
		window_cnt <= window_cnt + 1'b1;
	else
		window_cnt <= window_cnt;
end
always @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		remain_cnt_reg <= 'd0;
	else if(skip_init_done_rise)
		remain_cnt_reg <= 'd0;
	else if(s_axis_tlast && ~window_last)
		remain_cnt_reg <= data_cnt;
end
// fsm
always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		state <= IDLE;
	end
	else begin
		case(state)
			IDLE: begin
					if(data_cnt == MAX_CNT-1 && i_axi_vld && skip_init_done && m_axis_tready) begin
						state <= READ;
					end
					else begin
						state <= IDLE;
					end
				end
			READ: begin
					if(~m_axis_tready || ~m_first_axis_tready)
						state <= WAIT;
					else if(fifo_cnt == remain_cnt_reg+1) begin
						state <= IDLE;
					end
					else begin
						state <= READ;
					end
				end
			WAIT : if(m_axis_tready || m_first_axis_tready)
						state <= READ;
			default : begin 
						state <= IDLE;
					end
		endcase
	end	
end
assign rd_flag = state == READ;
always@(posedge clk) begin
	rd_flag_d0 <= rd_flag;	
end
always@(posedge clk) begin
	fifo_dout_d0 <= fifo_dout;	
end
always@(posedge clk or negedge rst_n) begin
	if(~rst_n)
		o_data_vld <= 1'b0;
	else if(rd_flag && fifo_cnt == remain_cnt_reg+1)
		o_data_vld <= 1'b0;
	else if(rd_flag)
		o_data_vld <= 1'b1;
	else
		o_data_vld <= 1'b0;
end

always@(posedge clk or negedge rst_n) begin
	if(~rst_n)
		o_devide_rdy <= 1'b1;
	else if(s_axis_tlast)
		o_devide_rdy <= 1'b0;
	else if(m_axis_tlast)
		o_devide_rdy <= 1'b1;
end

assign fifo_wen = i_axi_vld&&skip_init_done && state != WAIT;

always@(posedge clk or negedge rst_n) begin
	if(~rst_n)
		first_window_cnt <= 1'b0;
	else if(fifo_rst)
		first_window_cnt <= 1'b0;
	else if(m_axis_tlast)
		first_window_cnt <= 1'b1;
end

assign m_axis_tvalid = o_data_vld;
assign m_axis_tdata = fifo_dout[75:0];
assign m_axis_tlast = fifo_dout[76];
assign s_axis_tready = o_devide_rdy;

assign m_first_axis_tvalid = (first_window_cnt == 0)? m_axis_tvalid :0;
assign m_first_axis_tdata = (first_window_cnt == 0)? m_axis_tdata  :0;
assign m_first_axis_tlast = (first_window_cnt == 0)? m_axis_tlast  :0;


sync_fifo#(
	.BUF_SIZE (MAX_CNT),
	.BUF_WIDTH (77),
	.DP_WD (DP_WD),
	.USE_BRAM(USE_BRAM)
) sfifo_inst(
	.i_clk		(clk), 
	.i_rst		(fifo_rst || ~rst_n),
	.i_w_en		(fifo_wen),
	.i_r_en		(rd_flag),
	.i_data		({window_last,s_axis_tdata}),

	.o_buf_full		(full),
	.o_buf_empty		(empty),
	.o_data		(fifo_dout),
	.fifo_cnt	(fifo_cnt)
);


/*
fifo_generator_0 fifo_w77_d8192 (
  .clk(clk),                // input wire clk
  .srst(fifo_rst || ~rst_n),              // input wire srst
  .din({window_last,s_axis_tdata}),                // input wire [76 : 0] din
  .wr_en(fifo_wen),            // input wire wr_en
  .rd_en(rd_flag),            // input wire rd_en
  .dout(fifo_dout),              // output wire [76 : 0] dout
  .full(full),              // output wire full
  .empty(empty),            // output wire empty
  .data_count(fifo_cnt)  // output wire [13 : 0] data_count
);
*/
// 取2对数，判断一个数据需要多少位宽
    function integer clog2;
        input integer value;
              integer temp;
        begin
            temp = value;
            for (clog2 = 0; temp > 1; clog2 = clog2 + 1) begin
                temp = temp >> 1;
            end
        end
    endfunction

endmodule


