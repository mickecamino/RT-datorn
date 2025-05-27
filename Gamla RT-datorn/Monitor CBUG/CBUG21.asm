        NAM     CBUG 2.1
*
* 2K MONITOR FOR MOTOROLA MC 6809
*
* 1979-12-05
*
* COPYRIGHT BY ÅKE HOLM
*              LANOSJÖVÄGEN 15 B
*              5-135 54 TYRESö SWEDEN
*
* COMMANDS IN CBUG 2.1
*
* @
* A
* B DISPLAY BREAKPOINTS
* C CONTINUE
* D DUMPA I HEX OCH ASCII 8 BYTES/RAD
* E EXTENDED INSTRUKTIONSSöKNINO
* F GÅ TILL MINIDISK-BOOT FöR FLEX 9.0
* G GÅ TILL PROGRAMADRESS OCH EXEKVERA
* H BERÄKNA CHECKSUMMA AAAA-BBBB
* I
* J GÅ TILL SUBRUTIN OCH SKRIV UT REGISTREN
* K KOPIERA MINNESINNEHÅLL
* L LADDA MINNET I S1-FORMAT
* M MINNESMANIPULERING
* N STEGA NÄSTA INSTRUKTION
* O FYLL ETT VISST MINNESBLOCK MED EN BYTE
* P PUNCH I S1-FORMAT MED RUBRIK
* Q MÄT RAM-STORLEKEN
* R PRINTA REGISTREN
* S SöK 2 BYTES ADRESS
* T
* U TA BORT BREAKPOINTS
* V SÄTT IN BREAKPOINTS MAX 5 ST
* W
* X
* Y VERIFIERING
* Z DUMPA I HEX OCH ASCII 16 BYTES/RAD
* Ä
* Ö
* Å
* Û
*
RAM     EQU     $DF00
ROM     EQU     $F800
*
PORT1   EQU     $E008     TERMINAL ACIA
FLOPPY  EQU     $E010
SKIP1   EQU     $85       SKIPPAR 1 INSTRUKTION
SKIP2   EQU     $8C       SKIPPAR 2 BYTE INSTR
*
        ORG     RAM
*
BUFF    EQU     RAM+$80
STACK   EQU     RAM+$C0
        ORG     STACK
RAMVEK  EQU     *         VEKTORER I RAM
SWI4R   RMB     2
SWI3R   RMB     2
SWI2R   RMB     2
FIRQR   RMB     2
SIRQR   RMB     2
SWI1R   RMB     2
SVCVO   RMB     2         SUPERVIS: CALL VECTOF ORG
SVCVL   RMB     2         DITO LIMIT
USERST  EQU     *
USECC   RMB     2
USEA    RMB     1
USEB    RMB     1
USEDP   RMB     1
USEX    RMB     2
USEY    RMB     2
USEU    RMB     2
USEPC   RMB     2
USESP   RMB     2         USER STACKPOINTER VALUE
SLASK   RMB     2
*
        ORG     RAM+$E0
PORTUT  RMB     2         ADRESS FöR PORT
EKO     RMB     1         EKOFLAGGA
PORTIN  RMB     2         PORT FöR INTECKEN
VFLAG   RMB     1         NUMBER OF BREAKPOINTS
BPTAB   RMB     15        TABELL FÖR BREAKPOINTS
BEGA    RMB     2         STARTADRESS VID DUMP MM
ENDA    RMB     2         SLUTADRESS DITO
TILL    RMB     2         DESTADRESS VID KOPIERING
CKSM    RMB     1         CHECKSUMMA VID LOAD & PUNCH
BYTECT  RMB     1         LOAD & PUNCH
MCONT   RMB     1
TEMP    RMB     2         TEMP MEMORY
*
*
        ORG     ROM
*
* VECTORED ADRESSES FOR INDIRECT JUMPS
* COMPATIBLE WITH SWTPC S-BUG
*
        FDB     START
        FDB     CONTRL
        FDB     INCH
        FDB     INCHE
        FDB     INCHEK
        FDB     OUTCH
        FDB     PDATA
        FDB     PCRLF
        FDB     PSTRNG
        FDB     $FFFF     LOAD REAL ADDRESS
MON     BRA     START
*
* ADDITIONAL VECTORS NOT INCLUDED IN "S-BUG" *
*
        FDB     OUT2HS    OUTPUT 2 HEX CHARACTERS AND
        FDB     OUT4HS    OUTPUT 4 HEX CHARACTERS AND
        FDB     BADDRS    BUILD 16-BIT ADDRESS IN D &
        FDB     PDUMP
        FDB     BEGENS
*
* KALLSTART
*
KALST   LDX     #ROMVEK   FLYTTA KONSTANTER TILL RAM
        LDY     #RAMVEK
        LDB     #37
KAL50   LDA     0,X+
        STA     0,Y+
        DECB
        BNE     KAL50
START   LDX     #PORT1
        LDS     #STACK
        LBSR    SETPOR
