# CBUG 4.3 EPROM MONITOR OCH TERMINALPROGRAM
### AV ÅKE HOLM 1983-01-04
### REV 3 831108


## COMMANDS IN CBUG 4.3
* @	Varmstart i FLEX 9.0
* B	Display Breakpoints
* C	Continue
* D	Dumpa i HEX och ASCII 16 bytes/rad
* E Extended instruktionssökning
* F Gå till Minidisk-Boot för Flex 9.0
* G Gå till programadress och exekvera
* H Beräkna checksumma AAAA-BBBB
* I Ändra registren på användarstacken
* J Gå till subrutin och skriv ut registren
* K Kopiera minnesinnehåll
* L Ladda FLEX 9.6 från EPROM (Not. Kan vara felskrivet, bör vara FLEX 9.0)
* M Minnesmanipulering
* O fyll ett visst minnesblock med en byte
* PL Ladda från promkort
* PH Beräkna checksumma på promkort
* PR Loop på promkort
* Q Mät RAM-storleken
* R Printa registren
* S Sök 2 bytes adress
* U Ta bort breakpoints
* V Sätt in breakpoints max 5 st
* W Minnestest
* Y Verifiering
* Z Dumpa i HEX och ASCII 16 bytes/rad på printern

~~
Källkoden finns i cbug43.src i 8-bitars ASCII, dvs, åäöÅÄÖ är 8-bitar tecken. För att få 7-bitar **måste** följande tecken ändras innan kompilering görs:  
å -> }, ä -> {, ö -> |, Å -> ], Ä -> [, Ö -> \ ~~  

Källkoden är nu i 7-bitars ASCII utan TAB-tecken.  
Den är också ändrad jämfört med listningen så alla ```0,X```, ```0,Y```, ```0,S``` och ```0,U``` är ändrade till ```,X```, ```,Y```, ```,S``` och ```,U``` för att kunna kompileras med A09.  
Detta påverkar inte ASMB  
Jag har också verifierat att den genererade .BIN-filen är bitkompatibel med koden från de dumpade eprommarna.

Kommandot för att kompilera cbug43.src med A09 till .BIN och .LST är:
```
./a09 cbug43.src -lcbug43.lst -bcbug43.bin -oTSC -oNOS -oNMU -oNUM
```
OBS: Tyvärr fungerar inte A09 med fill character och optionen
```
FILCHR  TEXT   $FF
```
En snabbfix finns här: [https://github.com/Arakula/A09/pull/14/files]

Om koden kompileras i FLEX ASMB:  
Kommandot: ```ASMB,cbug43.src,+SGN```
Den skarpögde kan notera att den genererade listan från ASMB på raderna 160, 1077 och 1888 har ett > tecken framför, detta är ASMB som markerar att man kan optimera koden.  
Saxat ur manualen FLEX Assembler:  
EXCESSIVE BRANCH OR JUMP INDICATOR  
A mechanism has been included in the assembler to inform the programmer  
when a long branch or jump could be replaced by a short branch. The  
purpose is to allow size and speed optimization of the final code. This  
indicator is a greater-than sign placed just before the address of the  
long branch or jump instruction which could be shortened.  
