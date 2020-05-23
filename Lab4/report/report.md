# Lab4 实验报告

-   PB17111568
-   郭雨轩

## 阶段1

| BTB  | BHT  | REAL | NPC-PRED | flush | NPC-REAL | BTB-UPADTE |
| :--: | :--: | :--: | :------: | :---: | :------: | :--------: |
|  Y   |  Y   |  Y   |   BUF    |   N   |   BUF    |     N      |
|  Y   |  Y   |  N   |   BUF    |   Y   | PC-EX+4  |     N      |
|  Y   |  N   |  Y   | PC-IF+4  |   Y   |   BUF    |     N      |
|  Y   |  N   |  N   | PC-IF+4  |   N   | PC-EX+4  |     N      |
|  N   |  Y   |  Y   | PC-IF+4  |   Y   |  BrNPC   |     Y      |
|  N   |  Y   |  N   | PC-IF+4  |   N   | PC-EX+4  |     N      |
|  N   |  N   |  Y   | PC-IF+4  |   Y   |  BrNPC   |     Y      |
|  N   |  N   |  N   | PC-IF+4  |   N   | PC-EX+4  |     N      |