*
        LDX     #USERST
        STX     USESP
        LBSR    NOBRKP    REMOVE BREAKPOINTS
*
* PRINT HEADER
*
WARMS   LDX     #TEXT01   "CBUG2A"
STARTS  LBSR    PSTRNG
*
CONTRL  LDS     #STACK    RESTORE STACKPOINTER
        LDX     #PORT1
        STX     PORTUT
        STX     PORTIN
        LDX     #TEXT03   INITIERINGS STRÄNG
        LBSR    PSTRNG
        STA     EKO
*
* TAG IN KOMMANDO I A-ACC
* SöK SEDAN INGÅNG TILL
* BEGÄRD RUTIN I KOMTAB.
*
*
        BSR     INCHE
        TFR     A,B
        LBSR    OUTS      BLANK
*
        SUBB    #$3F      CHECK IF VALID CHARACTER
        BLS     WRONG     FEL DÅ BK@
        CMPB    #$1F
        BHI     WRONG     FEL DÅ B VAR >Û
        ASLB              MULT MED 2
*
* INMATAT TECKEN OMGJORD TILL ADRESS
* I KOMMANDOTABELLEN
*
        LDX     #KOMTAB-2
        JSR     [B,X]     GO AND WORK
        BRA     CONTRL    RETURN TO MAIN LOOP
*
WRONG   LBSR    QUEST
        BRA     CONTRL
*
* RUTINER FöR ATT HÄMTA IN TECKEN I A-ACK
*
INCHO   TST     EKO
        BEQ     INCH      NO ECHO
INCHE   BSR     INCH      GET INPUT CHARACTER
        ANDA    #$7F      IGNORE PARITY
OUTCHI  LBRA    OUTCH
*
INCH    PSHS    X
        LDX     PORTIN
INCH5   LDA     0,X
        BITA    #1
        BEQ     INCH5
        LDA     1,X
        PULS    X
        RTS
*
* TEST IF INPUT CHARACTER
* Z=0 NO Z=1 YES
*
INCHEK  PSHS    A
        LDA     PORT1
        BITA    #1
        PULS    A
        RTS
*
* TAG IN HEXADECIMALT TECKEN.
* OMVANDLA ASCII 0-9,A-F TILL BINÄRT
* 0-F
*
INHEX   BSR     INCHE
INHEX2  CLV
        SUBA    #$20
        BMI     INHEX9    HOPPA OM EJ HEX
        CMPA    #$09
        BLE     IN1HG     DECIMALT ?
        CMPA    #$11
        BMI     INHEX9    HOPPA OM EJ HEX
        CMPA    #$16
        BGT     INHEX9    HOPPA OM EJ HEX
        SUBA    #$7
IN1HG   RTS
*
INHEX9  SEV               SET FLAG TO INDICATE NON HEX
        RTS
*
* TAG IN TVÅ TECKEN. GöR EN DATA BYTE
*
BYTE    BSR     INHEX     EXADECIMALT TECKEN
        BVS     INHEX9
BYTE2   ASLA
        ASLA
        ASLA
        ASLA              HHHH 0000
        TFR     A,B
        BSR     INHEX
        BVS     INHEX9
        PSHS B
        ADDA    0,S+
        TFR     A,B
        RTS
*
* BYGG ADRESS I D & X
*
BADDR   BSR     BYTE      HÖGSTA 8 BITARNA BVS INHEX9
        BVS     INHEX9
        PSHS    A
        BSR     BYTE
        PULS    A
        BVS     INHEX9
        TFR     D,X
        RTS
*
BADDRS  BSR     BADDR
        BVS     BEGRTS
        BRA     OUTS      SP+RTS
*
BEGEND  BSR     BADDRS
        BVS     BEGRTS
        STX     BEGA
        TFR     X,Y
ENDADR  BSR     BADDRS
        BVS     BEGRTS
        STX     ENDA
BEGRTS  RTS
*
BEGENS  LDX     #TEXT09   "START SLUT"
        BSR     PSTRNG
        BSR     BEGEND    FIXA START & STOPP
        BVS     BEGENS    OM EJ HEX INPUT TRY AGAIN
        BSR     CMPADR
        BCS     BEGENS
        RTS
*
BEGENT  BSR     BEGENS
        LEAX    1,X
        STX     ENDA
        RTS
*
CMPADR  LDD     ENDA
        SUBD    BEGA
        RTS
*
OUT2H   LDA     0,X+      PRINTA 2 HEX TECKEN
OUT2HT  PSHS    A
        BSR     OUTHL     OMVANDLA TILL ASCII
        PULS    A
        BRA     OUTHR     PRINTA HÖGRA BYTE HALVAN
*
OUT4HS  BSR     OUT2H     PRINTA 4 HEX TECKEN + BLANK
OUT2HS  BSR     OUT2H     PRINTA 2 HEX TECKEN + BLANK
OUTS    LDA     #$20      MELLANSLAG
        BRA     OUTCH     (RETURN I OUTCH)
