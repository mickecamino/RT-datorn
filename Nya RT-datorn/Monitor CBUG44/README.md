# CBUG 4.4 EPROM MONITOR OCH TERMINALPROGRAM
### AV ÅKE HOLM 1983-01-04 och Mikael Karlsson 2024-05-08
### REV 4 2024-05-08
Se nedan för vad som är ändrat  

## COMMANDS IN CBUG 4.4
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
* L Ladda FLEX 9.x från EPROM
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
* X Ladda FLEX 9.1 från kort 836
* Y Verifiering
* Z Dumpa i HEX och ASCII 16 bytes/rad på printern

Källkoden är nu i 7-bitars ASCII utan TAB-tecken.  
Den är också ändrad jämfört med listningen så alla ```0,X```, ```0,Y```, ```0,S``` och ```0,U``` är ändrade till ```,X```, ```,Y```, ```,S``` och ```,U``` för att kunna kompileras med A09.  
Detta påverkar inte ASMB  
Jag har också verifierat att den genererade .BIN-filen är bitkompatibel med koden från de dumpade eprommarna.

Kommandot för att kompilera cbug43.src med A09 till .BIN och .LST är:
```
./a09 cbug44.src -lcbug44.lst -bcbug44.bin -oTSC -oNOS -oNMU -oNUM
```
OBS: Tyvärr fungerar inte A09 med fill character och optionen
```
FILCHR  TEXT   $FF
```
En snabbfix finns här: [https://github.com/Arakula/A09/pull/14/files]

Om koden kompileras i FLEX ASMB:  
Kommandot: ```ASMB,cbug44.src,+SGN```

## Ändringa gjorda i CBUG 4.4
För att ladda FLEX 9.1 från kort 836 har en FLEX Loader lagts till i CBUG'en. Denna loader hämtar FLEX 9.1 från position $0000 på kort 836. Loadern är i stort sett samma loader som finns på FLEX floppy.
Koden:
```
* LADDRUTIN F\R FLEX 9.1
*
* BEGA OCH ENDA ]R BEFINTLIGA CBUG MINNESVARIABLER
* EPROM0 ]R DEFINIERAD I CBUG TILL $E0B0
*
LDFLX   EQU     *
*
        LDX     #$0000    START OF PROM IN C[-836
*
LOAD2   BSR     LESPRM    H[MTA 1 BYTE, L[GG I A
        CMPA    #$02      [R DET 02? DVS. START OF RECORD?
        BEQ     LESREC    JA; L[S D] IN RECORDET OCH DATA
        CMPA    #$16      [R DET TRANSFER ADRESS?
        BNE     LOAD2     HOPPA \VER 00 PADDING
        BSR     LESPRM    H[MTA TRANSFER-ADRESSEN MSB
        STA     BEGA      SPARA MSB
        BSR     LESPRM    H[MTA TRANSFER-ADRESSEN LSB
        STA     BEGA+1    SPARA LSB
        JMP     [BEGA]    OCH HOPPA TILL STARTADRESSEN
*
* L[S FLEX FILE RECORD 
*
LESREC  BSR     LESPRM    H[MTA RAM-ADRESSEN MSB
        TFR     A,B       LAGRA I B
        BSR     LESPRM    H[MTA RAM-ADRESSEN LSB
        EXG     A,B       V[ND P] DET S] DET BLIR R[TT
        STD     ENDA      SPARA I ENDA
        BSR     LESPRM    H[MTA ANTAL BYTES I RECORD
        TFR     A,B       LAGRA DET I B
*
* KLART MED FLEX FILE RECORD
* LADDA NU NER PROGRAMMET FR]N EPROM0 TILL RAM
*
LESRCD2 BSR     LESPRM    H[MTA EN BYTE FR]N PROGRAMMET
        LDY     ENDA      VAR SKA DET SPARAS?
        STA     0,Y+      SPARA DET I MINNET, \KA Y
        STY     ENDA      SPARA N[STA ADRESS
        DECB              [R VI NERE P] 0?
        BNE     LESRCD2   NEJ; FORTS[TT TILLS VI [R DET.
        BRA     LOAD2     JA, LETA EFTER FLER RECORDS
*
LESPRM  STX     EPROM0    L]GG UT ADRESS
        LDA     EPROM0    L[S DATA
        INX               N[STA POS I PROMMET
        RTS               ]TERG]
*
```

