// Converted from VHDL: uart_tx.vhd
// Tool: Cadence Genus (vhdl2verilog.sh), 2026-11-25 08:01



module add_unsigned(A, B, Z);
  input [3:0] A;
  input B;
  output [3:0] Z;
  wire [3:0] A;
  wire B;
  wire [3:0] Z;
  wire n_11, n_18, n_21, n_28, n_30, n_34, n_35, n_37;
  wire n_38;
  xor g1 (Z[0], A[0], B);
  nand g2 (n_11, A[0], B);
  nand g13 (n_21, n_18, A[1]);
  nand g20 (n_30, n_28, A[2]);
  xnor g25 (Z[1], n_18, n_34);
  xnor g27 (Z[2], n_28, n_35);
  xnor g30 (Z[3], n_37, n_38);
  not g35 (n_18, n_11);
  not g36 (n_34, A[1]);
  not g37 (n_35, A[2]);
  not g38 (n_38, A[3]);
  not g39 (n_28, n_21);
  not g40 (n_37, n_30);
endmodule

module bmux(ctl, in_0, in_1, z);
  input ctl;
  input [3:0] in_0, in_1;
  output [3:0] z;
  wire ctl;
  wire [3:0] in_0, in_1;
  wire [3:0] z;
  CDN_bmux2 g1(.sel0 (ctl), .data0 (in_0[3]), .data1 (in_1[3]), .z
       (z[3]));
  CDN_bmux2 g2(.sel0 (ctl), .data0 (in_0[2]), .data1 (in_1[2]), .z
       (z[2]));
  CDN_bmux2 g3(.sel0 (ctl), .data0 (in_0[1]), .data1 (in_1[1]), .z
       (z[1]));
  CDN_bmux2 g4(.sel0 (ctl), .data0 (in_0[0]), .data1 (in_1[0]), .z
       (z[0]));
endmodule