*
OUTHL   LSRA
        LSRA
        LSRA
        LSRA
*
OUTHR   ANDA    #$0F      MASKA BORT HöG DELEN
        ADDA    #$20      TILLVERKA ASCII
        CMPA    #$39      STÖRRE ÄN 9
        BLS     OUTCH
        ADDA    #$7       FöR A—F
*
* MATA UT ETT TECKEN FRÅN A—ACC
*
OUTCH   PSHS    B,X
        LDX     PORTUT
*
OUT0    LDB     0,X       KONTROLLORDET
        ASRB
        ASRB
        BCC     OUT0
        STA     1,X       SÄND TECKNET
        PULS    B,X
        RTS
*
PCRLF   PSHS    X,A       SAVE POINTER & A—ACC
        LDX     #TEXT05   "CR + LF + 0"
        BSR     PDATA
        PULS    X,A       GET IT BACK
OUTRTS  RTS
*
*
* SKRIV UT TEXT STRÄNG,
* X—REG PEKAR PÅ TECKNEN.
* AVSLUT MED 'BOT' (04).
*
PSTRNG  BSR     PCRLF     SEND CR+LF FIRST
*
PDATA   LDA     0,X+      LADDA TECKEN
        CMPA    #$4       'EOT'
        BEQ     OUTRTS
        BSR     OUTCH
        BRA     PDATA
*
UTMIN   BSR     UTMIN3
UTMIN2  LDA     #'#
UTMIN3  BRA     OUTCH
*
NMIVK   STS     USESP     SAVE CURRENT STACKPOINTER
        LDX     #TEXT17   "AVBROTT PÅ"
        BSR     PDATA
        BSR     PRREG2
        LBRA    CONTRL
*
* SKRIV UT STACKENS INNEHÅLL
*
PRREG   BSR     PCRLF
PRREG2  LDX     USESP
        LDA     #'C
        BSR     UTMIN
        BSR     OUT2HS    CC
*
        LDA     #'A
        BSR     UTMIN
        BSR     OUT2HS    ACC-A
*
        LDA     #'B
        BSR     UTMIN
        BSR     OUT2HS    ACC-B
*
        LDA     #'D
        BSR     UTMIN
        BSR     OUT2HS    DP-REG
*
        LDA     #'X
        BSR     UTMIN
        BSR     OUT400    X-REG
*
        LDA     #'Y
        BSR     UTMIN
        BSR     OUT400    Y-REG
*
        LDA     #'U
        BSR     UTMIN
        BSR     OUT400    U-REG
*
        LDA     #'P
        BSR     UTMIN
        BSR     OUT400    PC-REG
*
        LDA     #'S
        BSR     UTMIN
        LDX     #USESP
OUT400  LBRA    OUT4HS
*
*
* HÄR PÅ 'M' KOMMANDO.
*
* MEMORY CHANGE WITH SHORT AND LONG OFFSET CALCULATION
*
CHANGE  LBSR    BADDRS    BYGG ADRESS, PRINTA BLANK
        TFR     X,Y
        BVS     CHARTS
CHANG   STX     BEGA
        LBSR    OUT2HS    PRINTA GAMLA INNEHÅLLET
CHA1    LBSR    INCHE
        CMPA    #'.       LINE FEED-ERSÄTTNING
        BEQ     LF
        CMPA    #'-       GO TO PREVIOUS LOCATION
        BEQ     CHOCON
        CMPA    #$0D      CR GO RTS
        BNE     CHA2
CHARTS  RTS
*
CHA2    CMPA    #'0       BERÄKNA OFFSET
        BNE     NYDATA
        STX     TILL
        LBSR    ENDADR    TAG IN DESTINATIONS ADRESSEN
        BVS     CHA50
        TFR     X,D       FLYTTA DEST ADRESSEN
        SUBD    TILL      SKILLNADEN
        CMPD    #$007F    KOLLA OM KORT OFFSET
        BLO     KORTOF
        CMPD    #$FF7F
        BHI     KORTOF
*
LONGOF  LEAX    -1,X      ETT EXTRA STEG
        TFR     X,D
        SUBD    TILL      NY SKILLNAD
        STD     TILL
        LDX     #TILL     PRINTA 4 HEX MED OFFSET
        LBSR    OUT4HS
        BRA     CHA50
*
* KORT OFFSET
*
KORTOF  TFR     B,A       LÅGA HALVAN
        LBSR    OUT2HT    PRINTA OFFSET (A-ACC)
        BRA     CHA50
*
NYDATA  LBSR    INHEX2
        BVS     CHA50
        LBSR    BYTE2
        BVS     CHA50
        STA     0,Y+      LAGRA I MINNET
        CMPA    -1,Y      FASTNADE DET?
        BEQ     CHA50
CHOFEL  LBSR    PIIIIP
CHOCON  LEAY    -1,Y      BACKA ETT STEG
        FCB     SKIP2
