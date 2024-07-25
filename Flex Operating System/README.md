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
Tryck Reset, och boota flex med F  
Du ska nu få en prompt med fråga om datum. Mata in dagens datum med mellanslag mellan månad, dag och år, t.ex 03 11 24, tryck Enter.  
Du ska nu få upp +++  

Om du använder den "gamla" RT-datorn, eller den "nya" med CÅ-817 är du klar och kan köra FLEX 9.1  
Om du använder den "nya" RT-datorn med CÅ-837 (Double Density Floppy Controller) måste du knappa in DISK.ASM och kompilera med följande kommando:  
```
ASMB DISK.ASM +LSGY  
```
Svara Yes på att skriva över den gamla DISK.BIN.  
Repetera ovanstående APPEND och LINK för att lägga till denna drivrutin till FLEX. Boota om och du har en FLEX som stöder enkel eller dubbelsidiga disketter och enkel eller dubbel densitetr, 35, 40 eller 80 spår.  
I mappen Utilities har jag samlat lite olika program som är "bra att ha".