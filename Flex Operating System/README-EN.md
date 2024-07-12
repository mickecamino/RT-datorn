# Flex Operating System
## IO and DISK drivers for RT-datorn
RT-datorn, the "old" one (running 6809) and the "new" one, can run FLEX 9.1 and 3.01.  
Original FLEX 9.1 and 3.01 uses the serial port at address $E004/$E005. This will not work with RT-datorn.  
A Quick-And-Dirty solution is to boot FLEX 9.1 or 3.01 then wait until the disk drive has stopped loading.  
Then press Reset to go to CBUG-monitor.  
Press D for dumping memory, enter D3E0 D3FF and look for $E005 and $E004.  
Press M and modify these addresses and enter $E009 and $E008 to replace $E005 and $E004.  
Press G CD00 and you will get +++ on the screen.  

You can now type in IO.ASM in the editor and assemble it with this command:  
```
ASMB IO.ASM +LSGY  
```
Now save the disk driver with the following command:  
```
SAVE DISK,DE00,DFFF  
```
Create a new FLEX for RT-datorn:  
```
APPEND FLEX.COR,DISK.BIN,IO.BIN,RTFLEX.SYS  
LINK RTFLEX.SYS 
```
Press Reset, and boot with F.  
If all goes well you will get a prompt asking for the date. Enter it with a space character between Month, Year and Day, i.e. 03 11 24, press Enter.  
You will get the FLEX prompt +++  

If you are using the "old" RT-datorn, or the "new" with CÅ-817 you are all set.  
If you are using the "new" RT-datorn with CÅ-837 (Double Density Floppy Controller) you need to enter DISK.ASM and compile it with this command:  
```
ASMB DISK.ASM +LSGY  
```
Answer Yes to overwrite the old DISK.BIN.  
Repeat the above to append the new disk driver to FLEX. Reboot and you have a FLEX that support Single and Double Sided disk, with Single or Double Density and 35, 40 or 80 tracks.  

In the folder Utilities I have gathered some program that are "nice to have".  