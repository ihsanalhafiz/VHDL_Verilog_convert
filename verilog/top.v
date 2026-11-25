// Converted from VHDL: top.vhd
// Tool: Cadence Genus (vhdl2verilog.sh), 2026-11-25 08:01



module add_unsigned(A, B, Z);
  input [7:0] A;
  input B;
  output [7:0] Z;
  wire [7:0] A;
  wire B;
  wire [7:0] Z;
  wire n_19, n_30, n_33, n_35, n_39, n_41, n_45, n_51;
  wire n_52, n_54, n_55, n_57, n_61, n_68, n_70, n_71;
  wire n_72, n_73, n_75, n_80, n_83, n_87, n_89, n_92;
  wire n_93;
  xor g1 (Z[0], A[0], B);
  nand g2 (n_19, A[0], B);
  nand g21 (n_33, n_30, A[1]);
  nor g26 (n_55, n_39, n_35);
  nor g30 (n_61, n_45, n_41);
  nand g36 (n_54, n_52, A[2]);
  nand g38 (n_57, n_55, n_52);
  nand g44 (n_72, n_61, A[6]);
  nand g51 (n_70, n_68, A[4]);
  nand g53 (n_71, n_61, n_68);
  not g55 (n_73, n_72);
  nand g56 (n_75, n_68, n_73);
  xnor g62 (Z[1], n_30, n_80);
  xnor g64 (Z[2], n_52, n_39);
  xnor g67 (Z[3], n_83, n_35);
  xnor g69 (Z[4], n_68, n_45);
  xnor g72 (Z[5], n_87, n_41);
  xnor g74 (Z[6], n_89, n_51);
  xnor g77 (Z[7], n_92, n_93);
  not g80 (n_39, A[2]);
  not g81 (n_35, A[3]);
  not g82 (n_45, A[4]);
  not g83 (n_41, A[5]);
  not g84 (n_51, A[6]);
  not g86 (n_30, n_19);
  not g87 (n_80, A[1]);
  not g88 (n_93, A[7]);
  not g89 (n_52, n_33);
  not g90 (n_83, n_54);
  not g91 (n_68, n_57);
  not g92 (n_87, n_70);
  not g93 (n_89, n_71);
  not g94 (n_92, n_75);
endmodule

