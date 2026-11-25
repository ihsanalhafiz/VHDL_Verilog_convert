// Converted from VHDL: counter.vhd
// Tool: Cadence Genus (vhdl2verilog.sh), 2026-11-25 08:00



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

module counter(clk, rst, en, count);
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
