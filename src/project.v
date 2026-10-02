`default_nettype none

module tt_um_Dany_IEEE(
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);

  // ---------- VGA ----------
  wire hsync, vsync, display_on;
  wire [9:0] hpos, vpos;

  hvsync_generator hvsync_gen(
    .clk(clk), .reset(~rst_n),
    .hsync(hsync), .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos), .vpos(vpos)
  );

  // ---------- Contador de cuadros ----------
  reg [9:0] frame;
  always @(posedge vsync or negedge rst_n) begin
    if (!rst_n) frame <= 10'd0;
    else        frame <= frame + 10'd1;
  end

  // ---------- Fuente 5x7 ----------
  // 0=I 1=E 2=C 3=U 4=A 5=D 6=O 7=R 8=N 9=V 10=S 11=P 12=L 13=T 14=espacio
  function [4:0] glyph;
    input [3:0] ch;
    input [2:0] row;
    begin
      case ({ch, row})
        // I
        7'o000: glyph = 5'b01110; 7'o001: glyph = 5'b00100; 7'o002: glyph = 5'b00100;
        7'o003: glyph = 5'b00100; 7'o004: glyph = 5'b00100; 7'o005: glyph = 5'b00100;
        7'o006: glyph = 5'b01110;
        // E
        7'o010: glyph = 5'b11111; 7'o011: glyph = 5'b10000; 7'o012: glyph = 5'b10000;
        7'o013: glyph = 5'b11110; 7'o014: glyph = 5'b10000; 7'o015: glyph = 5'b10000;
        7'o016: glyph = 5'b11111;
        // C
        7'o020: glyph = 5'b01110; 7'o021: glyph = 5'b10001; 7'o022: glyph = 5'b10000;
        7'o023: glyph = 5'b10000; 7'o024: glyph = 5'b10000; 7'o025: glyph = 5'b10001;
        7'o026: glyph = 5'b01110;
        // U
        7'o030: glyph = 5'b10001; 7'o031: glyph = 5'b10001; 7'o032: glyph = 5'b10001;
        7'o033: glyph = 5'b10001; 7'o034: glyph = 5'b10001; 7'o035: glyph = 5'b10001;
        7'o036: glyph = 5'b01110;
        // A
        7'o040: glyph = 5'b01110; 7'o041: glyph = 5'b10001; 7'o042: glyph = 5'b10001;
        7'o043: glyph = 5'b11111; 7'o044: glyph = 5'b10001; 7'o045: glyph = 5'b10001;
        7'o046: glyph = 5'b10001;
        // D
        7'o050: glyph = 5'b11110; 7'o051: glyph = 5'b10001; 7'o052: glyph = 5'b10001;
        7'o053: glyph = 5'b10001; 7'o054: glyph = 5'b10001; 7'o055: glyph = 5'b10001;
        7'o056: glyph = 5'b11110;
        // O
        7'o060: glyph = 5'b01110; 7'o061: glyph = 5'b10001; 7'o062: glyph = 5'b10001;
        7'o063: glyph = 5'b10001; 7'o064: glyph = 5'b10001; 7'o065: glyph = 5'b10001;
        7'o066: glyph = 5'b01110;
        // R
        7'o070: glyph = 5'b11110; 7'o071: glyph = 5'b10001; 7'o072: glyph = 5'b10001;
        7'o073: glyph = 5'b11110; 7'o074: glyph = 5'b10100; 7'o075: glyph = 5'b10010;
        7'o076: glyph = 5'b10001;
        // N
        7'o100: glyph = 5'b10001; 7'o101: glyph = 5'b11001; 7'o102: glyph = 5'b10101;
        7'o103: glyph = 5'b10101; 7'o104: glyph = 5'b10011; 7'o105: glyph = 5'b10001;
        7'o106: glyph = 5'b10001;
        // V
        7'o110: glyph = 5'b10001; 7'o111: glyph = 5'b10001; 7'o112: glyph = 5'b10001;
        7'o113: glyph = 5'b10001; 7'o114: glyph = 5'b10001; 7'o115: glyph = 5'b01010;
        7'o116: glyph = 5'b00100;
        // S
        7'o120: glyph = 5'b01111; 7'o121: glyph = 5'b10000; 7'o122: glyph = 5'b10000;
        7'o123: glyph = 5'b01110; 7'o124: glyph = 5'b00001; 7'o125: glyph = 5'b00001;
        7'o126: glyph = 5'b11110;
        // P
        7'o130: glyph = 5'b11110; 7'o131: glyph = 5'b10001; 7'o132: glyph = 5'b10001;
        7'o133: glyph = 5'b11110; 7'o134: glyph = 5'b10000; 7'o135: glyph = 5'b10000;
        7'o136: glyph = 5'b10000;
        // L
        7'o140: glyph = 5'b10000; 7'o141: glyph = 5'b10000; 7'o142: glyph = 5'b10000;
        7'o143: glyph = 5'b10000; 7'o144: glyph = 5'b10000; 7'o145: glyph = 5'b10000;
        7'o146: glyph = 5'b11111;
        // T
        7'o150: glyph = 5'b11111; 7'o151: glyph = 5'b00100; 7'o152: glyph = 5'b00100;
        7'o153: glyph = 5'b00100; 7'o154: glyph = 5'b00100; 7'o155: glyph = 5'b00100;
        7'o156: glyph = 5'b00100;
        default: glyph = 5'b00000;
      endcase
    end
  endfunction

  // Letras de la segunda linea: E C U A D O R
  function [2:0] letter2;
    input [2:0] i;
    begin
      case (i)
        3'd0: letter2 = 3'd1;
        3'd1: letter2 = 3'd2;
        3'd2: letter2 = 3'd3;
        3'd3: letter2 = 3'd4;
        3'd4: letter2 = 3'd5;
        3'd5: letter2 = 3'd6;
        default: letter2 = 3'd7;
      endcase
    end
  endfunction

  // Texto de la tercera linea: UNIVERSIDAD POLITECNICA SALESIANA (33 caracteres)
  function [3:0] letter3;
    input [5:0] i;
    begin
      case (i)
        6'd0:  letter3 = 4'd3;   // U
        6'd1:  letter3 = 4'd8;   // N
        6'd2:  letter3 = 4'd0;   // I
        6'd3:  letter3 = 4'd9;   // V
        6'd4:  letter3 = 4'd1;   // E
        6'd5:  letter3 = 4'd7;   // R
        6'd6:  letter3 = 4'd10;  // S
        6'd7:  letter3 = 4'd0;   // I
        6'd8:  letter3 = 4'd5;   // D
        6'd9:  letter3 = 4'd4;   // A
        6'd10: letter3 = 4'd5;   // D
        6'd11: letter3 = 4'd14;  // espacio
        6'd12: letter3 = 4'd11;  // P
        6'd13: letter3 = 4'd6;   // O
        6'd14: letter3 = 4'd12;  // L
        6'd15: letter3 = 4'd0;   // I
        6'd16: letter3 = 4'd13;  // T
        6'd17: letter3 = 4'd1;   // E
        6'd18: letter3 = 4'd2;   // C
        6'd19: letter3 = 4'd8;   // N
        6'd20: letter3 = 4'd0;   // I
        6'd21: letter3 = 4'd2;   // C
        6'd22: letter3 = 4'd4;   // A
        6'd23: letter3 = 4'd14;  // espacio
        6'd24: letter3 = 4'd10;  // S
        6'd25: letter3 = 4'd4;   // A
        6'd26: letter3 = 4'd12;  // L
        6'd27: letter3 = 4'd1;   // E
        6'd28: letter3 = 4'd10;  // S
        6'd29: letter3 = 4'd0;   // I
        6'd30: letter3 = 4'd4;   // A
        6'd31: letter3 = 4'd8;   // N
        6'd32: letter3 = 4'd4;   // A
        default: letter3 = 4'd14;
      endcase
    end
  endfunction

  // ---------- Linea 1: "IEEE" (escala 16) ----------
  wire in1 = (hpos >= 10'd128) && (hpos < 10'd512) &&
             (vpos >= 10'd100) && (vpos < 10'd212);
  wire [9:0] lx1 = hpos - 10'd128;
  wire [9:0] ly1 = vpos - 10'd100;
  wire [5:0] fx1 = lx1[9:4];
  wire [5:0] ci1 = fx1 / 6'd6;
  wire [5:0] cc1 = fx1 % 6'd6;
  wire [2:0] col1 = cc1[2:0];
  wire [2:0] fy1  = ly1[6:4];
  wire [3:0] code1 = (ci1 == 6'd0) ? 4'd0 : 4'd1;
  wire [4:0] g1  = glyph(code1, fy1);
  wire [4:0] sh1 = g1 << col1;
  wire pix1 = in1 && (col1 < 3'd5) && sh1[4];

  // ---------- Linea 2: "ECUADOR" (escala 8) ----------
  wire in2 = (hpos >= 10'd152) && (hpos < 10'd488) &&
             (vpos >= 10'd260) && (vpos < 10'd316);
  wire [9:0] lx2 = hpos - 10'd152;
  wire [9:0] ly2 = vpos - 10'd260;
  wire [6:0] fx2 = lx2[9:3];
  wire [6:0] ci2 = fx2 / 7'd6;
  wire [6:0] cc2 = fx2 % 7'd6;
  wire [2:0] col2 = cc2[2:0];
  wire [2:0] fy2  = ly2[5:3];
  wire [2:0] code2 = letter2(ci2[2:0]);
  wire [4:0] g2  = glyph({1'b0, code2}, fy2);
  wire [4:0] sh2 = g2 << col2;
  wire show2 = (ci2 < {3'b000, frame[6:3]});
  wire pix2 = in2 && (col2 < 3'd5) && sh2[4] && show2;

  // ---------- Linea 3: "UNIVERSIDAD POLITECNICA SALESIANA" (escala 3) ----------
  wire in3 = (hpos >= 10'd23) && (hpos < 10'd617) &&
             (vpos >= 10'd420) && (vpos < 10'd441);
  wire [9:0] lx3 = hpos - 10'd23;
  wire [9:0] ly3 = vpos - 10'd420;
  wire [7:0] fx3 = lx3 / 10'd3;
  wire [5:0] ci3 = fx3 / 8'd6;
  wire [7:0] cc3 = fx3 % 8'd6;
  wire [2:0] col3 = cc3[2:0];
  wire [9:0] fy3w = ly3 / 10'd3;
  wire [2:0] fy3  = fy3w[2:0];
  wire [3:0] code3 = letter3(ci3);
  wire [4:0] g3  = glyph(code3, fy3);
  wire [4:0] sh3 = g3 << col3;
  // Aparece letra por letra de izquierda a derecha
  wire show3 = (ci3 < frame[8:3]);
  wire pix3 = in3 && (col3 < 3'd5) && sh3[4] && show3;

  // ---------- Brillo que barre la pantalla ----------
  wire [9:0] sw   = {frame[6:0], 3'b000};
  wire [9:0] diff = hpos + 10'd96 - sw;
  wire glint = (diff < 10'd32);

  // ---------- Franja bandera de Ecuador ----------
  wire band_x = (hpos >= 10'd128) && (hpos < 10'd512);
  wire band_y = band_x && (vpos >= 10'd360) && (vpos < 10'd376);
  wire band_b = band_x && (vpos >= 10'd376) && (vpos < 10'd388);
  wire band_r = band_x && (vpos >= 10'd388) && (vpos < 10'd400);

  // Linea separadora
  wire sep = (hpos >= 10'd128) && (hpos < 10'd512) &&
             (vpos >= 10'd228) && (vpos < 10'd232);

  // ---------- Colores (2 bits por canal) ----------
  reg [1:0] R, G, B;
  always @* begin
    R = 2'b00; G = 2'b00;
    B = frame[7] ? 2'b01 : 2'b10;
    if (frame[7] == 1'b0 && frame[6] == 1'b0) B = 2'b01;

    if (sep) begin
      R = 2'b00; G = frame[4] ? 2'b10 : 2'b11; B = 2'b11;
    end

    if (pix1) begin
      case (frame[6:5])
        2'd0: begin R = 2'b01; G = 2'b11; B = 2'b11; end
        2'd1: begin R = 2'b10; G = 2'b11; B = 2'b11; end
        2'd2: begin R = 2'b00; G = 2'b11; B = 2'b11; end
        default: begin R = 2'b01; G = 2'b10; B = 2'b11; end
      endcase
      if (glint) begin R = 2'b11; G = 2'b11; B = 2'b11; end
    end

    if (pix2) begin
      R = 2'b11; G = 2'b11; B = 2'b00;
      if (glint) begin R = 2'b11; G = 2'b11; B = 2'b11; end
    end

    if (band_y) begin R = 2'b11; G = 2'b11; B = 2'b00; end
    if (band_b) begin R = 2'b00; G = 2'b01; B = 2'b11; end
    if (band_r) begin R = 2'b11; G = 2'b00; B = 2'b00; end
    if ((band_y || band_b || band_r) && glint) begin
      R = 2'b11; G = 2'b11; B = 2'b11;
    end

    // Universidad: blanco, cian cuando pasa el brillo
    if (pix3) begin
      R = 2'b11; G = 2'b11; B = 2'b11;
      if (glint) begin R = 2'b00; G = 2'b11; B = 2'b11; end
    end

    if (!display_on) begin R = 2'b00; G = 2'b00; B = 2'b00; end
  end

  // ---------- Salidas ----------
  assign uo_out  = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
  assign uio_out = 8'h00;
  assign uio_oe  = 8'h00;

  wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
