// Converted from VHDL: seq_detect.vhd
// Tool: Cadence Genus (vhdl2verilog.sh), 2026-11-25 08:00



module bmux(ctl, in_0, in_1, z);
  input ctl, in_0, in_1;
  output z;
  wire ctl, in_0, in_1;
  wire z;
  CDN_bmux2 g1(.sel0 (ctl), .data0 (in_0), .data1 (in_1), .z (z));
endmodule

module bmux_7(ctl, in_0, in_1, z);
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

module bmux_11(ctl, in_0, in_1, in_2, in_3, in_4, z);
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
  wire [2:0] next_state_41;
  wire [2:0] next_state_42;
  wire [2:0] next_state_43;
  wire [2:0] next_state_44;
  wire [2:0] state;
  wire [2:0] next_state_45;
  wire n_44, n_45, n_56, n_57, n_59;
  bmux mux_next_state_33_29(.ctl (din), .in_0 (1'b0), .in_1 (1'b1), .z
       (next_state[0]));
  bmux_7 mux_next_state_34_29(.ctl (n_44), .in_0 (2'b1), .in_1 (2'b10),
       .z (next_state_41[1:0]));
  bmux_7 mux_next_state_35_29(.ctl (din), .in_0 (2'b0), .in_1 (2'b11),
       .z (next_state_42[1:0]));
  bmux_7 mux_next_state_36_29(.ctl (din), .in_0 (2'b1), .in_1 (2'b10),
       .z (next_state_43[2:1]));
  bmux_7 mux_next_state_37_29(.ctl (din), .in_0 (2'b10), .in_1 (2'b1),
       .z (next_state_44[1:0]));
  bmux_11 mux_next_state_32_10(.ctl (state), .in_0 ({2'b0,
       next_state[0]}), .in_1 ({1'b0, next_state_41[1:0]}), .in_2
       ({1'b0, next_state_42[1:0]}), .in_3 ({next_state_43[2:1],
       1'b0}), .in_4 ({1'b0, next_state_44[1:0]}), .z (next_state_45));
  bmux mux_found_42_27(.ctl (n_45), .in_0 (1'b0), .in_1 (1'b1), .z
       (found));
  CDN_flop \state_reg[0] (.clk (clk), .d (next_state_45[0]), .sena
       (1'b1), .aclr (rst), .apre (1'b0), .srl (1'b0), .srd (1'b0), .q
       (state[0]));
  CDN_flop \state_reg[1] (.clk (clk), .d (next_state_45[1]), .sena
       (1'b1), .aclr (rst), .apre (1'b0), .srl (1'b0), .srd (1'b0), .q
       (state[1]));
  CDN_flop \state_reg[2] (.clk (clk), .d (next_state_45[2]), .sena
       (1'b1), .aclr (rst), .apre (1'b0), .srl (1'b0), .srd (1'b0), .q
       (state[2]));
  nand g11 (n_59, n_56, n_57, state[2]);
  not g12 (n_45, n_59);
  not g13 (n_44, din);
  not g14 (n_56, state[0]);
  not g15 (n_57, state[1]);
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