module baud_gen_CLKS_PER_BIT16(clk, rst, en, tick);
  input clk, rst, en;
  output tick;
  wire clk, rst, en;
  wire tick;
  wire [3:0] cnt;
  wire [3:0] cnt_18;
  wire n_19, n_20, n_21, n_22, n_23, n_24, n_27, n_28;
  wire n_30, n_37, n_55;
  add_unsigned add_32_20(.A (cnt), .B (1'b1), .Z ({n_24, n_23, n_22,
       n_21}));
  bmux mux_cnt_28_17(.ctl (n_20), .in_0 ({n_24, n_23, n_22, n_21}),
       .in_1 (4'b0), .z (cnt_18));
  not g4 (n_28, n_19);
  and g6 (n_30, n_20, n_28);
  or g1 (n_19, rst, n_27);
  CDN_flop tick_reg(.clk (clk), .d (1'b0), .sena (1'b1), .aclr (1'b0),
       .apre (1'b0), .srl (n_37), .srd (n_28), .q (tick));
  or g7 (n_37, n_19, n_30);
  CDN_flop \cnt_reg[0] (.clk (clk), .d (cnt_18[0]), .sena (1'b1), .aclr
       (1'b0), .apre (1'b0), .srl (n_19), .srd (1'b0), .q (cnt[0]));
  CDN_flop \cnt_reg[1] (.clk (clk), .d (cnt_18[1]), .sena (1'b1), .aclr
       (1'b0), .apre (1'b0), .srl (n_19), .srd (1'b0), .q (cnt[1]));
  CDN_flop \cnt_reg[2] (.clk (clk), .d (cnt_18[2]), .sena (1'b1), .aclr
       (1'b0), .apre (1'b0), .srl (n_19), .srd (1'b0), .q (cnt[2]));
  CDN_flop \cnt_reg[3] (.clk (clk), .d (cnt_18[3]), .sena (1'b1), .aclr
       (1'b0), .apre (1'b0), .srl (n_19), .srd (1'b0), .q (cnt[3]));
  nand g13 (n_55, cnt[0], cnt[1], cnt[2], cnt[3]);
  not g14 (n_20, n_55);
  not g15 (n_27, en);
endmodule

module add_unsigned_17(A, B, Z);
  input [2:0] A;
  input B;
  output [2:0] Z;
  wire [2:0] A;
  wire B;
  wire [2:0] Z;
  wire n_9, n_15, n_18, n_20, n_24, n_25;
  xor g1 (Z[0], A[0], B);
  nand g2 (n_9, A[0], B);
  nand g11 (n_18, n_15, A[1]);
  xnor g17 (Z[1], n_15, n_24);
  xnor g19 (Z[2], n_20, n_25);
  not g23 (n_15, n_9);
  not g24 (n_24, A[1]);
  not g25 (n_25, A[2]);
  not g26 (n_20, n_18);
endmodule

module bmux_6(ctl, in_0, in_1, z);
  input ctl, in_0, in_1;
  output z;
  wire ctl, in_0, in_1;
  wire z;
  CDN_bmux2 g1(.sel0 (ctl), .data0 (in_0), .data1 (in_1), .z (z));
endmodule

module case_box(in_0, out_0);
  input [1:0] in_0;
  output [3:0] out_0;
  wire [1:0] in_0;
  wire [3:0] out_0;
  wire n_9, n_15, n_23, n_24, n_25, n_26;
  nand g1 (n_9, n_23, n_24);
  nand g2 (n_25, in_0[0], n_24);
  nand g3 (n_26, n_23, in_0[1]);
  nand g4 (n_15, in_0[0], in_0[1]);
  not g5 (out_0[3], n_9);
  not g6 (out_0[2], n_25);
  not g7 (out_0[1], n_26);
  not g8 (out_0[0], n_15);
  not g11 (n_24, in_0[1]);
  not g12 (n_23, in_0[0]);
endmodule

module mux(ctl, in_0, in_1, z);
  input [1:0] ctl;
  input [2:0] in_0, in_1;
  output [2:0] z;
  wire [1:0] ctl;
  wire [2:0] in_0, in_1;
  wire [2:0] z;
  CDN_mux2 g1(.sel0 (ctl[1]), .data0 (in_0[2]), .sel1 (ctl[0]), .data1
       (in_1[2]), .z (z[2]));
  CDN_mux2 g2(.sel0 (ctl[1]), .data0 (in_0[1]), .sel1 (ctl[0]), .data1
       (in_1[1]), .z (z[1]));
  CDN_mux2 g3(.sel0 (ctl[1]), .data0 (in_0[0]), .sel1 (ctl[0]), .data1
       (in_1[0]), .z (z[0]));
endmodule

module mux_22(ctl, in_0, in_1, z);
  input [1:0] ctl;
  input [7:0] in_0, in_1;
  output [7:0] z;
  wire [1:0] ctl;
  wire [7:0] in_0, in_1;
  wire [7:0] z;
  CDN_mux2 g1(.sel0 (ctl[1]), .data0 (in_0[7]), .sel1 (ctl[0]), .data1
       (in_1[7]), .z (z[7]));
  CDN_mux2 g2(.sel0 (ctl[1]), .data0 (in_0[6]), .sel1 (ctl[0]), .data1
       (in_1[6]), .z (z[6]));
  CDN_mux2 g3(.sel0 (ctl[1]), .data0 (in_0[5]), .sel1 (ctl[0]), .data1
       (in_1[5]), .z (z[5]));
  CDN_mux2 g4(.sel0 (ctl[1]), .data0 (in_0[4]), .sel1 (ctl[0]), .data1
       (in_1[4]), .z (z[4]));
  CDN_mux2 g5(.sel0 (ctl[1]), .data0 (in_0[3]), .sel1 (ctl[0]), .data1
       (in_1[3]), .z (z[3]));
  CDN_mux2 g6(.sel0 (ctl[1]), .data0 (in_0[2]), .sel1 (ctl[0]), .data1
       (in_1[2]), .z (z[2]));
  CDN_mux2 g7(.sel0 (ctl[1]), .data0 (in_0[1]), .sel1 (ctl[0]), .data1
       (in_1[1]), .z (z[1]));
  CDN_mux2 g8(.sel0 (ctl[1]), .data0 (in_0[0]), .sel1 (ctl[0]), .data1
       (in_1[0]), .z (z[0]));
endmodule

module bmux_26(ctl, in_0, in_1, in_2, z);
  input [1:0] ctl;
  input in_0, in_1, in_2;
  output z;
  wire [1:0] ctl;
  wire in_0, in_1, in_2;
  wire z;
  CDN_bmux3 g1(.sel0 (ctl[0]), .data0 (in_0), .data1 (in_1), .sel1
       (ctl[1]), .data2 (in_2), .z (z));
endmodule

module mux_28(ctl, in_0, in_1, in_2, in_3, z);
  input [3:0] ctl;
  input [1:0] in_0, in_1, in_2, in_3;
  output [1:0] z;
  wire [3:0] ctl;
  wire [1:0] in_0, in_1, in_2, in_3;
  wire [1:0] z;
  CDN_mux4 g1(.sel0 (ctl[3]), .data0 (in_0[1]), .sel1 (ctl[2]), .data1
       (in_1[1]), .sel2 (ctl[1]), .data2 (in_2[1]), .sel3 (ctl[0]),
       .data3 (in_3[1]), .z (z[1]));
  CDN_mux4 g2(.sel0 (ctl[3]), .data0 (in_0[0]), .sel1 (ctl[2]), .data1
       (in_1[0]), .sel2 (ctl[1]), .data2 (in_2[0]), .sel3 (ctl[0]),
       .data3 (in_3[0]), .z (z[0]));
endmodule

module uart_tx(clk, rst, tx_start, tx_data, tx, busy);
  input clk, rst, tx_start;
  input [7:0] tx_data;
  output tx, busy;
  wire clk, rst, tx_start;
  wire [7:0] tx_data;
  wire tx, busy;
  wire [2:0] bit_idx;
  wire [2:0] plus_102_36;
  wire [1:0] state;
  wire [7:0] shreg;
  wire n_42, n_44, n_45, n_46, n_47, n_48, n_49, n_50;
  wire n_59, n_60, n_61, n_62, n_63, n_64, n_65, n_66;
  wire n_67, n_68, n_69, n_70, n_71, n_72, n_75, n_76;
  wire n_77, n_78, n_80, n_81, n_82, n_84, n_86, n_87;
  wire n_88, n_89, n_91, n_95, n_144, n_145, n_146, tick;
  baud_gen_CLKS_PER_BIT16 u_baud(.clk (clk), .rst (rst), .en (busy),
       .tick (tick));
  add_unsigned_17 add_102_36(.A (bit_idx), .B (1'b1), .Z (plus_102_36));
  bmux_6 mux_running_64_29(.ctl (n_42), .in_0 (1'b1), .in_1 (1'b0), .z
       (busy));
  case_box ctl_state_80_14(.in_0 (state), .out_0 ({n_50, n_45, n_46,
       n_70}));
  mux mux_bit_idx_80_14(.ctl ({n_45, n_46}), .in_0 (3'b0), .in_1
       (plus_102_36), .z ({n_49, n_48, n_47}));
  mux_22 mux_shreg_80_14(.ctl ({n_50, n_46}), .in_0 (tx_data), .in_1
       ({1'b0, shreg[7:1]}), .z ({n_66, n_65, n_64, n_63, n_62, n_61,
       n_60, n_59}));
  bmux_6 mux_tx_83_25(.ctl (tx_start), .in_0 (1'b1), .in_1 (1'b0), .z
       (n_67));
  bmux_6 mux_tx_96_26(.ctl (n_44), .in_0 (shreg[1]), .in_1 (1'b1), .z
       (n_68));
  bmux_26 mux_tx_80_14(.ctl (state), .in_0 (n_67), .in_1 (shreg[0]),
       .in_2 (n_68), .z (n_69));
  mux_28 mux_state_80_14(.ctl ({n_50, n_45, n_46, n_70}), .in_0 (2'b1),
       .in_1 (2'b10), .in_2 (2'b11), .in_3 (2'b0), .z ({n_72, n_71}));
  and g10 (n_75, tick, n_45);
  or g11 (n_77, n_75, n_50);
  and g12 (n_76, tick, n_46);
  or g13 (n_78, n_76, n_77);
  and g14 (n_80, tx_start, n_50);
  and g17 (n_81, n_44, tick);
  and g18 (n_82, n_81, n_46);
  and g20 (n_84, tick, n_70);
  and g23 (n_88, n_87, tick);
  and g24 (n_89, n_88, n_46);
  or g25 (n_91, n_89, n_80);
  or g29 (n_95, n_89, n_75);
  CDN_flop tx_reg(.clk (clk), .d (n_69), .sena (n_78), .aclr (1'b0),
       .apre (1'b0), .srl (rst), .srd (1'b1), .q (tx));
  CDN_flop \state_reg[0] (.clk (clk), .d (n_71), .sena (n_86), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (state[0]));
  CDN_flop \state_reg[1] (.clk (clk), .d (n_72), .sena (n_86), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (state[1]));
  CDN_flop \shreg_reg[0] (.clk (clk), .d (n_59), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[0]));
  CDN_flop \shreg_reg[1] (.clk (clk), .d (n_60), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[1]));
  CDN_flop \shreg_reg[2] (.clk (clk), .d (n_61), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[2]));
  CDN_flop \shreg_reg[3] (.clk (clk), .d (n_62), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[3]));
  CDN_flop \shreg_reg[4] (.clk (clk), .d (n_63), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[4]));
  CDN_flop \shreg_reg[5] (.clk (clk), .d (n_64), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[5]));
  CDN_flop \shreg_reg[6] (.clk (clk), .d (n_65), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[6]));
  CDN_flop \shreg_reg[7] (.clk (clk), .d (n_66), .sena (n_91), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (shreg[7]));
  CDN_flop \bit_idx_reg[0] (.clk (clk), .d (n_47), .sena (n_95), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (bit_idx[0]));
  CDN_flop \bit_idx_reg[1] (.clk (clk), .d (n_48), .sena (n_95), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (bit_idx[1]));
  CDN_flop \bit_idx_reg[2] (.clk (clk), .d (n_49), .sena (n_95), .aclr
       (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q (bit_idx[2]));
  nand g60 (n_87, bit_idx[0], bit_idx[1], bit_idx[2]);
  not g61 (n_44, n_87);
  not g63 (n_145, state[1]);
  nand g64 (n_146, n_144, n_145);
  not g65 (n_42, n_146);
  not g66 (n_144, state[0]);
  or g67 (n_86, n_84, n_82, n_75, n_80);
endmodule

`ifdef RC_CDN_GENERIC_GATE
`else
module CDN_flop(clk, d, sena, aclr, apre, srl, srd, q);
  input clk, d, sena, aclr, apre, srl, srd;
  output q;
  wire clk, d, sena, aclr, apre, srl, srd;
  wire q;
  reg  qi;
  assign #1 q = qi;
  always 
    @(posedge clk or posedge apre or posedge aclr) 
      if (aclr) 
        qi <= 0;
      else if (apre) 
          qi <= 1;
        else if (srl) 
            qi <= srd;
          else begin
            if (sena) 
              qi <= d;
          end
  initial 
    qi <= 1'b0;
endmodule
`endif
`ifdef RC_CDN_GENERIC_GATE
`else
`ifdef ONE_HOT_MUX // captures one-hot property of select inputs
module CDN_mux2(sel0, data0, sel1, data1, z);
  input sel0, data0, sel1, data1;
  output z;
  wire sel0, data0, sel1, data1;
  reg  z;
  always 
    @(sel0 or sel1 or data0 or data1) 
      case ({sel0, sel1})
       2'b10: z = data0;
       2'b01: z = data1;
       default: z = 1'bX;
      endcase
endmodule
`else
module CDN_mux2(sel0, data0, sel1, data1, z);
  input sel0, data0, sel1, data1;
  output z;
  wire sel0, data0, sel1, data1;
  wire z;
  wire w_0, w_1;
  and a_0 (w_0, sel0, data0);
  and a_1 (w_1, sel1, data1);
  or org (z, w_0, w_1);
endmodule
`endif // ONE_HOT_MUX
`endif
`ifdef RC_CDN_GENERIC_GATE
`else
`ifdef ONE_HOT_MUX // captures one-hot property of select inputs
module CDN_mux4(sel0, data0, sel1, data1, sel2, data2, sel3, data3, z);
  input sel0, data0, sel1, data1, sel2, data2, sel3, data3;
  output z;
  wire sel0, data0, sel1, data1, sel2, data2, sel3, data3;
  reg  z;
  always 
    @(sel0 or sel1 or sel2 or sel3 or data0 or data1 or data2 or data3) 
      case ({sel0, sel1, sel2, sel3})
       4'b1000: z = data0;
       4'b0100: z = data1;
       4'b0010: z = data2;
       4'b0001: z = data3;
       default: z = 1'bX;
      endcase
endmodule
`else
module CDN_mux4(sel0, data0, sel1, data1, sel2, data2, sel3, data3, z);
  input sel0, data0, sel1, data1, sel2, data2, sel3, data3;
  output z;
  wire sel0, data0, sel1, data1, sel2, data2, sel3, data3;
  wire z;
  wire w_0, w_1, w_2, w_3;
  and a_0 (w_0, sel0, data0);
  and a_1 (w_1, sel1, data1);
  and a_2 (w_2, sel2, data2);
  and a_3 (w_3, sel3, data3);
  or org (z, w_0, w_1, w_2, w_3);
endmodule
`endif // ONE_HOT_MUX
`endif
`ifdef RC_CDN_GENERIC_GATE
`else
`ifdef ONE_HOT_MUX
module CDN_bmux2(sel0, data0, data1, z);
  input sel0, data0, data1;
  output z;
  wire sel0, data0, data1;
  reg  z;
  always 
    @(sel0 or data0 or data1) 
      case ({sel0})
       1'b0: z = data0;
       1'b1: z = data1;
      endcase
endmodule
`else
module CDN_bmux2(sel0, data0, data1, z);
  input sel0, data0, data1;
  output z;
  wire sel0, data0, data1;
  wire z;
  wire inv_sel0, w_0, w_1;
  not i_0 (inv_sel0, sel0);
  and a_0 (w_0, inv_sel0, data0);
  and a_1 (w_1, sel0, data1);
  or org (z, w_0, w_1);
endmodule
`endif // ONE_HOT_MUX
`endif
`ifdef RC_CDN_GENERIC_GATE
`else
`ifdef ONE_HOT_MUX
module CDN_bmux3(sel0, data0, data1, sel1, data2, z);
  input sel0, data0, data1, sel1, data2;
  output z;
  wire sel0, data0, data1, sel1, data2;
  reg  z;
  always 
    @(sel0 or sel1 or data0 or data1 or data2) 
      case ({sel0, sel1})
       2'b00: z = data0;
       2'b10: z = data1;
       2'b01: z = data2;
       default: z = 1'bX;
      endcase
endmodule
`else
module CDN_bmux3(sel0, data0, data1, sel1, data2, z);
  input sel0, data0, data1, sel1, data2;
  output z;
  wire sel0, data0, data1, sel1, data2;
  wire z;
  wire inv_sel0, inv_sel1, w_0, w_1, w_2;
  not i_0 (inv_sel0, sel0);
  not i_1 (inv_sel1, sel1);
  and a_0 (w_0, inv_sel1, inv_sel0, data0);
  and a_1 (w_1, inv_sel1, sel0, data1);
  and a_2 (w_2, sel1, inv_sel0, data2);
  or org (z, w_0, w_1, w_2);
endmodule
`endif // ONE_HOT_MUX
`endif