LF      LEAY    1,Y       STEGA TILL NÄSTA
CHA50   STY     BEGA
        LBSR    PCRLF
        LDX     #BEGA
        LBSR    OUT401    SKRIV ADRESSEN
        TFR     Y,X       LÄGG ADRESSEN I X IGEN
        BRA     CHANG     OM IGEN
*
* SWI SERVICE RUTIN (BREAKPOINTS)
*
SWISER  STS     USESP
        TFR     S,U
        LDS     #STACK
        TST     11,U      DECREMENTERA PC-VÄRDET
        BNE     *+4
        DEC     10,U
        DEC     11,U
        BSR     BRKP40    FINNS BREAK POINTS
        BEQ     BRKP20
*
* TAG BORT BREAK POINTS NÄR
* VI ÄR I TBUG MONITORN
*
BRKP00  LDA     2,X       BRKPT'S PÄ SAMMA ADRESS
        CMPA    #$3F      MULTIDEFINIERADE BRKPT'S
        BEQ     BRKP10
        LDY     0,X
        STA     0,Y
BRKP10  LEAX    3,X
        DECB
        BNE     BRKP00
BRKP20  LBSR    PRREG
        LBRA    CONTRL
*
BRKP40  LDX     #BPTAB    TABELL ÖVER BREAK POINTS
        LDB     VFLAG     ANTAL INSTALLERADE BRKPT'S
BRKRTS  RTS
*
* HÄR PÅ 'V' KOMMANDO 476
*
*
* SÄTT IN EN BRKPT.
*
SETBR   BSR     BRKP40    LEDIGT ?
        CMPB    #5        FINNS PLATS
        BLO     SETB50
        LBRA    PIIIIP
*
SETB50  LBSR    BADDR
        BVS     BRKRTS    OM EJ HEX GÅ RTS
        TFR     X,Y
*
        BSR     BRKP40    FINN LEDIG PLATS
        BEQ     BRKP60    OM LEDIG, STOPPA IN BRKPT
*
BRKP50 LEAX     3,X
        DECB
        BNE     BRKP50
*
BRKP60  INC     VFLAG
        STY     0,X       IN I TABELLEN
        RTS
*
* TA BORT ALLA BREAKPOINTS
*
NOBRKP  LDB     #16
        LDX     #VFLAG
U200    CLR     0,X+
        DECB
        BNE     U200
        RTS
*
* STOPPA IN ALLA BRKPTS I MINNET
* VID 'G' ELLER 'C'
*
BRKPIN  BSR     BRKP40
BRKPRT  BNE     TGB
PDKLAR  RTS
*
TGB     LDY     0,X
        LDA     0,Y       OPCODE SOM SKALL ERSÄTAS
        STA     2,X
        LDA     #$3F      SWI OPCODE
        STA     0,Y       ERSÄTT MED SWI
        LEAX    3,X
        DECB
        BRA     BRKPRT
*
* PRINT ALL BREAKPOINTS
*
DISBKP  LDB     VFLAG
        BEQ     DISBOO    OM NOLL INGA BRKPT'S
        LDX     #BPTAB    HÄMTA TABELLEN
DISB50  LBSR    OUT4HS    PRINTA ADRESSEN
        LEAX    1,X       HOPPA ÖVER OPCODEN
        DECB              NÄSTA
        BNE     DISB50
        RTS
*
DISBOO  LDA     #$30
        LBRA    OUTCH     PRINTA EN NOLLA
*
* GO TO AAAA AND EXECUTE PROGRAM
*
GOEXEC  LBSR    BADDR     START ADRESS
        BVS     LOAD35
        LDU     USESP
        STX     10,U      LÄGG IN PC-VÄRDET
*
* CONTINUE FROM BREAKPOINT
*
CONTIN  LDU     USESP
        BSR     BRKPIN    STOPPA IN EV BRKPT'S
        TFR     U,S
RTINT   RTI
*
LOAD00  LDX     #TEXT13   'SUBTRAHERA'
        LBSR    PSTRNG
        LBSR    BYTE
        BVS     LOAD35    IF NOT HEX BREAK
        STA     TILL
        LBSR    INPORT    TEST IF SEPARATE PORT
        lBSR    PCRLF
LOADL   LDA     #$11      DC1
        LBSR    OUTCH
*
LOAD3   LBSR    INCHEK
        BNE     LOAD35
        LBSR    INCHE     SöK RECORD TYP
        CMPA    #'S
        BNE     LOAD3
        LBSR    INCHE
        CMPA    #'9       EOF
        BNE     LOAD4
LOAD35  RTS
*
LOAD4   CMPA    #'1       DATA RECORD
        BNE LOAD3
        CLR     CKSM      ATT BYGGA CHECKSUMMA I
        LBSR    BYTE      LÄS IN BYTE RÄKNAREN
        BVS     LOAD3
        SUBA    #2        KOMMANDE ADRESS= 2 BYTE
        STA     BYTECT
        DECA
        STA     SLASK
