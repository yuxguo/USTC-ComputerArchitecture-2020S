test_csr:
    li x4, 0x0c;            # x4 = 0x0c
    csrrw x0, 0, x4;        # csr[0] = 0x0c
    li x5, 0x0f;            # x5 = 0x0f
    csrrw x0, 1, x5;        # csr[1] = 0x0f
    csrrwi x0, 2, 0x18;     # csr[2] = 0x18
    li x6, 0x14;            # x6 = 0x14
    csrrc x7, 0, x6;        # x7 = 0x0c, csr[0] = 0x04
    csrrci x10, 1, 0x18;    # x10 = 0x0f, csr[1] = 0x08
    nop;
    csrrsi x11, 2, 0x04     # x11 = 0x18, csr[2] = 0x1c, 11000 | 00100 = 11100
    beq x4, x7, next_1;     
    j failed;
next_1:
    li x8, 0x04;            # x8 = 0x04
    csrrs x9, 0, x0;            # x9 = 0x04
    beq x8, x9, next_2;             
    j failed;
next_2:
    li x8, 0x08;            # x8 = 0x08
    csrrs x9, 1, x0;            # x9 = 0x08
    beq x8, x9, next_3;             
    j failed;
next_3:
    li x8, 0x1c;            # x8 = 0x1c
    csrrs x9, 2, x0;            # x9 = 0x1c
    beq x8, x9, success;             
    j failed;

success:
    li x3, 1;
    j success;

failed: 
    li x3, 0;
    j failed;
