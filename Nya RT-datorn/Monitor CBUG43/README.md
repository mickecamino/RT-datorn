# CBUG 4.3 EPROM MONITOR OCH TERMINALPROGRAM
### AV ÅKE HOLM 1983-01-04
### REV 3 831108


## COMMANDS IN CBUG 4.3
* É	Varmstart i FLEX 9.0
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

Källkoden finns i cbug43.src i 8-bitars ASCII, dvs, åäöÅÄÖ är 8-bitar tecken. För att få 7-bitar **måste** följande tecken ändras innan kompilering görs:  
å -> }, ä -> {, ö -> |, Å -> ], Ä -> [, Ö -> \

Rad 1917 till 1920 är ett bra exempel på varför detta ska göras.

Den kompilerade listan cbug43.lst är identisk med den listning på pyjamaspapper jag fått tag på.  
Den skarpögde kan notera att raderna 160, 1077 och 1888 har ett > tecken framför, detta är TSC-kompilatorn som markerar att man kan optimera koden.  
Saxat ur manualen FLEX Assembler:  
EXCESSIVE BRANCH OR JUMP INDICATOR  
A mechanism has been included in the assembler to inform the programmer  
when a long branch or jump could be replaced by a short branch. The  
purpose is to allow size and speed optimization of the final code. This  
indicator is a greater-than sign placed just before the address of the  
long branch or jump instruction which could be shortened.  