*
* TILLVERKA ADRESS
*
LOAD5   LBSR    BADDR
        BVS     LOAD5
*
* TILLVERKA SLUTLIG LADDADRESS
*
ADRMOD  STX     BEGA      INMATAD ADRESS
        LDA     BEGA      HöG BYTE
        SUBA    TILL      EVENTUELL MODIFIERING
        STA     BEGA
        LDY     #BUFF-50
*
LOAD11  LBSR    BYTE
        BVS     LOAD11
        DEC     BYTECT    ANTAL BYTES I RECORDET
        BEQ     LOAD80    HOPPA OM KLAR
        STA     0,Y+      LAGRA I TEMP. BUFFER
        CMPY    #BUFF     SLUT PÅ BUFFERT
        BNE     LOAD11
LOAD70  BRA     PIIIIP
*
* KOLLA CHECKSUMMAN
*
LOAD80  INC     CKSM
        BNE     LOADA0
*
* TAG DATA FRÅN TEMPORÄRA BUFFERTERN
* OCH FLYTTA TILL MINNET
*
LOAD90  LDY     #BUFF-50
        LDX     BEGA
LOAD94  LDA     0,Y+
        STA     0,X+
        CMPA    -1,X      FASTNADE DET
        BNE     PIIIIP
        DEC     SLASK     BYTE RÄKNARE
        BNE     LOAD94
*
        FCB     SKIP2
LOADA0  BSR     PIIIIP
        BRA     LOAD3
*
PIIIIP  LDA     #$07
        LBSR    OUTCH
QUEST   LDA     #$3F
OUTCHH  LBRA    OUTCH
*
* PUNCHA MED KLARTEXTRUBRIK
*
HEADER  LBSR    BEGENS    START/STOPP
HEAD05  LDX     #TEXT14   'RUBRIK: '
        LBSR    PSTRNG
        LDX     #BUFF-50  TEMP BUFFER
        LDB     #4
        STB     0,X       LÄGG IN EOT
HEAD10  LBSR    INCHE     TAG IN TECKEN
        CMPA    #$08      OM BSP SKREV FEL
        BEQ     HEADER
        CMPA    #'<       OM PIL NY RUBRIK
        BEQ     HEAD05
        CMPA    #$D       'CR'
        BEQ     HEAD20    KLAR
        STA     0,X+      LAGRA I BUFF
        STB     0,X
        CMPX    #BUFF     MAX TECKENANTAL
        BNE     HEAD10
        BRA     PIIIIP
*
* KLAR MED RUBRIKEN
*
HEAD20  LBSR    UTPORT
        LDA     #$12      DC2 OUT
        BSR     OUTCHH
        LDX     #BUFF-50
        LBSR    PSTRNG    UT MED RUBRIKEN
*
PUN11   LBSR    CMPADR    JAMFOR START/STOPP ADR
        TSTA
        BNE     PUN22
        CMPB    #16
        BCS     PUN23
*
* LÄGG UT 16 MINNESBYTE/RECORD
*
PUN22   LDB     #15
PUN23   ADDB    #4        INKLUDERA ADRESS I BYTE
        STB     MCONT
        SUBB    #3
        STB     TEMP      DETTA RECORDS BYTE ANTAL
*
* PUNCHA CR,LF,NULL,S,1
*
        LDX     #TEXT02
        LBSR    PSTRNG
        CLRB              CHECKSUMMA
*
* PUNCHA RECORDETS BYTE RÄKNARE
*
        LDX     #MCONT
        BSR     PUNT2     2 HEX
*
* PUNCHA ADRESSEN A8A
*
        LDX     #BEGA
        BSR     PUNT2
        BSR     PUNT2
*
* DATA
*
        LDX     BEGA
PUN32   BSR     PUNT2     2 ASCII TECKEN
        DEC     TEMP      BYTE RÄKNAREN
        BNE     PUN32
*
* KLAR
*
        COMB              CHECKSUMMAN INVERTERAS
        TFR     B,A
        LBSR    OUT2HT    2 HEX TECKEN
        STX     BEGA
        CMPX    ENDA      KLAR MED HELA DUMPEN
        BLS     PUN11
        BRA     S9REC     JA KLAR
*
* PUNCHA 2 HEX, UPPDATERA CHECKSUMMAN
*
PUNT2   ADDB    0,X
        LBRA    OUT2H     PUNCHA 2 TECKEN OCH RTS
*
* AVSLUTA MED S9
*
S9REC   LDX     #TEXT06   'S901'
        LBSR    PSTRNG    SÄND IVAG'ET
        LDX     #$FFFF
S999    LEAX    1,X
        BNE     S999
S99RTS  RTS
*
SUBR    LBSR    BADDR     SUBRUTINTEST
        BVS     S99RTS
        LDS     #USEPC+1
        JSR     0,X       HOPPA DIT
        SWI               SKRIV REGISTER OCH ÅTERGÅ
