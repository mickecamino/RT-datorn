* NEW VERSION OF FLEX PATCH. ADDS NEW ROUTINES 
* TO ALLOW ANY PROGRAM TO PRINT TIME OR READ 
* ANY CLOCK DATA. SITS ATOP OF THE USER AND 
* PROTECTS ITSELF 
* ENDAST FÖR FLEX 265 !!!!!!!!! 
* 
* FLEX EQUATES 
* 
SYSYR   EQU     $CC10
SYSDAY  EQU     $CC0F
SYSMTH  EQU     $CC0E
PUTCHR  EQU     $CD18
PSTRNG  EQU     $CD1E
PCRLF   EQU     $CD24
PTEXT   EQU     $CE83     *** FÖR FLEX24: $CE84 
MEMEND  EQU     $CC2B 
* 
* CLOCK BOARD ADDRESS FOR PORT #4 
* 
CLOCK   EQU     $E010
* 
* CURRENT TOP OF MEMORY ADJUST IF NECESSARY 
* 
TOP     EQU     $BFFF 
* 
* INDIRECT JUMP TABLE FOR CLOCK FUNCTIONS 
* PUT TABLE AT TOP OF UTILITY SPACE 
* 
        ORG     $BFEC
* 
CLOCK1  FDB     DATEH     PRINT DATE WITH LABEL 
CLOCK2  FDB     DATEN     PRINT DATE AS MM/DD/YY
CLOCK3  FDB     DATEA     PRINT DATE AS DD-MMM-YY
CLOCK4  FDB     DATA      BLOCK OF 13 BYTES AS CLOCK DATA
CLOCK5  FDB     GETTIM    GET NEW TIME TO BUFFER 
CLOCK6  FDB     TIMEH     PRINT TIME WITH LABEL 
CLOCK7  FDB     TIMEN     PRINT PLAIN TIME AS XX:XX:XX 
CLOCK8  FDB     LSTTIM    PRINT LAST CALLED TIME PLAIN 
CLOCK9  FDB     DOW       PRINTS DAY OF WEEK 
CLOCKA  FDB     GETDAT    GETS DATA FROM STT TO STP 
* 
*PATCH TO JUMP TO NEW STARTUP 
* 
        ORG     $CA5E     * FÖR FLEX24: $CA50 
*
PATCH   JMP     START1
FILL    FCB     0,0,0,0,0,0
RETURN  BSR     $CAC4     RETUR TILL FLEX
* 
        ORG     $BDA0
* 
START1  LDD     #START1-1
        STD     MEMEND
START2  CLRA              SETUP PIA
        STA     CLOCK+1 
        STA     CLOCK+3
        STA     CLOCK
        COMA 
        STA     CLOCK+2
        LDA     #$3E
        STA     CLOCK+1
        STA     CLOCK+3
        LDB     CLOCK+2
        CMPA    CLOCK+3
        BEQ     BRDOK     BOARD OK THEN GET DATA
        LDX     #$CADE    FÖR FLEX24: $CADO START 
* 
* THIS IS STANDARD START USED IF BOARD NOT OK
* 
        JSR     $CE81     ** FÖR FLEX24: $CE82
        JSR     $CE2B     ** FÖR FLEX24: $CE2C
        JMP     $CA67
BRDOK   LDA     #$A0      SET UP TO GET ALL DATA
        STA     STT,PCR
        LDA     #$AC
        STA     STP,PCR
        JSR     [CLOCKA]  GETDATA
        LBSR    DT2FLX    MOVE DATE TO FLEX
        LEAX    INTRO,PCR 
        JSR     PTEXT
        JSR     [CLOCK9]  PRINT CURRENT DAY OF WEEK
        JSR     [CLOCK2]  PRINT DATE
        LDA     #$20      SPACE
        JSR     PUTCHR
        JSR     PUTCHR
        JSR     [CLOCK7]  PRINT TIME
        JMP     $CA7F
DOW     PSHS    A,B,X     PRINT PLAIN DAY OF WEEK
        LEAX    DATA,PCR
        LDB     6,X
        LDA     #10
        MUL
        LEAX    WKDYS,PCR
        ABX
        JSR     PTEXT
        PULS    A,B,X
        RTS
