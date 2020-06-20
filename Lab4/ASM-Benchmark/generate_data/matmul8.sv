
module mem #(                   // 
    parameter  ADDR_LEN  = 11   // 
) (
    input  clk, rst,
    input  [ADDR_LEN-1:0] addr, // memory address
    output reg [31:0] rd_data,  // data read out
    input  wr_req,
    input  [31:0] wr_data       // data write in
);
localparam MEM_SIZE = 1<<ADDR_LEN;
reg [31:0] ram_cell [MEM_SIZE];

always @ (posedge clk or posedge rst)
    if(rst)
        rd_data <= 0;
    else
        rd_data <= ram_cell[addr];

always @ (posedge clk)
    if(wr_req) 
        ram_cell[addr] <= wr_data;

initial begin
    // dst matrix C
    ram_cell[       0] = 32'h0;  // 32'hcd957504;
    ram_cell[       1] = 32'h0;  // 32'heb3866ba;
    ram_cell[       2] = 32'h0;  // 32'h76dcffde;
    ram_cell[       3] = 32'h0;  // 32'h27d82386;
    ram_cell[       4] = 32'h0;  // 32'hdab8cc6d;
    ram_cell[       5] = 32'h0;  // 32'h441c275b;
    ram_cell[       6] = 32'h0;  // 32'h569c05b3;
    ram_cell[       7] = 32'h0;  // 32'h292f0151;
    ram_cell[       8] = 32'h0;  // 32'h4ef46ac7;
    ram_cell[       9] = 32'h0;  // 32'ha283d522;
    ram_cell[      10] = 32'h0;  // 32'h3b979d4b;
    ram_cell[      11] = 32'h0;  // 32'h5f4c1e21;
    ram_cell[      12] = 32'h0;  // 32'hd1ad6a42;
    ram_cell[      13] = 32'h0;  // 32'hb1eddcf2;
    ram_cell[      14] = 32'h0;  // 32'h5d95dea3;
    ram_cell[      15] = 32'h0;  // 32'h36157844;
    ram_cell[      16] = 32'h0;  // 32'h203f7e3f;
    ram_cell[      17] = 32'h0;  // 32'hfda2b6eb;
    ram_cell[      18] = 32'h0;  // 32'h9dd2a281;
    ram_cell[      19] = 32'h0;  // 32'h8b66fbc1;
    ram_cell[      20] = 32'h0;  // 32'h6c525891;
    ram_cell[      21] = 32'h0;  // 32'hff221100;
    ram_cell[      22] = 32'h0;  // 32'h2a1278a2;
    ram_cell[      23] = 32'h0;  // 32'hfc8ded60;
    ram_cell[      24] = 32'h0;  // 32'he7431ca8;
    ram_cell[      25] = 32'h0;  // 32'h48bdbb72;
    ram_cell[      26] = 32'h0;  // 32'ha082fe3c;
    ram_cell[      27] = 32'h0;  // 32'habacd2b6;
    ram_cell[      28] = 32'h0;  // 32'h6e10651b;
    ram_cell[      29] = 32'h0;  // 32'hfd26bc6f;
    ram_cell[      30] = 32'h0;  // 32'h2835d435;
    ram_cell[      31] = 32'h0;  // 32'hce4bf655;
    ram_cell[      32] = 32'h0;  // 32'hdb7839c0;
    ram_cell[      33] = 32'h0;  // 32'h075f37f9;
    ram_cell[      34] = 32'h0;  // 32'h831881c3;
    ram_cell[      35] = 32'h0;  // 32'h7cd596d5;
    ram_cell[      36] = 32'h0;  // 32'hf521958c;
    ram_cell[      37] = 32'h0;  // 32'h2930e2fd;
    ram_cell[      38] = 32'h0;  // 32'hb7f45c7d;
    ram_cell[      39] = 32'h0;  // 32'h8b9d1d33;
    ram_cell[      40] = 32'h0;  // 32'h57d3a726;
    ram_cell[      41] = 32'h0;  // 32'h5643cf85;
    ram_cell[      42] = 32'h0;  // 32'h06427c8a;
    ram_cell[      43] = 32'h0;  // 32'h0fdb043f;
    ram_cell[      44] = 32'h0;  // 32'he5fd4c2d;
    ram_cell[      45] = 32'h0;  // 32'hdf0b22b4;
    ram_cell[      46] = 32'h0;  // 32'hf06799d0;
    ram_cell[      47] = 32'h0;  // 32'h763de194;
    ram_cell[      48] = 32'h0;  // 32'h37ac9b25;
    ram_cell[      49] = 32'h0;  // 32'h68f122ed;
    ram_cell[      50] = 32'h0;  // 32'hc1594bde;
    ram_cell[      51] = 32'h0;  // 32'h5e23e992;
    ram_cell[      52] = 32'h0;  // 32'h5b65da27;
    ram_cell[      53] = 32'h0;  // 32'haf8dd445;
    ram_cell[      54] = 32'h0;  // 32'hd0cd9642;
    ram_cell[      55] = 32'h0;  // 32'h47caf34c;
    ram_cell[      56] = 32'h0;  // 32'h400e2ef7;
    ram_cell[      57] = 32'h0;  // 32'h47bf0633;
    ram_cell[      58] = 32'h0;  // 32'h2680474f;
    ram_cell[      59] = 32'h0;  // 32'h45505380;
    ram_cell[      60] = 32'h0;  // 32'h08b275fb;
    ram_cell[      61] = 32'h0;  // 32'h79231db7;
    ram_cell[      62] = 32'h0;  // 32'h1ea1db13;
    ram_cell[      63] = 32'h0;  // 32'hd1663908;
    // src matrix A
    ram_cell[      64] = 32'hf707c8d0;
    ram_cell[      65] = 32'h2b370193;
    ram_cell[      66] = 32'hff228158;
    ram_cell[      67] = 32'hd0d369a4;
    ram_cell[      68] = 32'h92ad5d32;
    ram_cell[      69] = 32'h96f65dc7;
    ram_cell[      70] = 32'hba714ae2;
    ram_cell[      71] = 32'hbb3d6c6c;
    ram_cell[      72] = 32'hb0bd0d42;
    ram_cell[      73] = 32'h942be54a;
    ram_cell[      74] = 32'hd724abe2;
    ram_cell[      75] = 32'hf7678714;
    ram_cell[      76] = 32'h6296489b;
    ram_cell[      77] = 32'h82566341;
    ram_cell[      78] = 32'hc941504b;
    ram_cell[      79] = 32'h37e19d94;
    ram_cell[      80] = 32'hf54ea1d3;
    ram_cell[      81] = 32'he3aabac2;
    ram_cell[      82] = 32'h00624645;
    ram_cell[      83] = 32'h1360d1d5;
    ram_cell[      84] = 32'he971ff26;
    ram_cell[      85] = 32'h14ea96f2;
    ram_cell[      86] = 32'h3dae8401;
    ram_cell[      87] = 32'h7466a046;
    ram_cell[      88] = 32'h0cd34dfd;
    ram_cell[      89] = 32'hee49b595;
    ram_cell[      90] = 32'h47e63200;
    ram_cell[      91] = 32'h3abaaed6;
    ram_cell[      92] = 32'ha24601ed;
    ram_cell[      93] = 32'hb415f423;
    ram_cell[      94] = 32'h2396cc2d;
    ram_cell[      95] = 32'hb56b0d6d;
    ram_cell[      96] = 32'h71d1cda1;
    ram_cell[      97] = 32'h0fe3d03e;
    ram_cell[      98] = 32'haa33cc4b;
    ram_cell[      99] = 32'h34badf1b;
    ram_cell[     100] = 32'h848d9fd6;
    ram_cell[     101] = 32'h6599e90a;
    ram_cell[     102] = 32'hf6472b14;
    ram_cell[     103] = 32'hbc1b5aef;
    ram_cell[     104] = 32'h228e5893;
    ram_cell[     105] = 32'h7d3752ef;
    ram_cell[     106] = 32'h9768d838;
    ram_cell[     107] = 32'h546c4019;
    ram_cell[     108] = 32'h8581ef8e;
    ram_cell[     109] = 32'h64aa8f52;
    ram_cell[     110] = 32'he9752222;
    ram_cell[     111] = 32'h4129a6b2;
    ram_cell[     112] = 32'hafd2e090;
    ram_cell[     113] = 32'hd0c083d9;
    ram_cell[     114] = 32'hc7476026;
    ram_cell[     115] = 32'h17684990;
    ram_cell[     116] = 32'h87ec9021;
    ram_cell[     117] = 32'h41c49333;
    ram_cell[     118] = 32'hfec9e448;
    ram_cell[     119] = 32'h7fcc4530;
    ram_cell[     120] = 32'hc6e2d1d0;
    ram_cell[     121] = 32'hf0e199fe;
    ram_cell[     122] = 32'h62f75742;
    ram_cell[     123] = 32'h0ab0e116;
    ram_cell[     124] = 32'hdd413d27;
    ram_cell[     125] = 32'hcc560bde;
    ram_cell[     126] = 32'h6c303469;
    ram_cell[     127] = 32'hc1ee93b6;
    // src matrix B
    ram_cell[     128] = 32'hda71c0b6;
    ram_cell[     129] = 32'h99caea7f;
    ram_cell[     130] = 32'hb2843596;
    ram_cell[     131] = 32'h575ce41c;
    ram_cell[     132] = 32'h89bbf3d3;
    ram_cell[     133] = 32'h0c807d6b;
    ram_cell[     134] = 32'h33e8ff58;
    ram_cell[     135] = 32'h2dc40e50;
    ram_cell[     136] = 32'h1ff115ae;
    ram_cell[     137] = 32'h3cd5a3dd;
    ram_cell[     138] = 32'h390582c8;
    ram_cell[     139] = 32'h2f4d2515;
    ram_cell[     140] = 32'hc81ed68c;
    ram_cell[     141] = 32'ha52253e6;
    ram_cell[     142] = 32'h6a813be7;
    ram_cell[     143] = 32'h2e7abc7d;
    ram_cell[     144] = 32'h7eda14a5;
    ram_cell[     145] = 32'ha2c05539;
    ram_cell[     146] = 32'h4daa12fc;
    ram_cell[     147] = 32'h5949121f;
    ram_cell[     148] = 32'he0c2f3dd;
    ram_cell[     149] = 32'h4a700d93;
    ram_cell[     150] = 32'h0667834f;
    ram_cell[     151] = 32'hbb54d6b0;
    ram_cell[     152] = 32'h090bb082;
    ram_cell[     153] = 32'hf991bc9d;
    ram_cell[     154] = 32'h1f459578;
    ram_cell[     155] = 32'h04707a7a;
    ram_cell[     156] = 32'h92a5228a;
    ram_cell[     157] = 32'hb3bbfc7b;
    ram_cell[     158] = 32'h1bca824d;
    ram_cell[     159] = 32'hfcdef3a5;
    ram_cell[     160] = 32'hf947c2b7;
    ram_cell[     161] = 32'hc57b1c71;
    ram_cell[     162] = 32'h9d14d48a;
    ram_cell[     163] = 32'hcda34504;
    ram_cell[     164] = 32'hd8204d38;
    ram_cell[     165] = 32'h0777e22c;
    ram_cell[     166] = 32'h223c68d5;
    ram_cell[     167] = 32'h62b6ed53;
    ram_cell[     168] = 32'hd93f1348;
    ram_cell[     169] = 32'h320682e3;
    ram_cell[     170] = 32'h071f9e5e;
    ram_cell[     171] = 32'hcfc36c57;
    ram_cell[     172] = 32'h968b355f;
    ram_cell[     173] = 32'ha8d8a787;
    ram_cell[     174] = 32'h74f9520a;
    ram_cell[     175] = 32'h5024f94e;
    ram_cell[     176] = 32'h61af15d8;
    ram_cell[     177] = 32'h6740bb02;
    ram_cell[     178] = 32'h184b40c3;
    ram_cell[     179] = 32'h169dd9fa;
    ram_cell[     180] = 32'h8a6e03cf;
    ram_cell[     181] = 32'h903422d3;
    ram_cell[     182] = 32'he96fb26e;
    ram_cell[     183] = 32'h1058b9f5;
    ram_cell[     184] = 32'h3283d141;
    ram_cell[     185] = 32'h4fa2cc58;
    ram_cell[     186] = 32'h94574f4f;
    ram_cell[     187] = 32'h330b2286;
    ram_cell[     188] = 32'h349b959e;
    ram_cell[     189] = 32'h35a1bd92;
    ram_cell[     190] = 32'h27f83221;
    ram_cell[     191] = 32'h2f4d6a86;
end

endmodule