*
* C H K S M
*
CHKSM   LBSR    BEGENT
        CLRA
        CLRB
*
CKSM10  CMPY    ENDA
        BEQ     CKSM20
        ADDB    0,Y+
        ADCA    #0
        BRA     CKSM10
*
CKSM20  STD     BEGA
        LDX     #TEXT11   'CKSM'
        LBSR    PSTRNG
        LDX     #BEGA
OUT401  LBRA    OUT4HS
*
*
*
*
* HÄR PÅ 'D' KOMMANDO.
*
* DUMP RUTIN.
* UTLAGD SOM SUBRUTIN FOR ATT KUNNA
* ANVANDAS I AVLUSNINGSSYFTE I EGNA
* PROGRAM. DA MASTE BEGA/ENDA LADDAS
* MED START RESP. STOPPADRESSER.
* BEGA MODIFIERAS AV RUTINEN.
*
DUMP8   LBSR    BEGENS    LAGG UPP START/STOPP
        LBSR    UTPORT    FRÅGA OM PORT
        LDA     BEGA+1
        ANDA    #$F8
        LDB     #8
        BSR     PDUMP     +RTS
        BRA     DUMPOR
*
DUMP16  LBSR    BEGENS    FIXA START & STOPP
        LBSR    UTPORT
        LDA     BEGA+1
        ANDA    #$F0      FULL RAD
        LDB     #16
        BSR     PDUMP
DUMPOR  LBRA    PORTU1    +RTS
*
PDUMP   STA     BEGA+1
        STB     BYTECT
*
PD1000  LBSR    BREAK     AVBROTT ?
*
        LBSR    PCRLF
*
* BORJA DUMPA
* FORMAT: AAAA BB BB BB BB BB BB BB BB .ASCII..
*
        LDX     #BEGA
        BSR     OUT405    PRINTA ADRESSEN
        LDX     BEGA
        LDB     BYTECT    8 BYTES/RAD
PD3000  LBSR    OUT2HS
        DECB
        BNE     PD3000
*
* PRINTA SAMMA BYTES MEN I
* EKVIVALENT ASCII.
*
        LBSR    OUTS      SPACE
        LDB     BYTECT
        LDX     BEGA
PD4000  LDA     0,X+
        ANDA    #$7F      MASKA BIT 8
*
* SKRIV EJ UT KONTROLLTECKEN
* MEN SMÅ BOKSTÄVER,
* DVS OM A<$20
* ELLER AY$7F
* BYT DA MOT '.'
*
        CMPA    #$20
        BLT     PD5000
        CMPA    #$7F
        BLT     PD6000
PD5000  LDA     #'.
PD6000  LBSR    OUTCH
        DECB
        BNE     PD4000
*
        STX     BEGA
*
* KOMPARERA START/STOPP ADRESSER
*
        LBSR    CMPADR
        BCC     PD1000
        RTS
*
************************
*
* K O P I E R I N G *
************************
*
COPY    BSR     BEGEN3
        BHI     COPY80
COPY10  CMPY    ENDA
        BEQ     BREART
        LDA     0,Y+
*
COPY15  STA     0,X+      LAGRA
        NOP
        CMPA    -1,X      FASTNADE
        BEQ     COPY10
*
* INGET MINNE I
*
COPY20  STX     TILL
        LDX     #TEXT08   'EJ ÄNDRAT'
        LBSR    PSTRNG
        LDX     #TILL
OUT405  LBRA    OUT4HS    +RTS
*
COPY80  LDD     ENDA      FLYTTA HÖGTSA BITEN FÖRST
        TFR     D,Y
        SUBD    BEGA
        LEAX    D,X       SKILLNANDEN MELLAN "ENDA" FINNS
*                         BEGA ADDERAD MED "TILL"
COPY85  LDA     0,Y       HÄMTA
        STA     0,X       LÄGG UT
        CMPY    BEGA
        BEQ     BREART
        CMPA    0,X
        BNE     COPY20
        LEAX    -1,X
        LEAY    -1,Y
        BRA     COPY85    FASTNADE JO
*
BEGEN3  LDX     #TEXT07   'START SLUT TILL'
        LBSR    PSTRNG
        LBSR    BEGEND
        LEAX    1,X
        STX     ENDA
        LBSR    BADDRS
        BVS     BEGEN3    TRY AGAIN
        STX     TILL
        CMPX    BEGA
BREART  RTS

*****
* HJÄLPRUTINER
******
*
ADDRDA  LBSR    PCRLF
        LDX     #BEGA
        BSR     OUT405    NNNN DD
        LDX     BEGA