*
WKDYS   FCC     /S\ndag /
        FCB     4
        FCC     /M[ndag /
        FCB     4
        FCC     /Tisdag /
        FCB     4
        FCC     /Onsdag
        FCB     4
        FCC     /Torsdag /
        FCB     4
        FCC     /Fredag /
        FCB     4
        FCC     /L\rdag
        FCB     4
*         
GETDAT  PSHS    A,B,X,Y   GET DATA FROM STT TO STP
        LBSR    HOLDIN
        LEAX    DATA,PCR
        LEAY    LIMIT,PCR 

        LDA     STP,PCR
DATA1   STA     CLOCK+2
        LBRN    *
        LBRN    *
        LDB     CLOCK
        ANDB    0,Y+
        STB     0,X+
        CMPA    STP,PCR
        BEQ     DATA2
        INCA
        BRA     DATA1
DATA2   LBSR    HLDOUT
        PULS A,B,X,Y
        RTS
*
BDT2FLX LEAX    DATA+12,PCR MOVE DATA FROM BUFFER TO FLEX
        LDA     0,X
        LDB     #10
        MUL
        ADDB    0,-X
        STB     SYSYR
        LDA     0,-X
        LDB     #10
        MUL
        ADDB    0,-X
        STB     SYSMTH
        LDA     0,-X
        LDB     #10
        MUL
        ADDB    0,-X
        STB     SYSDAY
        RTS
*
DATEH   LEAX    DATES,PCR PRINTS DATE WITH LABEL
        JSR     PTEXT
DATEN   LEAX    DATA,PCR  PRINTS PLAIN DATE
        LDA     8,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     7,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     #'-
        JSR     PUTCHR
        LDA     10,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     9,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     #'-
        JSR     PUTCHR
        LDA     12,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     11,X
        ADDA    #$30
        JMP     PUTCHR
DATEA   LEAX    DATA,PCR  PRINT ALPHA MONTH IN DATE
        LDA     8,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     7,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     #'-
        JSR     PUTCHR
        PSHS    A,B,X
        LEAX    MONTHS,PCR
        LDB     SYSMTH
        DECB
        LDA     #4
        MUL
        ABX
        JSR     PTEXT
        LDA     #'-
        JSR     PUTCHR
        PULS    A,B,X
        LDA     12,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     11,X
        ADDA    #$30
        JMP     PUTCHR
TIMEH   LEAX    TIMES,PCR PRINT TIME WITH LABEL
        JSR     PTEXT
TIMEN   BSR     GETTIM
LSTTIM  LEAX    DATA+5,PCR PRINT TIME IN BUFFER
        LDB     #3
TIME1   LDA     0,X
        ADDA    #$30
        JSR     PUTCHR
        LDA     0,-X
        ADDA    #$30
        JSR     PUTCHR
        LEAX    -1,X
        DECB
        BEQ     TIME2
        LDA     #':
        JSR     PUTCHR
        BSR     TIME1
TIME2   RTS
*
GETTIM  LDA     #$A0
        STA     STT,PCR
        LDA     #$A5
        STA     STP,PCR
        LBRA    GETDAT
HOLDIN  PSHS    A         HOLD FOR READ
        LDA     #$80
        STA     CLOCK+2
        LDA     #$23
DLY1    LBRN    DLY1
        DECA
        BEQ     DLY2
        BRA     DLY1
DLY2    PULS    A
        RTS
*
HLDOUT  PSHS    A
        CLRA
        STA     CLOCK+2
        PULS    A
        RTS
*
INTRO   FCB     0,0,0
        FCC     /Logon : /
        FCB 4
DATES   FCC     /Datum /
        FCB     4
TIMES   FCC     /Tid /
        FCB     4
DATA    RMB     13
LIMIT   FCB $F,$F,$F,7,$F,3,7,$F,3,$F,3,$F,$F
TT      RMB     1
STP     RMB     1
MONTHS  FCC     /Jan/
        FCB     4
        FCC     /Feb/
        FCB     4
        FCC     /Mar/
        FCB     4
        FCC     /Apr/
        FCB     4
        FCC     /Maj/
        FCB     4
        FCC     /Jun/
        FCB     4
        FCC     /Jul/
        FCB     4
        FCC     /Aug/
        FCB     4
        FCC     /Sep/
        FCB     4
        FCC     /Okt/
        FCB     4
        FCC     /Nov/
        FCB     4
        FCC     /Dec/
        FCB     4
        END     $C600     *** FÖR FLEX24: $CDOO




