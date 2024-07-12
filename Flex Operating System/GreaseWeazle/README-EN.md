# Flex Operating System
## How to read FLEX diskettes with GreaseWeazle
Download the following software and install:  
  
SWTPC 6808/6809 Emulator: http://www.evenson-consulting.com/swtpc/default.htm  
Go to Download / Upgrades and download the ZIP och EXE file Complete Setup  
  
HxC Floppy Emulator: https://hxc2001.com/download/floppy_drive_emulator  
Browse to Software and download the file HxCFloppyEmulator_soft.zip  
  
GreaseWeazle: https://github.com/keirf/greaseweazle/wiki  
Download Host Tools and install it.  
NOTE! You need a hardware device to be able to use GreaseWeazle 

flex.cfg: My configuration file.  

To read a FLEX diskette with GreaseWeazly, put the diskette you want to image in the drive, don't forget the write protection.  
Start by reading the diskette as a single sided, single density 35 track diskette:  
gw read --diskdefs flex.cfg --format flex.sssd.35 flex.img  
  
Open the image  withHcXFloppyEmulator, clock on Load Raw Image, Load Raw File, select the image file that you just created, clock on Track Analyzer.  
Hover the mouse over the third green field and type down the values for position $26 and $27, convert from HEX to decimal and you have the number of tracks and sectors for the diskette.  
If it differs from 35 track, single side single density re-read the diskette with the correct format.  

| Pos 26  | Pos 27      |     Type ofdiskett                      | Config för GW |
| ------- | ----------- | ----------------------------------------| ------------- |
|   $22   |   $0A (10)  | 35 track , Single Sided                 | flex.35.sssd  |
|   $22   |   $0A (18)  | 35 track , Single Sided, Double Density | flex.35.ssdd  |
|   $27   |   $0A (10)  | 40 track , Single Sided                 | flex.40.sssd  |
|   $27   |   $12 (18)  | 40 track , Single Sided, Double Density | flex.40.ssdd  |
|   $27   |   $14 (20)  | 40 track , Double Sided                 | flex.40.dssd  |
|   $27   |   $24 (36)  | 40 track , Double Sided, Double Density | flex.40.dsdd  |
|         |             |                                         |               |
|   $4F   |   $0A (10)  | 80 track , Single Sided                 |               |
|   $4F   |   $12 (18)  | 80 track , Single Sided, Double Density |               |
|   $4F   |   $14 (20)  | 80 track , Double Sided                 |               |
|   $4F   |   $24 (36)  | 80 track , Double Sided, Double Density | flex.80.dsdd  |

  
The table will be expanded and flex.cfg will be updated.  

Third sector contains System Information Record (SIR) with the following format:  

| offset(hex) | size(hex) | contents
| ----------- | --------- | ------------------------- |
|    $10      |    $0B    |  Volume Label             |
|    $1B      |    $01    |  Volume Number High byte  |
|    $1C      |    $01    |  Volume Number Low byte   |
|    $1D      |    $01    |  First User Track         |
|    $1E      |    $01    |  First User Sector        |
|    $1F      |    $01    |  Last User Track          |
|    $20      |    $01    |  Last User Sector         |
|    $21      |    $01    |  Total Sectors High byte  |
|    $22      |    $01    |  Total Sectors Low byte   |
|    $23      |    $01    |  Creation Month           |
|    $24      |    $01    |  Creation Day             |
|    $25      |    $01    |  Creation Year            |
|    $26      |    $01    |  Max Track                |
|    $27      |    $01    |  Max Sector               |

Position $26 and $27 contains the value for number of tracks and sectors, based on that you will get the correct type of diskette.  

NOTE!!  
If you have a running version of flex you can use the program DISKIDEN to get all information without GreaseWeazle.  