# CBUG 2.3 EPROM MONITOR
### AV TOMMY BLADH OCH ÅKE HOLM
Monitor:
```
CBUG-2.3-F800.bin
CBUG-2.3-FC00.bin
```

## COMMANDS IN CBUG
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
* N stega nästa instruktion
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
