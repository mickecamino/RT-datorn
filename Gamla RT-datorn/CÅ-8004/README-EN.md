# CA-8004
This peripheral board has a timer, MC6840 from Motorola, and two small amplifiers for sound output.  
The outputs 1-3 are used for generating sound.  
A code example, by Åke Holm, is supplied that plays a Mozart waltz, file name is univkort.asm.  
The timer IC contains three 16-bits counters that can be programmed quite differently.  
In the RT-computer it is used for printer spooling in FLEX 2.x or FLEX 9.x  
The print spooler uses a routine in FLEX called PRINT, the routine initializes the timer to generate a periodic interrupt, during the interrupt the spooler routine is run.  

Code examples are compiled with [A09](https://github.com/Arakula/A09) 