OUT205  LBRA    OUT2HS
*
BREAK   LBSR    INCHEK    KOLLA OM TECKEN
        BEQ     BRETS
        LBSR    INCH
        ANDA    #$7F
        CMPA    #'Q       AVBRYTA
        BEQ     BREAQ
        CMPA    #'0       PAUS ?
        BNE     BRETS
        LBSR    INCH      VÄNTA PÅ TECKEN
        CMPA    #'Q       AVBRYT ?
        BNE     BRETS
BREAQ   LEAS    2,S
BRETS   RTS
*
*
**********************
*
* V E R I F Y
*
**********************
*
VERIF   BSR     BEGEN3
VERI10  CMPY    ENDA
        BEQ     BREART
        LDA     0,Y
        CMPA    0,X       VERIFIERA
        BEQ     VERI20    HOPPA OM SAMMA
*
        BSR     ADDRDA    NNNN DD
        LBSR    OUTS      SP
        LDX     #TILL
        LBSR    OUT4HS    MMMM
        LDX     TILL
        BSR     OUT205    DD
*
        LDX     BEGA
VERI20  LEAY    1,Y
        STY     BEGA
        LEAX    1,X
        STX     TILL
        BSR     BREAK
        BRA     VERI10    OM IGEN
*
*
************************
*
* N O L L A / F F - S T Ä L L
*
************************
*
*
NOLLFF  LBSR    BEGENT
*
        LDX     #TEXT10   'BYTE'
        LBSR    PSTRNG
        LBSR    BYTE
NOLL10  CMPY    ENDA
        BEQ     BREART
        STA     0,Y+
        BRA     NOLL10
*
*
******************************
*
* E X T E N D E D  A D R .  T E S T
*
******************************
*
*
EXTE    LBSR    BEGENT
EXTE2   LDX     #TEXT10   'BYTE'
        LBSR    PSTRNG
        LBSR    BYTE
        BVS     EXTE2
        STA     SLASK
*
EXTE10  CMPY    ENDA
        BNE     EXTE15
        RTS
*
EXTE15  STY     BEGA
        CMPA    0,Y+
        BNE     EXTE20
*
* SKRIV NNNN 00 PPPP
*
        LBSR    ADDRDA
        LBSR    OUT4HS
EXTE20  LBSR    BREAK
        LDA     SLASK
        BRA     EXTE10
*
* MÄT RAMSTORLEK
*
METRAM  LDX     #1
MET10   LDA     #$55
        LDB     0,X
        STA     0,X
        NOP
        LDA     0,X
        STB     0,X+
        CMPA    #$55
        BEQ     MET10
*
MET80   LEAX    -2,X      BACKA
        STX     TEMP
        LDX     #TEXT16   'RAM SLUT='
        LBSR    PDATA
        LDX     #TEMP     PRINTA SLUTADRESSEN
OUT408  LBRA    OUT4HS    +RTS
*
* SöK 2 BYTES
*
SOK2B   LBSR    BEGENT
SOK2B2  LDX     #TEXT15+3 'ADRESS'
        LBSR    PSTRNG
        LBSR    BADDR     FIXA 4 TECKEN I X-REG
        BVS     SOK2B2
        STX     TILL
SOK2B4  CMPY    ENDA      Y=BEGA
        BNE     SOK25
        RTS
*
SOK25   STY     BEGA
        LDX     TILL
        CMPX    0,Y
        BNE     SOK2B7
        LBSR    PCRLF
        LDX     #BEGA     HÄMTA ADRESSEN
        BSR     OUT408
        TFR     Y,X
        BSR     OUT408    LÄGG UT DATAT
SOK2B7  LBSR    BREAK
        LEAY    1,Y
        BRA     SOK2B4
*
*
BOOT0   LDA     #$7E      FIXA ATERSTART
        STA     $C000
        FCB     $8E       =LDX IMM
        FDB     BOOT2     ADRESS DITO
        STX     $C001
BOOT2   LDY     #FLOPPY
        LDB     #$0F
OVR     STB     $8,Y      COMREG TURN MOTOR ON
        CLRA
        LDX     #0
        STA     $4,Y      DRIVE #0
        LEAX    1,X
        BNE     OVR
        STB     $8,Y      COMREG
        BSR     BOTRTS
LOOP1   LDB     $8,Y      COMREG
        BITB    #1
        BNE     LOOP1
        LDA     #1
        STA     $A,Y      SECREG
        BSR     BOTRTS
        LDB     #$8C      READ W LOAD
        STB     $8,Y      COMREG
        BSR     BOTRTS
        LDX     #$C000
LOOP2   BITB    #2        DRQ?
        BEQ     LOOP3
        LDA     $B,Y      DATAREG
        STA     0,X+
LOOP3   LDB     $8,Y
        BITB    #1
        BNE     LOOP2
        JMP     $C000
*
BOTRTS  BSR     BOOTRT
BOOTRT  RTS
*
*
INPORT  BSR     PORT50
        BVS     PORTS
IPORT5  STX     PORTIN
PORTS   RTS
*
UTPORT  BSR     PORT50
        BVS     PORTS
UPORT5  STX     PORTUT
        RTS
