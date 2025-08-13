//***************************************
//COPYRIGHT(C)2025,EthasuLi
//All rights reserved.
//Module Name  : muti_data_segment.v
//
//Author       : EthasuLi
//Email        : 13591028146@163.com
//Data         : 2025/8/5
//Version      : V 1.0
//
//Abstract     : 
//Called by    :
//
//****************************************  
module muti_data_segment #(
	parameter LANE0_SKIP_CNT = 5000,
	parameter LANE1_SKIP_CNT = 5063,
	parameter LANE2_SKIP_CNT = 5125,
	parameter LANE3_SKIP_CNT = 5188,
	parameter LANE4_SKIP_CNT = 5250
)(
    input  wire                     clk,            // 主时钟
    input  wire                     rst_n,          // 异步复位
    // ========================= lane 0 =============================//
    // 输入AXI Stream接口 (64位)
    input  wire [75:0]              s_axis_tdata_0	,   // {real[31:0], imag[31:0]}
    input  wire                     s_axis_tvalid_0	,  // 数据有效
    input  wire                     s_axis_tlast_0	,   // 输入流结束标志
    output wire                     s_axis_tready_0	,  // 准备好接收
    
    // 输出AXI Stream接口 (64位)
    output wire [75:0]              m_axis_tdata_0	,   // {real[31:0], imag[31:0]}
    output wire                     m_axis_tvalid_0	,  // 数据有效
    output wire                     m_axis_tlast_0	,   // 周期结束标志
    input  wire                     m_axis_tready_0	,   // 下游准备好
	
	output wire	[75:0]				m_first_axis_tdata_0	,
	output wire						m_first_axis_tvalid_0	,
	output wire						m_first_axis_tlast_0	,
	input  wire						m_first_axis_tready_0	,
	// ========================= lane 1 =============================//
    // 输入AXI Stream接口 (64位)
    input  wire [75:0]              s_axis_tdata_1	,   // {real[31:0], imag[31:0]}
    input  wire                     s_axis_tvalid_1	,  // 数据有效
    input  wire                     s_axis_tlast_1  ,   // 输入流结束标志
    output wire                     s_axis_tready_1	,  // 准备好接收
    
    // 输出AXI Stream接口 (64位)
    output wire [75:0]              m_axis_tdata_1	,   // {real[31:0], imag[31:0]}
    output wire                     m_axis_tvalid_1	,  // 数据有效
    output wire                     m_axis_tlast_1	,   // 周期结束标志
    input  wire                     m_axis_tready_1	,   // 下游准备好
	
	output wire	[75:0]				m_first_axis_tdata_1	,
	output wire						m_first_axis_tvalid_1	,
	output wire						m_first_axis_tlast_1	,
	input  wire						m_first_axis_tready_1	,
	// ========================= lane 2 =============================//
    // 输入AXI Stream接口 (64位)
    input  wire [75:0]              s_axis_tdata_2	,   // {real[31:0], imag[31:0]}
    input  wire                     s_axis_tvalid_2	,  // 数据有效
    input  wire                     s_axis_tlast_2	,   // 输入流结束标志
    output wire                     s_axis_tready_2	,  // 准备好接收
    
    // 输出AXI Stream接口 (64位)
    output wire [75:0]              m_axis_tdata_2	,   // {real[31:0], imag[31:0]}
    output wire                     m_axis_tvalid_2	,  // 数据有效
    output wire                     m_axis_tlast_2	,   // 周期结束标志
    input  wire                     m_axis_tready_2	,   // 下游准备好
	
	output wire	[75:0]				m_first_axis_tdata_2	,
	output wire						m_first_axis_tvalid_2	,
	output wire						m_first_axis_tlast_2	,
	input  wire						m_first_axis_tready_2	,
	// ========================= lane 3 =============================//
    // 输入AXI Stream接口 (64位)
    input  wire [75:0]              s_axis_tdata_3	,   // {real[31:0], imag[31:0]}
    input  wire                     s_axis_tvalid_3	,  // 数据有效
    input  wire                     s_axis_tlast_3	,   // 输入流结束标志
    output wire                     s_axis_tready_3	,  // 准备好接收
    
    // 输出AXI Stream接口 (64位)
    output wire [75:0]              m_axis_tdata_3	,   // {real[31:0], imag[31:0]}
    output wire                     m_axis_tvalid_3	,  // 数据有效
    output wire                     m_axis_tlast_3	,   // 周期结束标志
    input  wire                     m_axis_tready_3	,   // 下游准备好
	
	output wire	[75:0]				m_first_axis_tdata_3	,
	output wire						m_first_axis_tvalid_3	,
	output wire						m_first_axis_tlast_3	,
	input  wire						m_first_axis_tready_3	,
	// ========================= lane 4 =============================//
    // 输入AXI Stream接口 (64位)
    input  wire [75:0]              s_axis_tdata_4	,   // {real[31:0], imag[31:0]}
    input  wire                     s_axis_tvalid_4	,  // 数据有效
    input  wire                     s_axis_tlast_4	,   // 输入流结束标志
    output wire                     s_axis_tready_4	,  // 准备好接收
    
    // 输出AXI Stream接口 (64位)
    output wire [75:0]              m_axis_tdata_4	,   // {real[31:0], imag[31:0]}
    output wire                     m_axis_tvalid_4	,  // 数据有效
    output wire                     m_axis_tlast_4	,   // 周期结束标志
    input  wire                     m_axis_tready_4	,   // 下游准备好
	
	output wire	[75:0]				m_first_axis_tdata_4	,
	output wire						m_first_axis_tvalid_4	,
	output wire						m_first_axis_tlast_4	,
	input  wire						m_first_axis_tready_4	
);
parameter LANE0_MAX_CNT = 31250;
parameter LANE1_MAX_CNT = 31250;
parameter LANE2_MAX_CNT = 31250;
parameter LANE3_MAX_CNT = 31250;
parameter LANE4_MAX_CNT = 31250;

