# TBUG 2C EPROM MONITOR
### AV TOMMY BLADH OCH ÅKE HOLM
Monitors:
6800 - TBUG 2C
```
TBUG-2C-E400.bin
TBUG-2C-EC00.bin
```

## COMMANDS IN TBUG 2C
* @	Varmstart i FLEX 2.0
* B	Display Breakpoints
* C	Continue
* D	Dumpa i HEX och ASCII 8 bytes/rad
* E Extended instruktionssökning
* F Gå till Minidisk-Boot
* G Gå till programadress och exekvera
* H Beräkna checksumma AAAA-BBBB
* I
* J Gå till subrutin och skriv ut registren
* K Kopiera minnesinnehåll
* L Ladda minnet i S1-format med ev. offset
* M Minnesmanipulering
*   '-' ger föregående minnesposition
*   '.' ger nästa minnesposition
*   OAAAA offsetberäkning
* O fyll ett visst minnesblock med en byte
* P Punch i S1-format med rubrik
* Q Mät RAM-storleken
* R Printa registren
* S Sök 2 bytes adress
* T
* U Ta bort breakpoints
* V Sätt in breakpoints max 5 st
* W Minnestest
* X Exchange AA NNNN mot AA MMMM
* Y Verifiering
* Z Dumpa i HEX och ASCII 16 bytes/rad

Kommandot för att kompilera tbug2c.asm med A09 till .BIN och .LST är:
```
./a09 tbug2c.asm -ltbug2c.lst -btbug2c.bin -oTSC -oNOS -oNMU -oNUM -oM08
```

Om koden kompileras i FLEX ASMB:  
Kommandot: ```ASMB,tbug2c.asm,+SGN```