*
PORT50  LDX     #TEXT12   "PORT="
        LBSR    PSTRNG
        LBSR    INHEX     SKAFFA NYTT VÄRDE
        BVS     PORTS     OM EJ HEX INGEN ÄNDRING
        TFR     A,B
        LDX     #$E004    BASADRESS
        LSLB
        LSLB              MULT MED 2
        ABX               X HAR NU NYA PORTADRESSEN
SETPOR  LDA     #3        RESET ACIAN
        STA     0,X
        LDA     #$15      SÄTT UPP ACIAN
        STA     0,X
        RTS
*
PORTU1  LDX     #$E008    KONTROLLPORT
        BRA     UPORT5
*
PORTI1  LDX     #$E008
        BRA     IPORT5
*
*
*
* INTERRUPT VECTORS JUMP
*
SWI4V   JMP     [SWI4R]
SWI3VK  JMP     [SWI3R]
SWI2VK  JMP     [SWI2R]
FIRQVK  JMP     [FIRQR]
SIRQVK  JMP     [SIRQR]
SWI1VK  JMP     [SWI1R]
*
ROMVEK  FDB     RTINT     SWI4
        FDB     RTINT     SWI3
        FDB     RTINT     SWI2
        FDB     RTINT     FIRQ
        FDB     RTINT     IRQ
        FDB     SWISER    RUTIN FÖR BREAKPOINTS
        FDB     $FFFF
        FDB     $FFFF
        FCB     $D0       USER CC
        FCB     0         USER A
        FCB     0         USER B
        FCB     0         USER DP
        FDB     0         USER X
        FDB     0         USER Y
        FDB     USERST    USER U-STACK
        FDB     WARMS     USER PC
        FDB     USERST    USER SP
        FDB     0         SLASK
        FDB     PORT1
        FCB     $55       EKOFLAGGA
        FDB     PORT1
*
TEXT01  FCC     'CBUG 2.1'
        FCB     4
*
TEXT02  FCB     'S,'1,4   PUNCH I S1—FORMAT
*
TEXT03  FCB     $13       READER RELAY OFF
TEXT04  FCB     $14,0,'$,4
*
TEXT05  FCB     $D,$A,0,0,0,4
*
TEXT06  FCB     'S,'9,4
*
TEXT07  FCC     'START SLUT TILL'
        FCB     $D,$A,'>,4
*
TEXT08  FCC     'EJ ÄNDRAT:'
        FCB     4
*
TEXT09  FCC     'START SLUT'
        FCB     $D,$A,'>,4
*
TEXT10  FCC     'BYTE: '
        FCB     4
*
TEXT11  FCC     'CKSM:'
        FCB     4
*
TEXT12  FCC     'PORT='
        FCB     4
*
TEXT13  FCC     'SUBTRAHERA (00—FF):'
        FCB     4
*
TEXT14  FCC     'RUBRIK:'
        FCB     4
*
TEXT15  FCC     'NY ADRESS: '
        FCB     4
*
TEXT16  FCC     'RAM SLUT=$'
        FCB     4
*
TEXT17  FCB     $D,$A
        FCC     "Avbrott vid: "
        FCB     4
*
        FCB     1         VERSION
*
*
        ORG     ROM+$7B0
*
* KOMMANDOTABELL
*
KOMTAB  FDB     OUTRTS
        FDB     OUTRTS
        FDB     DISBKP    DISPLAY BREAKPOINTS
        FDB     CONTIN
        FDB     DUMP8
        FDB     EXTE      EXTENDED SöKNING
        FDB     BOOT0     MINIDISKBOOT
        FDB     GOEXEC
        FDB     CHKSM
        FDB     CONTRL
        FDB     SUBR
        FDB     COPY
        FDB     LOAD00    L LADDA UTAN OFFSET
        FDB     CHANGE    MINNESMANIPULERING
        FDB     OUTRTS
        FDB     NOLLFF
        FDB     HEADER
        FDB     METRAM
        FDB     PRREG
        FDB     SOK2B
        FDB     OUTRTS    LADDA MED OFFSET
        FDB     NOBRKP
        FDB     SETBR
        FDB     OUTRTS
        FDB     OUTRTS
        FDB     VERIF
        FDB     DUMP16
        FDB     OUTRTS    Ä
        FDB     OUTRTS    Ö
        FDB     OUTRTS    Å
        FDB     OUTRTS    Û
KOMTEN  EQU     *
*
* VEKTORER
*
        ORG     ROM+$7EE
*
PORTE0  FDB     PORT1     ADRESS TILL ACIAN
        FDB     SWI4V
        FDB     SWI3VK
        FDB     SWI2VK
        FDB     FIRQVK
        FDB     SIRQVK    SLOW IRQ
        FDB     SWI1VK    SWI VEKTOR
        FDB     NMIVK
        FDB     KALST     RESTART VEKTOR KALL START
*
*ÅÄÖ
        END     KALST

