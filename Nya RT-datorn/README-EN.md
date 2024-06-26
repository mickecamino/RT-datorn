# The New RT-computer
## A 6809 computer designed by Åke Holm (CÅ-Elektronik) during the 1980's. It was featured in the magazine Radio & Television, hence the name RT-computer.
### With permission by Åke Holm to publish all details about the RT-computer

## The following boards were made for the "new" RT-computer:

* CÅ-812 - CPU-board  
The CPU-board featured static RAM addressed at $C000 - DFFF.  
Two sockets for EPROM's addressed at $F000 to FFFF. The CPU-board handles the decoding for the peripheral boards located at address $E000 - $E0FF. An extra RAM is addressed between $E100 and $E3FF to be used for the monitor and terminal software without interfering with the operating system FLEX 9.1.  

* CÅ-813 - I/O  
The new board for serial communication is called CÅ-813 and it replaces the older boards 8001, 8014 and 8015.  
It features a programmable serial communication IC for V24, a printer connection with parallel interface (Centronics) and a Real Time Clock with battery backup.  
The connection for printer and serial is via a 60-pin connector. 36 pins for the printer and 24 for the serial interface.  
See also CÅ-833

* CÅ-814 - memory board  
The memory board 814 replaces CÅ-6848. It is identical with one exception, the refresh for the dynamic memory chips is made continuously, instead as before, with 32 kHz. The memory size is 48 kB.  
Sea also CÅ-834

* CÅ-815 - Video terminal
The terminal is a completely new design. It is a memory mapped terminal, 24 lines and 80 columns. The board features the Motorola MC6845, display memory and a PIA for connecting the keyboard via a 26-pin connector. The pin out for the keyboard is identical with the CÅ-790. The display memory is located between $E800 and $EFFF, the CPU on board 812 is responsible for all terminal functions. All characters between computer and terminal is done without serial communication. The speed is much faster due to this. The character setup in the terminal is Swedish. 

* CÅ-816 - EPROM-board  
The new EPROM-board is called 816 and has 16 EPROM-sockets for 2532 EPROM's, each EPROM contains 4 kb. A total of 64 kb permanent memory is possible.. 
The board can hold for example the operating system FLEX and a BASIC interpreter. The addressing of the EPROM board is done via one single address. With a small software routine, loading from the boards EPROM to computer RAM is really simple.  
The board replaces the 8025-board.  
Se also CÅ-836  

* CÅ-817 - Floppy Controller  
The driver IC's for floppy drives on board 817 is equal to the board 8017. Up to four floppy drives, either single or double sided, single density can be connected.  
See also CÅ-837.  

* CÅ-831 - Terminal board - simple  
The simple hexadecimal terminal 8006 is replaced by 831, almost identical except that 831 also have a PIA for lab use.  

* CÅ-833 - I/O  
A newer design that replaces CÅ-813.  
Serial communication is done with 6850, a parallel printer output (Centronics) and a Real Time Clock with battery backup.  

* CÅ-834 - memory board  
New memory board for static memory, 6116 2k or EPROM 2716. Replaced CÅ-814.  

* CÅ-836 - 192 kb EPROM-board with 1 kb RAM.  
A new board for the RT-computer, designed by me. Three 27512 EPROM's gives 192 kb resident program memory in the computer, 1 kb RAM addressed at $E400-E7FF for a command table used by FLEX.   
With a small program, re-written by me based on a program from the magazine MPU-laren 1983-2, creates a command table for FLEX to load utilities from EPROM instead of floppy drives.  
FLEX can also be stored on this card and loaded from a new X command in CBUG. NOTE! Requires the updated CBUG4.4.  

* CÅ-837 - Floppy Controller with support for Double Density  
Replaces CÅ-817


### Memory mapping
```
Adres Function             board
$FFFF ----------------------------
      2k EPROM             CPU 812
$F800 ----------------------------
      2k EPROM             CPU 812
$F000 ----------------------------
      2k terminal   RAM    CRT 815
$E800 ----------------------------
      1k RAM                   836
$E400 ----------------------------
      768 bytes RAM        CRT 812
$E100 ----------------------------
      CRTC + PIA           CRT 815
$E0F0 ----------------------------
      spare
$E0DF ----------------------------
      EPROM #3             816/836
$E0D0 ----------------------------
      EPROM #2             816/836
$E0C0 ----------------------------
      EPROM-board #1       816/836
$E0B0 ----------------------------
      spare
$E01F ----------------------------
      Floppy Controller    817/837
$E010 ---------------------------
      I/O                  813/833
$E000 ----------------------------
      8k static RAM        CPU 812
$C000 ----------------------------
      48k dynamic RAM      814/834
$0000 ----------------------------
```