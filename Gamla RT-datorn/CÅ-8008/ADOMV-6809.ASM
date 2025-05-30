        NAM     ADOMV
        OPT     M09
*
* Programexempel för A/D-omvandlare
* CÅ-8008 till RT-datorn
*
* Av Åke Holm 80-06-25
*
* Programmet hämtar de analoga
* värdena från ingång 0 och 1 och
* omvandlar dessa till decimala värden
* mellan 0 och 255. dessa värden läggs
* ut på de sex lysdiodsindikatorerna
* på displaykort CÅ-8006
*
PIAAD0  EQU     $E080   DATAREGISTER ADRESSVAL
PIAAD1  EQU     $E081   KONTROLLREG. DITO
PIAAD2  EQU     $E082   DATAREGISTER MÄTVÄRDE
PIAAD3  EQU     $E083   KONTROLLREG. DITO
DISPL   EQU     $E0E0   ADRESS TILL FÖRSTA DISPLAY
*
        ORG     $C100
*
START   CLR     PIAAD1  NOLLA KONTROLLREG.
        CLR     PIAAD3
        CLR     PIAAD2  PB0-7 INGÅNGAR
        LDA     #$36    CB2 UTGÅNG, CB1 INGÅNG
        STA     PIAAD3
        LDA     #$0F    PA0-3 UTGÅNGAR
        STA     PIAAD0
        LDA     #4
        STA     PIAAD1
*
LOOP00  CLRB            NOLLA FÖR INGÅNG 0
        LDX     #BINTAB
        BSR     INPUT   HÄMTA MÄTVÄRDE KANAL 0
        BSR     BCDCON  OMVANDLA TILL DECIMALT
        LDA     2,X
        STA     DISPL   LÄGG UT PÅ FÖRSTA DISPLAYEN
        LDA     3,X     HÄMTA 2:A SIFFRAN
        STA     DISPL+1 LÄGG UT PÅ 2:A DISPLAYEN
        LDA     4,X     HÄMTA 3:E SIFFRAN
        STA     DISPL+2 LÄGG UT PÅ 3:E DISPLAYEN
        LDB     #1      HÄMTA FRÅN KANAL 1
        BSR     INPUT
        BSR     BCDCON
        LDA     2,X     HÄMTA 1:A SIFFRAN
        STA     DISPL+3 LÄGG UT PÅ 4:E DISPLAYEN
        LDA     3,X     HÄMTA 2:A SIFFRAN
        STA     DISPL+4 LÄGG UT PÅ 5:E DISPLAYEN
        LDA     4,X     HÄMTA 3:E SIFFRAN
        STA     DISPL+5 LÄGG UT PÅ 6:E DISPLAYEN
        BRA     LOOP00  FORTSÄTT
*
INPUT   STB     PIAAD0
        LDA     #$3E    GE HÖG PULS PÅ CB2
        LDB     #$36
        STA     PIAAD3  HÖG NU
        STB     PIAAD3  LÅG IGEN
INPUTS  LDA     PIAAD3  HÄMTA STATUS
        BPL     INPUTS  VÄNTA TILLS AD-CONV. KLAR
        LDA     PIAAD2  HÄMTA MÄTVÄRDE
        RTS
*
* RUTIN FÖR OMVANDLING AV EN
* HEX-BYTE TILL DECIMALTAL 0-255
* A-ACC LSB HALVA
* B-ACC MSB HALVA
*
BCDCON  STX     SAVEX   SPARA PEKAREN
        LDX     #CONST  TABELL FÖR KONSTANTEN
        CLRB
B10     CLR     SAVEA   ATT BILDA DECIMALTECKEN
B20     SUBA    1,X     DRAG IFRÅN TILLS UNDERFLOW
        SBCB    0,X
        BCS     B30
        INC     SAVEA
        BRA     B20
*
B30     ADDA    1,X
        ADCB    0,X
        PSHS    A
        STX     SAVEK0  SPARA AKTUELLT VÄRDE
        LDX     SAVEX   VAR SKALL DET LAGRAS
        LDA     SAVEA   LÄGG IN DET
        STA     0,X     I TABELLEN
        PULS    A       ÅTERTAG
        INX
        STX     SAVEX   SPARA NYA VÄRDET
        LDX     SAVEK0
        INX
        INX
        CPX     #KONEND SLUT PÅ KONSTANTERNA ?
        BNE     B10
        LDX     #BINTAB PEKA PÅ TABELLEN
        RTS
*
CONST   FDB     10000
        FDB     1000
        FDB     100
        FDB     10
        FDB     1
KONEND  EQU     *
*
SAVEA   RMB     1
SAVEK0  RMB     2
SAVEX   RMB     2
BINTAB  RMB     5
*
        END     START
