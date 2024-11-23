        NAM     UNIVKORT
*
* PROGRAMEXEMPEL FÖR SPECIALKORTET
* TILL RT:S DATORSERIE
*
* AV ÅKE HOLM 790215
*
PTM     EQU     $8030   ADRESS FÖR MC6840
*
* RAMCELLER FÖR DATALAGRING
*
        ORG     $0000
NOT     RMB     2       TEMPORÄR BUFFERT FÖR NOT
PNOT    RMB     2       NOT MED OFFSET
PTIMER  RMB     2       ADRESS TILL REGISTER
TAKT    RMB     1
TOP     RMB     1
*
TEMPO   EQU     $340
*
        ORG     $0100
*
        LDA     #$82    TIMER OUTPUT ENABLE
        STA     PTM     KONTROLLREG 3
        LDB     #$83
        STAB    PTM+1   KONTROLLREG 2
        STA     PTM     KONTROLLREG 1
*
* MUSIKPROGRAM
*
MUSIK   LDX     #VALS
        BSR     SPELA
MERA    LDX     #$FF
DELAY   DEX             GÖR EN PAUS
        BNE     DELAY
        BRA     MUSIK
*
SPELA   STX     NOT
NYTON   LDX     #PTM+2
PTMREG  STX     PTIMER
NESTA   LDX     NOT     HÄMTA NÄSTA NOT
        LDA     0,X     TILL A-ACKUM
        BNE     MSTOP   OM A=00 ÄR DET SLUT
        RTS
*
MSTOP   INX             FÖRBERED NÄSTA TON
        STX     NOT     OCH LAGRA I "NOT"
        TAB             SPARA BYTEN I B-ACK
        SUBB    #$0D    TESTA OM TAKTDATA
        BITB    #$0F    (LÅGA HALVAN =D)
        BNE     NOTER
*
* XO=KOD FÖR TAKTEN
* X= 1-F
*
        STAB    TAKT    SPARA TAKTEN
        BRA     NESTA
*
NOTER   PSHA            SPARA NOTEN
        TAB
        ANDA    #$0F    NOTDELEN INOM OKTAVEN
        ASLA            OMVANDLA NOTEN TILL EN
        ADDA    #SKALA  DIVISOR FÖR TIMERN
        STA     PNOT+1  LSB-HALVAN
        CLRA
        ADCA    #0      ADDERA MED CARRYFLAGGAN
        STA     PNOT
        LDX     PNOT
        LDA     0,X     PEKA PÅ DIVISORN
        STA     TOP     SPARA DIVISORN FÖR
        LDA     1,X     TOPPOKTAVEN
        ASLB
*
* MULTIPLICERA DIVISORN FÖR VARJE LÄGRE OKTAV
*
MULTI   SUBB    #$E0    MASKA UT OKTAVNUMRET
        BCC     MULTI0
        ROLA            MED CARRYBITEN=1
        ROL     TOP
        BRA     MULTI
*
MULTI0  DECA            FÖR DIVISION MED N+1
        LDX     PTIMER  HÄMTA ADR TILL TIMERREG.
        LDB     TOP     HÄMTA MSB-DIVISORN
        STAB    0,X     OCH LÄGG UT TILL TIMERN
        STA     1,X     LÄGG UT LSB-DIV. TILL TIMERN
        INX
        INX
        PULA            HÄMTA TILLBAKA NOTEN
        TSTA            TESTA OM HÖGSTA BITEN ÄR 1
        BPL     PTMREG  OM DEN ÄR 0 ÅTERGÅ
*
* OM HÖGSTA BITEN ÄR=1 SKALL TON(ERNA) UT
* UNDER TAKTTIDEN
*
TONUT   LDA     TAKT    HÄMTA TAKTVÄRDET
TONUT2  LDX     #TEMPO
TONUT3  DEX             VÄNTLOOP
        BNE     TONUT3
        DECA
        BNE     TONUT2  VÄNTA UT TAKTVÄRDET
        BRA     NYTON   ÅTERGÅ OCH HÄMTA NÄSTA
*
* TEMPERERAD 12-TONSSKALA
* SIFFRORNA GÄLLER FÖR EN KLOCKFREKVENS
* AV 614,4 KHZ. FÖR 1,000 MHZ GÄLLER
* DE VÄRDENA SOM STÅR INOM PARENTES
* ÄNDRAD TILL !MHZ 2024-11-23
        ORG     0008
SKALA   FDB     0,451,426,402 (0,277,262,247)
        FDB     379,358,338 (233,220,208)
        FDB     319,301,284 (196,185,175)
        FDB     268,253,239 (165,155,147)
*
* VALSNOTER AV MOZART
*
VALS    FCB     $20,$72,$4A,$E0,$EA,$65,$F0
        FCB     $72,$4A,$E0,$EA,$65,$E0
        FCB     $1D,$6C,$55,$C9,$F2,$F3,$EC,$6A,$C5,$E9
        FCB     $6A,$52,$CA,$E9,$EA,$F2,$2D,$65,$60,$E0
        FCB     $74,$CA,$1D,$F7,$F4,$6C,$E0,$F4
        FCB     $75,$4C,$CC,$F4,$75,$4C,$CC,$F9,$2D,$6C,$4C,$CC
        FCB     $1D,$72,$4A,$E0,$EA,$69,$CC,$E7,$65,$BC,$E4
        FCB     $2D,$45,$75,$E9,$1D,$D5,$D4,$52,$60,$E0,$CC,0
*
        END     START
