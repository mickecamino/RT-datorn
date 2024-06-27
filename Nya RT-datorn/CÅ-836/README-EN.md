# CÅ-836 - EPROM board with RAM
A newly designed board for the RT-computer done by me.  
There are sockets for up to three EPROM's 27512, totaling of 192 kb permament storage for FLEX 9.1 and utilities. The addressing of the EPROM's are $E0B0, $E0C0 and $E0D0.  
The RAM is used for expanding the FLEX command table and the loader routine. See the listing for PROM.ASM and PROMDIR.ASM.  
Storing FLEX utilities, FLEX Editor, BASIC, DEBUG etc is rather simple, just store the CMD-file onto the EPROM, removing padding after the last entry $16, $xx, $yy. See the PROM.ASM for more info.  