parameter LANE0_MEM_STYLE = 1;
parameter LANE1_MEM_STYLE = 1;
parameter LANE2_MEM_STYLE = 1;
parameter LANE3_MEM_STYLE = 1;
parameter LANE4_MEM_STYLE = 0;
data_segment#(
	.MAX_CNT (LANE0_MAX_CNT),
	.SKIP_MAX (LANE0_SKIP_CNT),
	.USE_BRAM (LANE0_MEM_STYLE)
) lane0_data_segment (
    .clk					(clk				),            // 主时钟
    .rst_n					(rst_n				),          // 异步复位
    .s_axis_tdata			(s_axis_tdata_0		),   // {real[31:0], imag[31:0]}
    .s_axis_tvalid			(s_axis_tvalid_0		),  // 数据有效
    .s_axis_tlast			(s_axis_tlast_0		),   // 输入流结束标志
    .s_axis_tready			(s_axis_tready_0		),  // 准备好接收
    .m_axis_tdata			(m_axis_tdata_0		),   // {real[31:0], imag[31:0]}
    .m_axis_tvalid			(m_axis_tvalid_0		),  // 数据有效
    .m_axis_tlast			(m_axis_tlast_0		),   // 周期结束标志
    .m_axis_tready			(m_axis_tready_0		),   // 下游准备好
	.m_first_axis_tdata		(m_first_axis_tdata_0	),
	.m_first_axis_tvalid	(m_first_axis_tvalid_0),
	.m_first_axis_tlast		(m_first_axis_tlast_0	),
	.m_first_axis_tready    (m_first_axis_tready_0)
);
data_segment#(
	.MAX_CNT (LANE1_MAX_CNT),
	.SKIP_MAX (LANE1_SKIP_CNT),
	.USE_BRAM (LANE1_MEM_STYLE)
) lane1_data_segment (
    .clk					(clk				),            // 主时钟
    .rst_n					(rst_n				),          // 异步复位
    .s_axis_tdata			(s_axis_tdata_1		),   // {real[31:0], imag[31:0]}
    .s_axis_tvalid			(s_axis_tvalid_1		),  // 数据有效
    .s_axis_tlast			(s_axis_tlast_1		),   // 输入流结束标志
    .s_axis_tready			(s_axis_tready_1		),  // 准备好接收
    .m_axis_tdata			(m_axis_tdata_1		),   // {real[31:0], imag[31:0]}
    .m_axis_tvalid			(m_axis_tvalid_1		),  // 数据有效
    .m_axis_tlast			(m_axis_tlast_1		),   // 周期结束标志
    .m_axis_tready			(m_axis_tready_1		),   // 下游准备好
	.m_first_axis_tdata		(m_first_axis_tdata_1	),
	.m_first_axis_tvalid	(m_first_axis_tvalid_1),
	.m_first_axis_tlast		(m_first_axis_tlast_1	),
	.m_first_axis_tready    (m_first_axis_tready_1)
);
data_segment#(
	.MAX_CNT (LANE2_MAX_CNT),
	.SKIP_MAX (LANE2_SKIP_CNT),
	.USE_BRAM (LANE2_MEM_STYLE)
) lane2_data_segment (
    .clk					(clk				),            // 主时钟
    .rst_n					(rst_n				),          // 异步复位
    .s_axis_tdata			(s_axis_tdata_2		),   // {real[31:0], imag[31:0]}
    .s_axis_tvalid			(s_axis_tvalid_2		),  // 数据有效
    .s_axis_tlast			(s_axis_tlast_2		),   // 输入流结束标志
    .s_axis_tready			(s_axis_tready_2		),  // 准备好接收
    .m_axis_tdata			(m_axis_tdata_2		),   // {real[31:0], imag[31:0]}
    .m_axis_tvalid			(m_axis_tvalid_2		),  // 数据有效
    .m_axis_tlast			(m_axis_tlast_2		),   // 周期结束标志
    .m_axis_tready			(m_axis_tready_2		),   // 下游准备好
	.m_first_axis_tdata		(m_first_axis_tdata_2	),
	.m_first_axis_tvalid	(m_first_axis_tvalid_2),
	.m_first_axis_tlast		(m_first_axis_tlast_2	),
	.m_first_axis_tready    (m_first_axis_tready_2)
);
data_segment#(
	.MAX_CNT (LANE3_MAX_CNT),
	.SKIP_MAX (LANE3_SKIP_CNT),
	.USE_BRAM (LANE3_MEM_STYLE)
) lane3_data_segment (
    .clk					(clk				),            // 主时钟
    .rst_n					(rst_n				),          // 异步复位
    .s_axis_tdata			(s_axis_tdata_3		),   // {real[31:0], imag[31:0]}
    .s_axis_tvalid			(s_axis_tvalid_3		),  // 数据有效
    .s_axis_tlast			(s_axis_tlast_3		),   // 输入流结束标志
    .s_axis_tready			(s_axis_tready_3		),  // 准备好接收
    .m_axis_tdata			(m_axis_tdata_3		),   // {real[31:0], imag[31:0]}
    .m_axis_tvalid			(m_axis_tvalid_3		),  // 数据有效
    .m_axis_tlast			(m_axis_tlast_3		),   // 周期结束标志
    .m_axis_tready			(m_axis_tready_3		),   // 下游准备好
	.m_first_axis_tdata		(m_first_axis_tdata_3	),
	.m_first_axis_tvalid	(m_first_axis_tvalid_3),
	.m_first_axis_tlast		(m_first_axis_tlast_3	),
	.m_first_axis_tready    (m_first_axis_tready_3)
);
data_segment#(
	.MAX_CNT (LANE4_MAX_CNT),
	.SKIP_MAX (LANE4_SKIP_CNT),
	.USE_BRAM (LANE4_MEM_STYLE)
) lane4_data_segment (
    .clk					(clk				),            // 主时钟
    .rst_n					(rst_n				),          // 异步复位
    .s_axis_tdata			(s_axis_tdata_4		),   // {real[31:0], imag[31:0]}
    .s_axis_tvalid			(s_axis_tvalid_4		),  // 数据有效
    .s_axis_tlast			(s_axis_tlast_4		),   // 输入流结束标志
    .s_axis_tready			(s_axis_tready_4		),  // 准备好接收
    .m_axis_tdata			(m_axis_tdata_4		),   // {real[31:0], imag[31:0]}
    .m_axis_tvalid			(m_axis_tvalid_4		),  // 数据有效
    .m_axis_tlast			(m_axis_tlast_4		),   // 周期结束标志
    .m_axis_tready			(m_axis_tready_4		),   // 下游准备好
	.m_first_axis_tdata		(m_first_axis_tdata_4	),
	.m_first_axis_tvalid	(m_first_axis_tvalid_4),
	.m_first_axis_tlast		(m_first_axis_tlast_4	),
	.m_first_axis_tready    (m_first_axis_tready_4)
);
endmodule



