`timescale 1ns/1ps

module tb_muti_data_segment;
  //———— 时钟 & 复位 ————
  reg clk;
  reg rst_n;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;       // 100MHz
  end
  initial begin
    rst_n = 0;
    #20 rst_n = 1;
  end

  //———— 配置参数 ————
  // 请按需调整下面五路的跳过计数和窗口长度
  localparam LANE0_SKIP_CNT = 5000;
  localparam LANE1_SKIP_CNT = 5063;
  localparam LANE2_SKIP_CNT = 5125;
  localparam LANE3_SKIP_CNT = 5188;
  localparam LANE4_SKIP_CNT = 5250;
  localparam WINDOW_SIZE    = 500;
  localparam LEFTOVER       = WINDOW_SIZE/2;
  //———— end 配置 ————

  //———— 信号声明 （lane0 … lane4） ————
  // lane0
  reg  [75:0] s_axis_tdata_0;
  reg         s_axis_tvalid_0;
  reg         s_axis_tlast_0;
  wire        s_axis_tready_0;
  wire [75:0] m_axis_tdata_0;
  wire        m_axis_tvalid_0;
  wire        m_axis_tlast_0;
  reg         m_axis_tready_0;
  wire [75:0] m_first_axis_tdata_0;
  wire        m_first_axis_tvalid_0;
  wire        m_first_axis_tlast_0;
  reg         m_first_axis_tready_0;

  // lane1
  reg  [75:0] s_axis_tdata_1;
  reg         s_axis_tvalid_1;
  reg         s_axis_tlast_1;
  wire        s_axis_tready_1;
  wire [75:0] m_axis_tdata_1;
  wire        m_axis_tvalid_1;
  wire        m_axis_tlast_1;
  reg         m_axis_tready_1;
  wire [75:0] m_first_axis_tdata_1;
  wire        m_first_axis_tvalid_1;
  wire        m_first_axis_tlast_1;
  reg         m_first_axis_tready_1;

  // lane2
  reg  [75:0] s_axis_tdata_2;
  reg         s_axis_tvalid_2;
  reg         s_axis_tlast_2;
  wire        s_axis_tready_2;
  wire [75:0] m_axis_tdata_2;
  wire        m_axis_tvalid_2;
  wire        m_axis_tlast_2;
  reg         m_axis_tready_2;
  wire [75:0] m_first_axis_tdata_2;
  wire        m_first_axis_tvalid_2;
  wire        m_first_axis_tlast_2;
  reg         m_first_axis_tready_2;

  // lane3
  reg  [75:0] s_axis_tdata_3;
  reg         s_axis_tvalid_3;
  reg         s_axis_tlast_3;
  wire        s_axis_tready_3;
  wire [75:0] m_axis_tdata_3;
  wire        m_axis_tvalid_3;
  wire        m_axis_tlast_3;
  reg         m_axis_tready_3;
  wire [75:0] m_first_axis_tdata_3;
  wire        m_first_axis_tvalid_3;
  wire        m_first_axis_tlast_3;
  reg         m_first_axis_tready_3;

  // lane4
  reg  [75:0] s_axis_tdata_4;
  reg         s_axis_tvalid_4;
  reg         s_axis_tlast_4;
  wire        s_axis_tready_4;
  wire [75:0] m_axis_tdata_4;
  wire        m_axis_tvalid_4;
  wire        m_axis_tlast_4;
  reg         m_axis_tready_4;
  wire [75:0] m_first_axis_tdata_4;
  wire        m_first_axis_tvalid_4;
  wire        m_first_axis_tlast_4;
  reg         m_first_axis_tready_4;
  //———— end 信号声明 ————

  //———— DUT 实例化 ————
  muti_data_segment #(
    .LANE0_SKIP_CNT(LANE0_SKIP_CNT),
    .LANE1_SKIP_CNT(LANE1_SKIP_CNT),
    .LANE2_SKIP_CNT(LANE2_SKIP_CNT),
    .LANE3_SKIP_CNT(LANE3_SKIP_CNT),
    .LANE4_SKIP_CNT(LANE4_SKIP_CNT)
  ) uut (
    .clk                    (clk),
    .rst_n                  (rst_n),
    // lane0
    .s_axis_tdata_0         (s_axis_tdata_0),
    .s_axis_tvalid_0        (s_axis_tvalid_0),
    .s_axis_tlast_0         (s_axis_tlast_0),
    .s_axis_tready_0        (s_axis_tready_0),
    .m_axis_tdata_0         (m_axis_tdata_0),
    .m_axis_tvalid_0        (m_axis_tvalid_0),
    .m_axis_tlast_0         (m_axis_tlast_0),
    .m_axis_tready_0        (m_axis_tready_0),
    .m_first_axis_tdata_0   (m_first_axis_tdata_0),
    .m_first_axis_tvalid_0  (m_first_axis_tvalid_0),
    .m_first_axis_tlast_0   (m_first_axis_tlast_0),
    .m_first_axis_tready_0  (m_first_axis_tready_0),
    // lane1
    .s_axis_tdata_1         (s_axis_tdata_1),
    .s_axis_tvalid_1        (s_axis_tvalid_1),
    .s_axis_tlast_1         (s_axis_tlast_1),
    .s_axis_tready_1        (s_axis_tready_1),
    .m_axis_tdata_1         (m_axis_tdata_1),
    .m_axis_tvalid_1        (m_axis_tvalid_1),
    .m_axis_tlast_1         (m_axis_tlast_1),
    .m_axis_tready_1        (m_axis_tready_1),
    .m_first_axis_tdata_1   (m_first_axis_tdata_1),
    .m_first_axis_tvalid_1  (m_first_axis_tvalid_1),
    .m_first_axis_tlast_1   (m_first_axis_tlast_1),
    .m_first_axis_tready_1  (m_first_axis_tready_1),
    // lane2
    .s_axis_tdata_2         (s_axis_tdata_2),
    .s_axis_tvalid_2        (s_axis_tvalid_2),
    .s_axis_tlast_2         (s_axis_tlast_2),
    .s_axis_tready_2        (s_axis_tready_2),
    .m_axis_tdata_2         (m_axis_tdata_2),
    .m_axis_tvalid_2        (m_axis_tvalid_2),
    .m_axis_tlast_2         (m_axis_tlast_2),
    .m_axis_tready_2        (m_axis_tready_2),
    .m_first_axis_tdata_2   (m_first_axis_tdata_2),
    .m_first_axis_tvalid_2  (m_first_axis_tvalid_2),
    .m_first_axis_tlast_2   (m_first_axis_tlast_2),
    .m_first_axis_tready_2  (m_first_axis_tready_2),
    // lane3
    .s_axis_tdata_3         (s_axis_tdata_3),
    .s_axis_tvalid_3        (s_axis_tvalid_3),
    .s_axis_tlast_3         (s_axis_tlast_3),
    .s_axis_tready_3        (s_axis_tready_3),
    .m_axis_tdata_3         (m_axis_tdata_3),
    .m_axis_tvalid_3        (m_axis_tvalid_3),
    .m_axis_tlast_3         (m_axis_tlast_3),
    .m_axis_tready_3        (m_axis_tready_3),
    .m_first_axis_tdata_3   (m_first_axis_tdata_3),
    .m_first_axis_tvalid_3  (m_first_axis_tvalid_3),
    .m_first_axis_tlast_3   (m_first_axis_tlast_3),
    .m_first_axis_tready_3  (m_first_axis_tready_3),
    // lane4
    .s_axis_tdata_4         (s_axis_tdata_4),
    .s_axis_tvalid_4        (s_axis_tvalid_4),
    .s_axis_tlast_4         (s_axis_tlast_4),
    .s_axis_tready_4        (s_axis_tready_4),
    .m_axis_tdata_4         (m_axis_tdata_4),
    .m_axis_tvalid_4        (m_axis_tvalid_4),
    .m_axis_tlast_4         (m_axis_tlast_4),
    .m_axis_tready_4        (m_axis_tready_4),
    .m_first_axis_tdata_4   (m_first_axis_tdata_4),
    .m_first_axis_tvalid_4  (m_first_axis_tvalid_4),
    .m_first_axis_tlast_4   (m_first_axis_tlast_4),
    .m_first_axis_tready_4  (m_first_axis_tready_4)
  );
  //———— end 实例化 ————

  //———— 默认信号 ————
  initial begin
    s_axis_tdata_0     = 0; s_axis_tvalid_0 = 0; s_axis_tlast_0 = 0; m_axis_tready_0     = 1; m_first_axis_tready_0 = 1;
    s_axis_tdata_1     = 0; s_axis_tvalid_1 = 0; s_axis_tlast_1 = 0; m_axis_tready_1     = 1; m_first_axis_tready_1 = 1;
    s_axis_tdata_2     = 0; s_axis_tvalid_2 = 0; s_axis_tlast_2 = 0; m_axis_tready_2     = 1; m_first_axis_tready_2 = 1;
    s_axis_tdata_3     = 0; s_axis_tvalid_3 = 0; s_axis_tlast_3 = 0; m_axis_tready_3     = 1; m_first_axis_tready_3 = 1;
    s_axis_tdata_4     = 0; s_axis_tvalid_4 = 0; s_axis_tlast_4 = 0; m_axis_tready_4     = 1; m_first_axis_tready_4 = 1;
  end
  //———— end 默认 ————

  //———— 驱动 & 监控 ————
  integer total_len0, total_len1, total_len2, total_len3, total_len4;
  initial begin
    // 等复位
    @(posedge rst_n);
    #10;
    // 计算每路要发的数据长度：skip + window + leftover
    total_len0 = LANE0_SKIP_CNT + 5*WINDOW_SIZE + LEFTOVER;
    total_len1 = LANE1_SKIP_CNT + 5*WINDOW_SIZE + LEFTOVER;
    total_len2 = LANE2_SKIP_CNT + 5*WINDOW_SIZE + LEFTOVER;
    total_len3 = LANE3_SKIP_CNT + 5*WINDOW_SIZE + LEFTOVER;
    total_len4 = LANE4_SKIP_CNT + 5*WINDOW_SIZE + LEFTOVER;

    // 并行发包
    fork
      send_packet_0(total_len0);
      send_packet_1(total_len1);
      send_packet_2(total_len2);
      send_packet_3(total_len3);
      send_packet_4(total_len4);
    join

  end

  always @(posedge clk) begin
    // lane0 输出
    if (m_axis_tvalid_0 && m_axis_tready_0)
      $display("%0t L0 OUT    data=%0d last=%b", $time, m_axis_tdata_0, m_axis_tlast_0);
    if (m_first_axis_tvalid_0 && m_first_axis_tready_0)
      $display("%0t L0 FIRST  data=%0d last=%b", $time, m_first_axis_tdata_0, m_first_axis_tlast_0);
    // lane1 输出
    if (m_axis_tvalid_1 && m_axis_tready_1)
      $display("%0t L1 OUT    data=%0d last=%b", $time, m_axis_tdata_1, m_axis_tlast_1);
    if (m_first_axis_tvalid_1 && m_first_axis_tready_1)
      $display("%0t L1 FIRST  data=%0d last=%b", $time, m_first_axis_tdata_1, m_first_axis_tlast_1);
    // lane2 输出
    if (m_axis_tvalid_2 && m_axis_tready_2)
      $display("%0t L2 OUT    data=%0d last=%b", $time, m_axis_tdata_2, m_axis_tlast_2);
    if (m_first_axis_tvalid_2 && m_first_axis_tready_2)
      $display("%0t L2 FIRST  data=%0d last=%b", $time, m_first_axis_tdata_2, m_first_axis_tlast_2);
    // lane3 输出
    if (m_axis_tvalid_3 && m_axis_tready_3)
      $display("%0t L3 OUT    data=%0d last=%b", $time, m_axis_tdata_3, m_axis_tlast_3);
    if (m_first_axis_tvalid_3 && m_first_axis_tready_3)
      $display("%0t L3 FIRST  data=%0d last=%b", $time, m_first_axis_tdata_3, m_first_axis_tlast_3);
    // lane4 输出
    if (m_axis_tvalid_4 && m_axis_tready_4)
      $display("%0t L4 OUT    data=%0d last=%b", $time, m_axis_tdata_4, m_axis_tlast_4);
    if (m_first_axis_tvalid_4 && m_first_axis_tready_4)
      $display("%0t L4 FIRST  data=%0d last=%b", $time, m_first_axis_tdata_4, m_first_axis_tlast_4);
  end

  //———— send_packet 任务（各 lane） ————
  task send_packet_0(input integer pkt_len);
    integer i;
    begin
      for (i = 0; i < pkt_len; i = i + 1) begin
        @(posedge clk);
        if (s_axis_tready_0) begin
          s_axis_tvalid_0 <= 1;
          s_axis_tdata_0  <= i;
          s_axis_tlast_0  <= (i == pkt_len-1);
        end else begin
          s_axis_tvalid_0 <= 0;
          s_axis_tlast_0  <= 0;
          i = i - 1;
        end
      end
      @(posedge clk) begin
        s_axis_tvalid_0 <= 0;
        s_axis_tlast_0  <= 0;
      end
    end
  endtask

  task send_packet_1(input integer pkt_len);
    integer i;
    begin
      for (i = 0; i < pkt_len; i = i + 1) begin
        @(posedge clk);
        if (s_axis_tready_1) begin
          s_axis_tvalid_1 <= 1;
          s_axis_tdata_1  <= i;
          s_axis_tlast_1  <= (i == pkt_len-1);
        end else begin
          s_axis_tvalid_1 <= 0;
          s_axis_tlast_1  <= 0;
          i = i - 1;
        end
      end
      @(posedge clk) begin
        s_axis_tvalid_1 <= 0;
        s_axis_tlast_1  <= 0;
      end
    end
  endtask

  task send_packet_2(input integer pkt_len);
    integer i;
    begin
      for (i = 0; i < pkt_len; i = i + 1) begin
        @(posedge clk);
        if (s_axis_tready_2) begin
          s_axis_tvalid_2 <= 1;
          s_axis_tdata_2  <= i;
          s_axis_tlast_2  <= (i == pkt_len-1);
        end else begin
          s_axis_tvalid_2 <= 0;
          s_axis_tlast_2  <= 0;
          i = i - 1;
        end
      end
      @(posedge clk) begin
        s_axis_tvalid_2 <= 0;
        s_axis_tlast_2  <= 0;
      end
    end
  endtask

  task send_packet_3(input integer pkt_len);
    integer i;
    begin
      for (i = 0; i < pkt_len; i = i + 1) begin
        @(posedge clk);
        if (s_axis_tready_3) begin
          s_axis_tvalid_3 <= 1;
          s_axis_tdata_3  <= i;
          s_axis_tlast_3  <= (i == pkt_len-1);
        end else begin
          s_axis_tvalid_3 <= 0;
          s_axis_tlast_3  <= 0;
          i = i - 1;
        end
      end
      @(posedge clk) begin
        s_axis_tvalid_3 <= 0;
        s_axis_tlast_3  <= 0;
      end
    end
  endtask

  task send_packet_4(input integer pkt_len);
    integer i;
    begin
      for (i = 0; i < pkt_len; i = i + 1) begin
        @(posedge clk);
        if (s_axis_tready_4) begin
          s_axis_tvalid_4 <= 1;
          s_axis_tdata_4  <= i;
          s_axis_tlast_4  <= (i == pkt_len-1);
        end else begin
          s_axis_tvalid_4 <= 0;
          s_axis_tlast_4  <= 0;
          i = i - 1;
        end
      end
      @(posedge clk) begin
        s_axis_tvalid_4 <= 0;
        s_axis_tlast_4  <= 0;
      end
    end
  endtask
  //———— end send_packet ————

endmodule
