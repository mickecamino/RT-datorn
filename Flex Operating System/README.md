# Flex Operating System
## Drivrutiner och annat för att kunna starta RT-datorn
RT-datorn, både den gamla (i 6809 läge) och den nya, ska köra Flex 9.1.  
Då original Flex 9.1 kör I/O via serieporten på adress $E004/$E005 fungerar detta inte på RT-datorn.  
En Quick-And-Dirty lösning är att boota Flex 9.1, vänta tills diskettstationen slocknat + 5 sekunder.  
Tryck sedan Reset för att komma in i CBUG-monitor.  
Tryck D för att dumpa minne, skriv D3E0 D3FF och se om det står $E005 och $E004 i någon adress.  
Kör M och modifiera adresserna till $E009 och $E008.  
Skriv G CD00 och du ska få +++ på skärmen.  

Nu kan du mata in IO.ASM i en texteditor och assemblera den med följande rad:  
```
ASMB IO.ASM +LSGY  
```
Du ska nu spara ner drivrutinen för diskettkontrollern med följande kommando:  
```
SAVE DISK,DE00,DFFF  
```
Skapa ny Flex för RT-datorn:  
```
APPEND FLEX.COR,DISK.BIN,IO.BIN,RTFLEX.SYS  
LINK RTFLEX.SYS 
```
Tryck Reset, och boot flex med F
Du ska nu få en prompt med fråga om datum. Mata in dagens datum med mellanslag mellan månad, dag och år, t.ex 03 11 24, tryck Enter.
Du ska nu få upp +++