module counter_WIDTH8(clk, rst, en, count);
  input clk, rst, en;
  output [7:0] count;
  wire clk, rst, en;
  wire [7:0] count;
  wire [7:0] plus_27_24;
  add_unsigned add_27_24(.A (count), .B (1'b1), .Z (plus_27_24));
  CDN_flop \cnt_r_reg[0] (.clk (clk), .d (plus_27_24[0]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[0]));
  CDN_flop \cnt_r_reg[1] (.clk (clk), .d (plus_27_24[1]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[1]));
  CDN_flop \cnt_r_reg[2] (.clk (clk), .d (plus_27_24[2]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[2]));
  CDN_flop \cnt_r_reg[3] (.clk (clk), .d (plus_27_24[3]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[3]));
  CDN_flop \cnt_r_reg[4] (.clk (clk), .d (plus_27_24[4]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[4]));
  CDN_flop \cnt_r_reg[5] (.clk (clk), .d (plus_27_24[5]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[5]));
  CDN_flop \cnt_r_reg[6] (.clk (clk), .d (plus_27_24[6]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[6]));
  CDN_flop \cnt_r_reg[7] (.clk (clk), .d (plus_27_24[7]), .sena (en),
       .aclr (1'b0), .apre (1'b0), .srl (rst), .srd (1'b0), .q
       (count[7]));
endmodule

module lt_unsigned(A, B, Z);
  input [7:0] A, B;
  output Z;
  wire [7:0] A, B;
  wire Z;
  wire n_28, n_29, n_30, n_31, n_32, n_33, n_34, n_36;
  wire n_37, n_39, n_40, n_41, n_42, n_43, n_44, n_45;
  wire n_46, n_47, n_48, n_49, n_50, n_51, n_52, n_53;
  wire n_54, n_55, n_56, n_57, n_58, n_59, n_60, n_61;
  wire n_62, n_65, n_66, n_67, n_68, n_71, n_73, n_74;
  wire n_75, n_76, n_77, n_78, n_86, n_87, n_88, n_89;
  not g2 (n_28, B[7]);
  not g3 (n_29, B[6]);
  not g4 (n_30, B[5]);
  not g5 (n_31, B[4]);
  not g6 (n_32, B[3]);
  not g7 (n_33, B[2]);
  not g8 (n_34, B[1]);
  not g10 (Z, n_36);
  nand g14 (n_40, n_37, B[0]);
  nor g15 (n_39, A[1], n_34);
  nand g16 (n_42, A[1], n_34);
  nor g17 (n_49, A[2], n_33);
  nand g18 (n_44, A[2], n_33);
  nor g19 (n_45, A[3], n_32);
  nand g20 (n_46, A[3], n_32);
  nor g21 (n_55, A[4], n_31);
  nand g22 (n_50, A[4], n_31);
  nor g23 (n_51, A[5], n_30);
  nand g24 (n_52, A[5], n_30);
  nor g25 (n_61, A[6], n_29);
  nand g26 (n_56, A[6], n_29);
  nor g27 (n_57, A[7], n_28);
  nand g28 (n_58, A[7], n_28);
  not g29 (n_41, n_39);
  nand g30 (n_43, n_40, n_41);
  nand g31 (n_62, n_42, n_43);
  nor g32 (n_47, n_44, n_45);
  not g33 (n_48, n_46);
  nor g34 (n_66, n_47, n_48);
  nor g35 (n_65, n_49, n_45);
  nor g36 (n_53, n_50, n_51);
  not g37 (n_54, n_52);
  nor g38 (n_68, n_53, n_54);
  nor g39 (n_71, n_55, n_51);
  nor g40 (n_59, n_56, n_57);
  not g41 (n_60, n_58);
  nor g42 (n_75, n_59, n_60);
  nor g43 (n_73, n_61, n_57);
  nand g47 (n_67, n_65, n_62);
  nand g48 (n_78, n_66, n_67);
  not g54 (n_74, n_73);
  nor g55 (n_76, n_68, n_74);
  not g56 (n_77, n_75);
  nor g57 (n_88, n_76, n_77);
  nand g58 (n_86, n_71, n_73);
  not g67 (n_87, n_86);
  nand g68 (n_89, n_78, n_87);
  nand g69 (n_36, n_88, n_89);
  not g88 (n_37, A[0]);
endmodule

module pwm_gen_WIDTH8(clk, rst, duty, pwm);
  input clk, rst;
  input [7:0] duty;
  output pwm;
  wire clk, rst;
  wire [7:0] duty;
  wire pwm;
  wire [7:0] count;
  wire n_7, n_11, n_12, n_25;
  counter_WIDTH8 u_counter(.clk (clk), .rst (rst), .en (1'b1), .count
       (count));
  lt_unsigned lt_35_29(.A (count), .B (duty), .Z (n_7));
  not g2 (n_11, rst);
  and g4 (n_12, n_7, n_11);
  CDN_flop pwm_reg(.clk (clk), .d (1'b0), .sena (1'b1), .aclr (1'b0),
       .apre (1'b0), .srl (n_25), .srd (n_11), .q (pwm));
  or g1 (n_25, rst, n_12);
endmodule

module bmux_5(ctl, in_0, in_1, z);
  input ctl, in_0, in_1;
  output z;
  wire ctl, in_0, in_1;
  wire z;
  CDN_bmux2 g1(.sel0 (ctl), .data0 (in_0), .data1 (in_1), .z (z));
endmodule

module bmux_16(ctl, in_0, in_1, z);
  input ctl;
  input [1:0] in_0, in_1;
  output [1:0] z;
  wire ctl;
  wire [1:0] in_0, in_1;
  wire [1:0] z;
  CDN_bmux2 g1(.sel0 (ctl), .data0 (in_0[1]), .data1 (in_1[1]), .z
       (z[1]));
  CDN_bmux2 g2(.sel0 (ctl), .data0 (in_0[0]), .data1 (in_1[0]), .z
       (z[0]));
endmodule

module bmux_20(ctl, in_0, in_1, in_2, in_3, in_4, z);
  input [2:0] ctl, in_0, in_1, in_2, in_3, in_4;
  output [2:0] z;
  wire [2:0] ctl, in_0, in_1, in_2, in_3, in_4;
  wire [2:0] z;
  CDN_bmux5 g1(.sel0 (ctl[0]), .data0 (in_0[2]), .data1 (in_1[2]),
       .sel1 (ctl[1]), .data2 (in_2[2]), .data3 (in_3[2]), .sel2
       (ctl[2]), .data4 (in_4[2]), .z (z[2]));
  CDN_bmux5 g2(.sel0 (ctl[0]), .data0 (in_0[1]), .data1 (in_1[1]),
       .sel1 (ctl[1]), .data2 (in_2[1]), .data3 (in_3[1]), .sel2
       (ctl[2]), .data4 (in_4[1]), .z (z[1]));
  CDN_bmux5 g3(.sel0 (ctl[0]), .data0 (in_0[0]), .data1 (in_1[0]),
       .sel1 (ctl[1]), .data2 (in_2[0]), .data3 (in_3[0]), .sel2
       (ctl[2]), .data4 (in_4[0]), .z (z[0]));
endmodule

module seq_detect(clk, rst, din, found);
  input clk, rst, din;
  output found;
  wire clk, rst, din;
  wire found;
  wire [2:0] next_state;
  wire [2:0] next_state_42;
  wire [2:0] next_state_43;
  wire [2:0] next_state_44;
  wire [2:0] next_state_45;
  wire [2:0] state;
  wire [2:0] next_state_46;
  wire n_44, n_45, n_56, n_57, n_59;
  bmux_5 mux_next_state_33_29(.ctl (din), .in_0 (1'b0), .in_1 (1'b1),
       .z (next_state[0]));
  bmux_16 mux_next_state_34_29(.ctl (n_44), .in_0 (2'b1), .in_1
       (2'b10), .z (next_state_42[1:0]));
  bmux_16 mux_next_state_35_29(.ctl (din), .in_0 (2'b0), .in_1 (2'b11),
       .z (next_state_43[1:0]));
  bmux_16 mux_next_state_36_29(.ctl (din), .in_0 (2'b1), .in_1 (2'b10),
       .z (next_state_44[2:1]));
  bmux_16 mux_next_state_37_29(.ctl (din), .in_0 (2'b10), .in_1 (2'b1),
       .z (next_state_45[1:0]));
  bmux_20 mux_next_state_32_10(.ctl (state), .in_0 ({2'b0,
       next_state[0]}), .in_1 ({1'b0, next_state_42[1:0]}), .in_2
       ({1'b0, next_state_43[1:0]}), .in_3 ({next_state_44[2:1],
       1'b0}), .in_4 ({1'b0, next_state_45[1:0]}), .z (next_state_46));
  bmux_5 mux_found_42_27(.ctl (n_45), .in_0 (1'b0), .in_1 (1'b1), .z
       (found));
  CDN_flop \state_reg[0] (.clk (clk), .d (next_state_46[0]), .sena
       (1'b1), .aclr (rst), .apre (1'b0), .srl (1'b0), .srd (1'b0), .q
       (state[0]));
  CDN_flop \state_reg[1] (.clk (clk), .d (next_state_46[1]), .sena
       (1'b1), .aclr (rst), .apre (1'b0), .srl (1'b0), .srd (1'b0), .q
       (state[1]));
  CDN_flop \state_reg[2] (.clk (clk), .d (next_state_46[2]), .sena
       (1'b1), .aclr (rst), .apre (1'b0), .srl (1'b0), .srd (1'b0), .q
       (state[2]));
  nand g11 (n_59, n_56, n_57, state[2]);
  not g12 (n_45, n_59);
  not g13 (n_44, din);
  not g14 (n_56, state[0]);
  not g15 (n_57, state[1]);
endmodule

module top(clk, rst, duty, din, pwm_out, found);
  input clk, rst, din;
  input [7:0] duty;
  output pwm_out, found;
  wire clk, rst, din;
  wire [7:0] duty;
  wire pwm_out, found;
  pwm_gen_WIDTH8 u_pwm(.clk (clk), .rst (rst), .duty (duty), .pwm
       (pwm_out));
  seq_detect u_det(.clk (clk), .rst (rst), .din (din), .found (found));
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
module CDN_bmux5(sel0, data0, data1, sel1, data2, data3, sel2, data4,
     z);
  input sel0, data0, data1, sel1, data2, data3, sel2, data4;
  output z;
  wire sel0, data0, data1, sel1, data2, data3, sel2, data4;
  reg  z;
  always 
    @(sel0 or sel1 or sel2 or data0 or data1 or data2 or data3 or
         data4) 
      case ({sel0, sel1, sel2})
       3'b000: z = data0;
       3'b100: z = data1;
       3'b010: z = data2;
       3'b110: z = data3;
       3'b001: z = data4;
       default: z = 1'bX;
      endcase
endmodule
`else
module CDN_bmux5(sel0, data0, data1, sel1, data2, data3, sel2, data4,
     z);
  input sel0, data0, data1, sel1, data2, data3, sel2, data4;
  output z;
  wire sel0, data0, data1, sel1, data2, data3, sel2, data4;
  wire z;
  wire inv_sel0, inv_sel1, inv_sel2, w_0, w_1, w_2, w_3, w_4;
  not i_0 (inv_sel0, sel0);
  not i_1 (inv_sel1, sel1);
  not i_2 (inv_sel2, sel2);
  and a_0 (w_0, inv_sel2, inv_sel1, inv_sel0, data0);
  and a_1 (w_1, inv_sel2, inv_sel1, sel0, data1);
  and a_2 (w_2, inv_sel2, sel1, inv_sel0, data2);
  and a_3 (w_3, inv_sel2, sel1, sel0, data3);
  and a_4 (w_4, sel2, inv_sel1, inv_sel0, data4);
  or org (z, w_0, w_1, w_2, w_3, w_4);
endmodule
`endif // ONE_HOT_MUX
`endif
