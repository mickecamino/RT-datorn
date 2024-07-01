        NAM     TBUG 2C
*
* 1980-10-16 TOMMY BLAD OCH ÅKE HOLM
* COPYRIGHT BY TOMMY BLADH       OCH ÅKE HOLM
*              BÅSTADSVÄGEN 7        LÅNGSJÖVÄGEN 15B
*              121 51 JOHANNESHOV    135 54 TYRESÖ
*
*
* KOMMANDON I TBUG2C
* @ VARMSTART I FLEX 2.0
* A
* B DISPLAY BREAKPOINTS
* C CONTINUE
* D DUMPA I HEX OCH ASCII 8 BYTES/RAD
* E EXTENDED INSTRUKTIONSSÖKNING
* F G] TILL MINIDISK-BOOT
* G G] TILL PROGRAMADRESS OCH EXEKVERA
* H BER[KNA CHECKSUMMA AAAA-BBBB
* I
* J G] TILL SUBRUTIN OCH SKRIV UT REGISTREN
* K KOPIERA MINNESINNEHÅLL
* L LADDA MINNET I S1-FORMAT MED EV. OFFSET
* M MINNESMANIPULERING
*   - GER FÖREGÅENDE MINNESPOSITION
*   . GER NÄSTA MINNESPOSITION
*   OAAAA OFFSETBERÄKNING
* N NÄSTA INSTRUKTION
* O FYLL ETT VISST MINNESBLOCK MED EN BYTE
* P PUNCH I S1-FORMAT MED RUBRIK
* Q M[T RAM-STORLEKEN
* R PRINTA REGISTREN
* S S\K 2 BYTES ADRESS
* T
* U TA BORT BREAKPOINTS
* V S[TT IN BREAKPOINTS MAX 5 ST
* W MINNESTEST
* X EXCHANGE AA NNNN MOT AA MMMM
* Y VERIFIERING
* Z DUMPA I HEX OCH ASCII 16 BYTES/RAD
* Ä
* Ö
* Å
* Ü
*
*
ACIAT   EQU     $8008     TERMINAL ACIA
PIASAH  EQU     $80D0
PIASAL  EQU     $80D1
PIACRA  EQU     $80D2
PIACRB  EQU     $80D3
PORT    EQU     $8008
DRVREG  EQU     $8014
COMREG  EQU     $8018
SECREG  EQU     $801A
DATREG  EQU     $801B
SKIP1   EQU     $85       SKIPPAR 1 INSTRUKTION
SKIP2   EQU     $8C       SKIPPAR 2 BYTE INSTR
*
*
* DATA AREOR
*
        ORG     $A000
IOV     RMB     2         IRQ VEKTOR
BEGA    RMB     2         START ADRESS /PRINT/PUNCH
ENDA    RMB     2         SLUT ADRESS
NIO     RMB     2         NMI VEKTOR
SP      RMB     2         ANVÄNDARENS STACK PEKARE
CKSM    RMB     1         CHECKSUMMA
BYTECT  RMB     1         RÄKNAREKNARE
XHI     RMB     1         TEMP LAGRING X-REG HÖG BYTE
XLOW    RMB     1         LAGRING LÅG BYTE
MCONT   RMB     1
SWIVEK  RMB     2         EGEN SWI VEKTOR
EKO     RMB     1         EKO FLAGGA
DMASK   RMB     1
SWIFLX  RMB     2         SWI VEKTOR FÖR FLEX
        RMB     43        STACK AREA
STACK   RMB     1         HÄR BÖRJAR STACKEN
VFLAG   RMB     1         ANTAL INSATTA BRKPT'S
BPTAB   RMB     15        5 ST BREAK POINTS
BUFF    RMB     59        BUFFERT AREA
        RMB     1         IN BUFFERT
TILL    EQU     IOV
SLASK   EQU     BYTECT
LOFFST  EQU     IOV
*
        ORG     $E000

IO      LDX     IOV       IRQ
        JMP     ,X        TAG HAND OM AVBROTTET
*
* NMI SERVICE RUTIN
*
POWDWN   LDX     NIO       NMI
        JMP     ,X
*
* SWI SERVICE RUTIN
*
SWISER  LDX     SWIVEK
        JMP     ,X
*
* HÄR PÅ 'L' KOMMANDO
*
*
* LOAD
*
LOAD    INC     EKO
LOADL   LDA     #$11      DC1
        BSR     OUTCH
*
LOAD3   BSR     INCH      SÖK RECORD TYP
        CMPA    #'S
        BNE     LOAD3
        BSR     INCH
        CMPA    #'9       EOF
        BEQ     LOAD21
        CMPA    #'1       DATA RECORD
        BNE     LOAD3
        CLR     CKSM      ATT BYGGA CHECKSUMMA I
        BSR     BYTE      LÄS IN BYTE RÄKNAREN
        SUBA    #2        KOMMANDE ADRESS= 2 BYTE
        STA     BYTECT
        DECA
        STA     BUFF+2
*
* TILLVERKA ADRESS
*
        BSR     BADDR
        JSR     ADRMOD    TILLV SLUTL LADDADRESS
        LDX     #BUFF+3   TEMP BUFFERT ADRESS
*
        JMP     LOAD10
*
        ORG     $E040
LOAD19  JSR     PIIP      PIP OCH FRÅGETECKEN
        NOP
LOAD21  EQU     *
C1      JMP     CONTRL
*
* BYGG ADRESS
*
BADDR   BSR     BYTE      HÖGSTA 8 BITARNA
        STA     XHI
        BSR     BYTE
        STA     XLOW
        LDX     XHI       HELA ADRESSEN
        RTS
*
* TAG IN TVÅ TECKEN, GÖR EN DATA BYTE
*
BYTE    BSR     INHEX     HEXADECIMALT TECKEN
BYTE2   ASLA
        ASLA
        ASLA
        ASLA              HHHH OOOO
        TAB
        BSR     INHEX
        ABA               HHHH LLLL
        TAB
        ADD B   CKSM      ADDERA TILL CHECKSUMMAN
        STA B   CKSM
        RTS
*
OUTHL   LSRA
        LSRA
        LSRA
        LSRA
*
OUTHR   ANDA    #$0F      MASKA BORT HÖGA DELEN
        ADDA    #$30      TILLVERKA ASCII
        CMPA    #$39      STÖRRE ÄN 9
        BLS     OUTCH
        ADDA    #$07      FÖR A-F
*
* MATA UT ETT TECKEN
*
OUTCH   JMP     OUTEEE
INCH    JMP     INEEE     TAG IN ETT TECKEN
*
* SKRIV UT TEXT STRÄNG.
* X-REG PEKAR PÅ TECKNEN.
* AVSLUT MED 'EOT' (04).
*
PDATA2  BSR     OUTCH
        INX
PDATA1  LDA     ,X
        CMPA    #$04      'EOT'
        BNE     PDATA2
        RTS
*
INCH7   BSR     INCH      HÄMTA TECKEN
        CMPA    #$5F      KOLLA OM SMÅ BOKSTÄVER
        BLS     INCH8
        SUBA    #$20
INCH8   RTS
*
TEXT06  FCC     "Cksm:"
        FCB     $04
*
IOINIT  JSR     BEGENS    START OCH SLUTADRESSER
DC2OUT  LDA     #$12      DC2 LÄSARE PÅ
        BRA     OUTCH     + RTS
*
        ORG     $E09B
*
BEGEND  BSR     BADDRS
        STX     BEGA
ENDADR  BSR     BADDRS
        STX     ENDA
        RTS
*
BADDRS  BSR     BADDR
        BRA     OUTS      SP+RTS
*
*
        ORG     $E0AA
*
* TAG IN HEXADECIMALT TECKEN.
* OMVANDLA ASCII 0-F TILL BINÄRT
* 0-F
*
INHEX   BSR     INCH7
INHEX2  SUBA    #$30
        BMI     C1        HOPPA OM EJ HEX
        CMPA    #$09
        BLE     IN1HG     DECIMALT ?
        CMPA    #$11
        BMI     C1        HOPPA OM EJ HEX
        CMPA    #$16
        BGT     C1        HOPPA OM EJ HEX
        SUBA    #$07
IN1HG   RTS
*
OUT2H   LDA     ,X        PRINTA 2 HEX TECKEN
OUT2HA  INX
OUT2HT  PSHA
        BSR     OUTHL     OMVANDLA TILL ASCII
        PULA
        BRA     OUTHR     PRINTA HÖGRA BYTE HALVAN
*
OUT4HS  BSR     OUT2H     PRINTA 4 HEX TECKEN + BLANK
OUT2HS  BSR     OUT2H     PRINTA 2 HEX TECKEN + BLANK
OUTS    LDA     #$20      MELLANSLAG
        BRA     OUTCH     (RETURN I OUTCH)
*
* VARM-START
*
START   LDX     #STTBUG   'TBUG 2'
STARTS  BSR     PDATA1
*
CONTRL  LDS     #STACK-8  INITIERA STACKEN
        NOP
        NOP
        CLR     EKO       FULL DUPLEX
        LDX     #MCLOFF   INITIERINGS STRÄNG
        BSR     PDATA1
*
* TAG IN KOMMANDO I A-ACC
* SÖK SEDAN INGÅNG TILL
* BEGÄRD RUTIN I KOMTAB.
*
* ENTRY-PUNKT FÖR MIKBUG/CONTRL
*
        FCB     SKIP2
MIKCON  BRA     CONTRL
*
        BSR     INCH
        TAB               SPARA UNDAN
        BSR     OUTS      BLANK
        CMPB    #$60      GÖR OM SMÅ BOKSTÄVER
        BCS     CON50     TILL STORE
        SUBB    #$20
*
CON50   SUBB    #$3F      B ÄR NU 1 FÖR STOR
        BLS     CONTRL    FEL DÅ B < @
        CMPB    #$1E
        BHI     CONTRL    FEL DÅ B VAR > Ü
*
* INMATAT TECKEN OMGJORD TILL ADRESS
* I KOMMANDOTABELLEN
*
        LDX     #KOMTAB-2
NESTA   INX
        INX
        DECB
        BNE     NESTA
        LDX     ,X        INHOPPSADRESS TILL RUTIN
        JMP     ,X        PYS DIT & JOBBA
*
STTBUG  FCB     $0D,$0A,$00,$00
        FCC     "TBUG 2C"
        FCB     4
*
* NMI AVBROTT - SINGLE STEP
*
NONMSK  STS     SP
        JSR     DISNMI
*
* HÄR PÅ 'R' KOMMANDO.
*
PRINT   BSR     PRREG
C2      BRA     CONTRL
*
* SKRIV UT STACKENS INNEHÅLL
*
PRREG   BSR     PCRLF
        LDX     SP
        INX
        LDA     #'C
        JSR     UTMIN
        BSR     OUT2HS    CC
        LDA     #'B
        JSR     UTMIN
        BSR     OUT2HS    ACC-B
        JMP     PRREG9
*
*
PCRLF   LDX     #SCRLF    CR+LF
PDAT1   JMP     PDATA1    STRENG + RTS
*
* PUNCH DUMP I S1 FORMAT
*
MTAPE1  FCB     $0D,$0A,0,0,0,0,'S,'1,4  PUNCH FORMATET
*
* HÄR PÅ 'P' KOMMANDO.
*
PUNCH   JSR     IOINIT
*
PUN11   BSR     CMPADR    JÄMFÖR START/STOPP ADR
        BNE     PUN22
        CMPA    #16
        BCS     PUN23
*
* LÄGG UT 16 MINNESBYTE/RECORD
*
PUN22   LDA     #15
PUN23   ADDA    #4        INKLUDERA DRESS I BYTE RÄKNAREN
        STA     MCONT
        SUBA    #3
        STA     BUFF      DETTA RECORS BYTE ANTAL
*
* PUNCHA CR,LF,NULL,S,1
*
        LDX     #MTAPE1
        BSR     PDAT1
        CLRB              CHECKSUMMA
*
* PUNCHA RECORDETS BYTE RÄKNARE
*
        LDX     #MCONT
        BSR     PUNT2     2 HEX
*
* PUNCHA ADRESSEN
*
        LDX     #BEGA
        BSR     PUNT2
        BSR     PUNT2
*
* DATA
*
        LDX     BEGA
PUN32   BSR     PUNT2     2 ASCII TECKEN
        DEC     BUFF      BYTE RÄKNAREN
        BNE     PUN32
*
* KLAR
        COMB              CHECKSUMMAN INVERTERAS
        TBA
        JSR     OUT2HT    2 TECKEN
        STX     BEGA
        DEX
        CPX     ENDA      KLAR MED HELA DUMPEN
        BNE     PUN11
        BRA     S9REC     JA KLAR
*
* JÄMFÖR START/STOPP ADRESSER
*
CMPADR  LDA     ENDA+1
        SUBA    BEGA+1
        LDB     ENDA
        SBCB    BEGA
        RTS
*
* PUNCHA 2 HEX, UPPDATERA CHECKSUMMAN
*
PUNT2   ADD B   ,X
        JMP     OUT2H     PUNCHA 2 TECKEN OCH RTS
*
* AVSLUTA MED S9
*
S9REC   LDX     #S9STR    'S901'
        JMP     S9PAUS
*
        ORG     $E19C
*
*
MCLOFF  FCB     $13       READER RELAY OFF
MCL     FCB     $0D,$0A,0,0,0,$14,0,'*,4
*
SCRLF   FCB     $0D,$0A,0,0,0,4
*
        ORG     $E1AC
*
* TAG IN ETT TECKEN I ACC A
*
INEEE   BSR     INCHP
        ANDA    #$7F      MASKA PARITETEN
        CMPA    #$7F      IGNORERA 'RUBOUT'
        BEQ     INEEE
        TST     EKO       SKALL TECKNET EKAS UT
        BEQ     OUTEEE    HOPPA OM JA
        RTS
*
INCHP   LDA     ACIAT     FINNS TECKEN
        ASRA
        BCC     INCHP
        LDA     ACIAT+1   DATA
        RTS
*
* NÄSTA INSTR
*
NEST    LDS     SP
        LDA     #$34
        STA     PIACRA
        RTI
*
S9STR   FCB     0
        FCC     'S9'
        FCB     4
*
*
*
        ORG     $E1D1
*
* MATA UT ETT TECKEN FRÅN A-ACC
*
OUTEEE  PSHB
*
OUTO    LDB     ACIAT     KONTROLLORDET
        ASRB
        ASRB
        BCC     OUTO
        STA     ACIAT+1   SÄND TECKNET
        PULB
        RTS
*
*
BEGENS  LDX     #TEXT04
        JSR     PDATA3
        JSR     BEGEND    FIXA START &STOPP
        BSR     CMPADR
        BCS     BEGENS
        RTS
*
BEGENT  BSR     BEGENS
        INX
        STX     ENDA
        RTS
*
TEXT07  FCC     "Opcode:"
        FCB     $04
*
* HÄR PÅ 'M' KOMMANDO
*
*  MINNES MANIPULERING
*
CHANGE  JSR     BADDRS    BYGG ADRESS , PRINTA BLANK
CHANG   LDX     XHI
        JSR     OUT2HS    PRINTA GAMLA INNEHÅLLET
        STX     BEGA
        DEX
CHA1    JSR     INCH7     SMÅ EL STORA BOKST.
        CMPA    #'.       LINE FEED-ERSÄTTNING
        BEQ     LF
        CMPA    #'-       Ü
        BEQ     UA
        CMPA    #'O       BERÄKNA OFFSET
        BNE     NYDATA
        JSR     ENDADR    TAG IN DESTINATIONS ADRESSEN
        JSR     CMPADR    JÄMFÖR ADRESSERNA
*
* OM B=00, INOM RECKHÅLL FRAMMÅT
*          OM A<80
* OM B=FF, INOM RECKHÅLL BAKÅT
*
        TSTA              OFFSET FRAMMÅT <80 ÄR OK
        BMI     OK
        TSTB
        BNE     CHOFEL
        DECB              B=FF NU
OK      INCB
        BNE     CHOFEL    FEL I OFFSET BAKÅT
        JSR     OUT2HT    PRINTA OFFSET (A-ACC)
*
CHOCON  LDX     BEGA      URSPRUNGLIGA OPCODE ADRESS
        BRA     UA
NYDATA  JSR     INHEX2
        JSR     BYTE2
        STA     ,X
        CMPA    ,X
        BNE     CHOFEL
        INX
        INX
*
UA      DEX
        FCB     SKIP1     HOPPA ÖVER NÄSTA INSTRUKTION
LF      INX
        STX     XHI
        LDX     #MCL      LF+CR,NULLS
        JSR     PDATA1
        LDX     #XHI
        JSR     OUT4HS    SKRIV DATA ADRESSEN
        BRA     CHANG     OM IGEN
*
CHOFEL  BSR     PIIP
        BRA     CHOCON
*
*
* FORTSÄTTNING PÅ LOAD
*
LOAD10  STX     BEGA
*
LOAD11  JSR     BYTE
        DEC     BYTECT    ANTAL BYTES I RECORDET
        BEQ     LOAD80    HOPPA OM KLAR
        STA     ,X        LAGRA I TEMP. BUFFER
        INX
        CPX     #BUFF+50  SLUT PÅ BUFFERT
        BNE     LOAD11
LOAD70  JMP     LOAD19
*
* KOLLA CHECKSUMMAN
*
LOAD80  INC     CKSM
        BNE     LOADA0
*
* TAG DATA FRÅN TEMPORÄRA BUFFERTEN
* OCH FLYTTA TILL MINNET
*
LOAD90  LDX     BEGA
        LDA     ,X
        INX
        STX     BEGA
*
        LDX     BUFF      ADRESS TILL MINNET
        STA     ,X
        CMPA    ,X
        BNE     LOAD70    FASTNADE DET
*
        INX
        STX     BUFF
        DEC     BUFF+2    BYTE RÄKNARE
        BNE     LOAD90
*
        FCB     SKIP2
LOADA0  BSR     PIIP
        JMP     LOAD3
*
PIIP    LDA     #$07
        BSR     OUTEE
        LDA     #$3F
UTMIN   BSR     OUTEE
UTMIN2  LDA     #'=
*
OUTEE   JMP     OUTEEE    INSTRUKTIONSSPARARE
*
KILL    CLR     VFLAG     TA BORT ALLA BRKPOINTS
BIL300  BRA     CKSM30    MELLANHOPP
*
*
*
*
* C H K S M
*
CHKSM   JSR     BEGENT
        CLRA
        CLRB
        LDX     BEGA
*
CKSM10  CPX     ENDA
        BEQ     CKSM20
        ADDA    ,X
        ADCB    #$00
        INX
        BRA     CKSM10
*
CKSM20  STA B   BEGA
        STA     BEGA+1
        LDX     #TEXT06   "CKSM"
        JSR     PDATA3
        LDX     #BEGA
        JSR     OUT4HS
CKSM30  BRA     BRKP30
*
LOADOF  LDX     #TEXT09   'SUBTRAHERA'
        JSR     PDATA3
        JSR     BYTE
        FCB     SKIP1
LOADNO  CLRA              EJ OFFSET
        STA     LOFFST
        JMP     LOADL
*
* TILLVERKA SLUTLIG ADRESS
*
ADRMOD  STX     BUFF      INMATAD ADRESS
        LDA     XHI       HÖG BYTE
        SUBA    LOFFST    EVENTUELL MODIFIERING
        STA     BUFF
        RTS
*
TEXT11  FCC     "Rubrik:"
        FCB     4
*
        ORG     $E2F1
*
*
* SWI SERVICE RUNTIN (BREAK POINTS)
*
SFE     STS     SP
        JSR     DISNMI
        TSX
        TST     6,X       DECREMENTERA PC-VÄRDET
        BNE     *+4
        DEC     5,X
        DEC     6,X
        BSR     BRKP40    FINNS BREAK POINTS
        BEQ     BRKP20    PRINTA REGISTREN
*
* TAG BORT BREAK POINTS NÄR
* VI ÄR INNE I TBUG MONITORN
*
BRKP00  STX     XHI       SKYDDA MOT FLERA
        LDA     2,X       BRKPT'S PÅ SAMMA ADRESS
        CMPA    #$3F      MULTIDEFINIERADE BRKPT'S
        BEQ     BRKP10
        LDX     ,X
        STA     ,X
        LDX     XHI
BRKP10  BSR     ADD3X
        BNE     BRKP00
BRKP20  JMP     PRINT
*
ADD3X   INX
        INX
        INX
        DECB
        RTS
*
BRKP40  LDX     #BPTAB    TABELL ÖVER BREAK POINTS, OPCODER
        LDB     VFLAG     ANTAL INSTALLERADE BRKPT'S
        RTS
*
* HÄR PÅ 'V' KOMMANDO
*
*
* SÄTT IN EN BRKPT.
*
SETBR   JSR     SWIINS
*
        BSR     BRKP40    FINNS LEDIG PLATS
        BEQ     BRKP60    OM LEDIG, STOPPA IN BRKPT'
        CMPB    #5        MAX 5 PLATSER
        BCS     BRKP50
        JMP     LOAD19
*
BRKP50  BSR     ADD3X
        BNE     BRKP50
*
BRKP60  INC     VFLAG
        LDA     XHI       ADRESS TILL MINNE
        STA     ,X        IN I TABELLEN
        LDA     XLOW
        STA     1,X
BRKP30  JMP     CONTRL
*
*
* STOPPA IN ALLA BRKPTS I MINNET
* VID 'G' ELLER 'C'
*
BRKPIN  BSR     BRKP40
BRKPRT  BNE     *+3
PDKLAR  RTS
*
TBG     STX     XHI
        LDX     ,X
        LDA     ,X
        PSHA
        LDA     #$3F      SWI OPCODE
        STA     ,X
        LDX     XHI
        PULA
        STA     2,X       SPARAD OPCODE
        BSR     ADD3X
        BRA     BRKPRT
*
* HÄR PÅ 'G' KOMMANDO
*
*
* GÅ OCH EXEKVERA
*
GOEXEC  JSR     BADDR     START ADRESS
        LDX     SP
        STA     7,X       LÅG ADRESS
        LDA     XHI       MSB ADRESS HALVA
        STA     6,X       HÖG ADRESS
*
* HÄR PÅ 'C' KOMMANDO
*
*
CONTIN  BSR     BRKPIN    STOPPA IN EV BRKPT'S
        LDS     SP
        RTI
*
*
* HÄR PÅ 'D' KOMMANDO.
*
* DUMP RUTIN
* UTLAGD SOM SUBRUTIN I FÖR ATT KUNNA
* ANVÄNDAS I AVLUSNINGSSYFTE I EGNA
* PROGRAM. DÅ MÅSTE BEGA/ENDA LADDAS
* MED START RESP. STOPPADRESSER.
* BEGA MODIFIERAS AV RUTINEN.
*
DUMP    LDB     #8
        STA B   DMASK
        JSR     BEGENS    LÄGG UPP START/STOP
        BSR     PDUMP
        BRA     BRKP30
*
        ORG     $E384
*
PDUMP   LDA     BEGA+1
        ANDA    #$F8      MASKA TILL FULL RAD
PDUMP5  STA     BEGA+1
*
PD1000  JSR     PCRLF     RADBYTE
*
* BÖRJA DUMPA
* FORMAT: AAAA BB BB BB BB BB BB BB BB .ASCII..
*
        LDX     #BEGA
        JSR     OUT4HS    PRINTA ADRESSEN
        LDX     BEGA
        LDB     DMASK     8 BYTES/RAD
PD3000  JSR     OUT2HS
        DECB
        BNE     PD3000
*
* PRINTA SAMMA BYTES MEN I
* EKVIVALENT ASCII.
*
        JSR     OUTS      SPACE
        LDB     DMASK
        LDX     BEGA
PD4000  LDA     ,X
        ANDA    #$7F      MASKA BIT 8
*
* SKRIV EJ UT KONTROLLTECKEN
* MEN SMÅ BOKSTÄVER,
* DVS OM A<$20
* ELLER A>$7F
* BY DÅ MOT '.'
*
        CMPA    #$20
        BLT     PD5000
        CMPA    #$7F
        BLT     PD6000
PD5000  LDA     #$2E
PD6000  JSR     OUTCH
        INX
        DECB
        BNE     PD4000
*
        STX     BEGA
        BEQ     PDKLAR    KOLLA OM KLAR
*
* KOMPARERA START/STOP ADRESSER
*
        JSR     CMPADR
        BCS     PDKLAR
        JSR     BREAK
        BRA     PD1000    1 RADF RAMMÅT
*
* KALLSTART
*
CSTART  EQU     *
        LDS     #STACK-8  STACKPOINTER INITIERING
        STS     SP
        LDA     #3        RESET ACIA
        STA     ACIAT
        LDA     #$FF      PIA UTGÅNGAR
        STA     PIASAH
        STA     PIASAL    LSB-HALVA
        JSR     DISNMI    SET CA2 HÖG
        LDA     #$34
        STA     PIACRB    SET CB2 LÅG
        CLR     VFLAG     0 ANTAL BRKPT'S INSATTA
        LDX     #NONMSK   PSEUDO NMI VEKTOR
        STX     NIO       GER NU SINGLE STEP FUNCTION
        JSR     SWIIN2
        LDA     #$15      8 BIT, EJ PAR.,RTS LÅG, 1STOPPB.
        STA     ACIAT
        CLR     EKO       FULL DUPLEX
        LDA     #8
        STA     DMASK
        JMP     START     TILL RESTEN AV STARTEN
*
* KOMMANDOTABELL
*
KOMTAB  FDB     FLEX0
        FDB     CONTRL
        FDB     DISBRK
        FDB     CONTIN
        FDB     DUMP
        FDB     EXTE      EXTENDED SÖKNING
        FDB     BOOT0     MINIDISKBOOT
        FDB     GOEXEC
        FDB     CHKSM
        FDB     CONTRL
        FDB     SUBR
        FDB     COPY
        FDB     LOADOF    LADDA MED EV. OFFSET
        FDB     CHANGE    MINNESMANIPULERING
        FDB     NEST
        FDB     NOLLFF
        FDB     HEADER
        FDB     METRAM
        FDB     PRINT
        FDB     SOK2B
        FDB     CONTRL
        FDB     KILL
        FDB     SETBR
        FDB     MEMTST
        FDB     XCHA      EXCHANGE
        FDB     VERIF
        FDB     DUMP16
        FDB     CONTRL    Ä
        FDB     CONTRL    Ö
        FDB     CONTRL    Å
        FDB     CONTRL    Ü
KOMTEN  *
*
* DISABLA NMI
*
DISNMI  LDA     #$3C
        STA     PIACRA
        RTS
*
SUBR    JSR     BADDR     SUBRUTINTEST
        LDS     #STACK
        JSR     ,X        HOPPA DIT
        SWI               SKRIV REGISTER OCH ÅTERGÅ
*
**************
* K O P I E R I N G *
************************
*
COPY    BSR     BEGEN3
COPY10  BSR     CBEND
        LDA     ,X
        INX
        STX     BEGA      DATA HÄMTAT
*
        LDX     TILL
        STA     ,X        LAGRA
        TST     X         TIME OUT
        CMPA    X         FASTNADE
        BNE     COPY20
        INX
        BSR     STXRUT
        BRA     COPY10    FORTSÄTT
*
* INGET MINNE I
*
COPY20  LDX     #TEXT03   'EJ ÄNDRAT'
        JSR     PDATA3
        LDX     #TILL
        JSR     OUT4HS
        BRA     CTRL10
*
BEGEN3  LDX     #TEXT02
        JSR     PDATA3
        JSR     BEGEND
        INX
        STX     ENDA
        JSR     BADDRS
STXRUT  STX     TILL
BREART  RTS
*
*****
* HJÄLPRUTINER
******
*
ADDRDA  JSR     PCRLF
        LDX     #BEGA
        JSR     OUT4HS    NNNN DD
        LDX     BEGA
UT2HS1  JMP     OUT2HS
*
BREAK   LDA     PORT
        ASRA
        BCC     BREART
        LDA     PORT+1
BRE12   ANDA    #$7F
        CMPA    #'0       PAUS ?
        BEQ     BREKQ
BRQ     CMPA    #'q       ÄVEN LILLA Q
        BEQ     BREAQ
        CMPA    #'Q'
        BNE     BREART
BREAQ   BRA     CTRL10
*
BREKQ   JSR     INCHP
        BRA     BRE12
*
CBEND   LDX     BEGA
CBEND1  CPX     ENDA
        BNE     BREART
CTRL10  JMP     CONTRL
*
************************
*
* V E R I F Y
*
************************
*
VERIF   BSR     BEGEN3
VERI10  BSR     CBEND
        LDA     ,X
        LDX     TILL
        CMPA    ,X        VERIFIERA
        BEQ     VERI20    HOPPA OM SAMMA
*
        BSR     ADDRDA    NNNN DD
        JSR     OUTS      SP
        LDX     #TILL
        JSR     OUT4HS    MMMM
        LDX     TILL
        BSR     UT2HS1    DD
*
VERI20  LDX     BEGA
        INX
        STX     BEGA
        LDX     TILL
        INX
        STX     TILL
        BSR     BREAK
        BRA     VERI10    OM IGEN
*
*
**********************
*
* N O L L A  /  F F - S T Ä L L
*
**********************
*
*
NOLLFF  JSR     BEGENT
*
        LDX     #TEXT05   'TECKEN'
        BSR     PDATA3
        JSR     BYTE
        LDX     BEGA
NOLL10  BSR     CBEND1
        STA     ,X
        INX
        BRA     NOLL10
*
*
**********************************
*
* E X T E D E D  A D R -  T E S T
*
**********************************
*
*
EXTE    JSR     BEGENT
        LDX     #TEXT07   'OP-CODE'
        BSR     PDATA3
        JSR     BYTE
        STA     SLASK
*
EXTE10  BSR     CBEND
        LDA     X
        CMPA    SLASK     MATCHAR ?
        BNE     EXTE20
*
* SKRIV NNNN OO PPPP
*
        JSR     ADDRDA
        JSR     OUT4HS
EXTE20  BSR     BEGINC
        BRA     EXTE10
*
PDATA3  STX     BUFF
        JSR     PCRLF
        LDX     BUFF
        JMP     PDATA1
*
* RUTIN FÖR ATT BYTA UT ADRESSER
* I EXT. INSTRUKTIONER
XCHA    JSR     BEGENT    START+SLUT
        LDX     #TEXT07   'OPCODE'
        BSR     PDATA3
        JSR     BYTE
        STA     SLASK
        LDX     #TEXT12+3 'ADRESS'
        BSR     PDATA3
        JSR     BADDR     IN MED AAAA
        STX     BUFF+2    SPARA ADRESSEN
        LDX     #TEXT12   'NY ADRESS'
        BSR     PDATA3
        JSR     BADDR     FIXA NYA ADRESSEN
        STX     BUFF+4    SPARA DEN
XCHA30  JSR     CBEND     KOLLA OM BEG=END
        LDA     ,X        1:A BYTEN
        CMPA    SLASK
        BNE     XCHA90
        LDA     1,X       2:A BYTEN
        CMPA    BUFF+2
        BNE     XCHA90
        LDA     2,X
        CMPA    BUFF+3
        BNE     XCHA90
        LDA     BUFF+4    BYT 1:A
        LDB     BUFF+5
        STA     1,X
        STA B   2,X
        JSR     ADDRDA
        LDX     #BUFF+2
        JSR     OUT4HS
        JSR     UTMIN2
        LDX     #BUFF+4
        JSR     OUT4HS
XCHA90  BSR     BEGINC
        BRA     XCHA30
*
*
BEGINC  LDX     BEGA
        INX
        STX     BEGA
        JMP     BREAK     +RTS
*
* PUNCHA MED KLARTEXTRUBRIK
*
HEADER  JSR     BEGENS    START/STOPP
        LDX     #TEXT11   'RUBRIK:'
        BSR     PDATA3
        LDX     #BUFF+2   TEMP BUFFER
        LDA     #4
        STA     ,X        LÄGG IN EOT
HEAD10  JSR     INEEE     TAG IN TECKEN
        CMPA    #$1B      OM ESC SKREV FEL
        BEQ     HEADER
        CMPA    #$0D      'CR'
        BEQ     HEAD20    KLAR
        STA     X         LAGRA I BUFF
        INX
        LDA     #4        EOF TECKEN
        STA     X
        CPX     #BUFF+49  MAX TECKENANTAL
        BNE     HEAD10
*
HEAD30  JMP     LOAD19
*
* KLAR MED RUBRIKEN
*
HEAD20  JSR     DC2OUT
        LDX     #BUFF+2
        JSR     PDATA3    UT MED RUBRIKEN
        JMP     PUN11     PUNCHA DATA
*
* MINNESTEST
*
MEMTST  EQU     *
*
        JSR     BEGENS
        BSR     PCRLFW
        CLRB
LOOP    PSHB
        LDX     BEGA
        DEX
INITLP  INX
        STA B     X
        INCB
        CPX     ENDA
        BNE     INITLP
*
*
BUBBLE  STX     BUFF+2
        LDX     BEGA
EXCHG   STX     BUFF
        LDA     X
        LDX     BUFF+2
        LDB     X
        STA     X
        DEX
        STX     BUFF+2
        LDX     BUFF
        STA B     X
        CPX     BUFF+2
        BEQ     CHKL
        INX
        CPX     BUFF+2
        BNE     EXCHG
CHKL    PULA
        PSHA
        DECA
        LDX     ENDA
        STX     BUFF+2
        LDX     BEGA
        STX     BUFF
*
CHECK   LDX     BUFF+2
        INCA
        CMPA    ,X
        BNE     ERROR
CONTIW  CPX     BEGA
        BEQ     GOOD
        LDX     BUFF
        INX
        STX     BUFF
        LDX     BUFF+2
        DEX
        STX     BUFF+2
        BRA     CHECK
*
*
GOOD    LDA     #'!
        JSR     OUTCH
        JSR     BREAK
        DEC     CKSM
        BNE     PASS
        BSR     PCRLFW
PASS    PULB
        INCB
        BRA     LOOP
*
PCRLFW  LDA     #32
        STA     CKSM
        JMP     PCRLF
*
ERROR   LDB     X
        PSHB
        PSHA
        JSR     PCRLF
        LDA     BUFF+2
        JSR     OUT2HT
        LDA     BUFF+3
        BSR     WUT2HS
        PULA
        TAB
        BSR     WUT2HS
        PULA
        BSR     WUT2HS
        TBA
        LDX     BUFF+2
        BRA     CONTIW
*
WUT2HS  JSR     OUT2HT
        LDA     #$20
WOUTCH  JMP     OUTCH
*
* MÄT RAMSTORLEK
*
METRAM  EQU     *
        LDX     #STRRAM
        JSR     PDATA3
        LDX     #0
MET10   INX
        LDA     #$55
        LDB     ,X
        STA     ,X
        LDA     ,X
        STA B     ,X
        CMPA    #$55
        BEQ     MET10
*
MET80   DEX
        STX     XHI       SPARA MAXADRESSEN
        LDX     #XHI
        BSR     AUT4HS
        BRA     S0P95
*
* DISPLAY BREAK POINTS
*
DISBRK  LDB     VFLAG     HÄMTA ANTAL
        BEQ     DISB00
        LDX     #BPTAB    HÄMTA TABELLEN
DISB50  JSR     OUT4HS
        INX               HOPPA ÖVER OPKOD
        DECB
        BNE     DISB50
        BRA     S0P95
*
DISB00  LDA     #$30      SÄND EN NOLLA
        BSR     WOUTCH
        BRA     S0P95
*
* SÖK 2 BYTES ADRESS
*
SOK2B   JSR     BEGENT
        LDX     #TEXT12+3 'ADRESS'
        JSR     PDATA3
        JSR     BADDR     FIXA 4 TECKEN
        LDX     BEGA
SOK2B4  JSR     CBEND1
        LDA     ,X        KOLLA FÖRSTA BYTEN
        CMPA    XHI
        BNE     SOK2B7
        LDB     1,X
        CMPB    XHI+1
        BNE     SOK2B7
        JSR     PCRLF
        LDX     #BEGA     HÄMTA ADRESSEN
        BSR     AUT4HS
        LDX     #XHI
        BSR     AUT4HS    LÄGG UT DATAT
SOK2B7  JSR     BEGINC
        BRA     SOK2B4
*
S9PAUS  JSR     PDATA3
S0P95   JMP     CONTRL
*
* FORTSÄTTNING PÅ REG-PRINT
*
PRREG9  LDA     #'A
        BSR     UTMIN8
        JSR     OUT2HS    A-ACK
        LDA     #'X
        BSR     UTMIN8
        BSR     AUT4HS    X-REG
        LDA     #'P
        BSR     UTMIN8
        BSR     AUT4HS
        LDA     #'S
        BSR     UTMIN8
        LDX     #SP
AUT4HS  JMP     OUT4HS    SP +RTS
*
UTMIN8  JMP     UTMIN
*
*
DUMP16  LDB     #16
        STA B   DMASK
        JSR     BEGENS    FIXA START & STOPP
        LDA     BEGA+1
        ANDA    #$F0      FULL RAD
        JSR     PDUMP5
        LDA     #8
        STA     DMASK
        BRA     S0P95
*
BOOT0   LDA     #$7E      FIXA ÅTERSTART
        STA     $2400
        LDX     #BOOT2
        STX     $2401
        LDB     #$D0      FORCE INTERRUPT
        STA B   COMREG
BOOT2   CLRA
        LDX     #$7000
BOOT3   STA     DRVREG    DRIVE #0 MOTOR ON
        INX
        BNE     BOOT3
BOOT4   LDB     #$0F      RESTORE
        STA B   COMREG
        BSR     BOTRTS
LOOP1   LDB     COMREG
        BITB    #1
        BNE     LOOP1
        CLR     SECREG
        BSR     BOTRTS
        LDB     #$9C      READ W LOAD
        STA B   COMREG
        BSR     BOTRTS
        LDX     #$2400
LOOP2   BITB    #2        DRQ?
        BEQ     LOOP3
        LDA     DATREG
        STA     ,X
        INX
LOOP3   LDB     COMREG
        BITB    #1        BUSY ?
        BNE     LOOP2
        LDB     COMREG    CRC FEL ?
        ANDB    #$0C
        BNE     BOOT4
        JMP     $2400
*
BOTRTS  BSR     BOOTRT
BOOTRT  RTS
*
SWIINS  EQU     *
        JSR     BADDR
SWIIN2  EQU     *
        LDX     SWIVEK
        STX     SWIFLX
        LDX     #SFE      LÄGG IN TBUGS VEKTOR
SWI90   STX     SWIVEK
        RTS
*
FLEX0   LDX     SWIFLX    LÄGG TILLBAKS
        STX     SWIVEK
        JMP     $AD03     GÅ TILL FLEX VARMSTART
*
TEXT02  FCC     "Start Slut Till"
        FCB     $0D,$0A,'>,4
*
TEXT03  FCC     "Ej {ndrat:"
        FCB     4
*
TEXT04  FCC     "Start Slut"
        FCB     $0D,$0A,'>,4
*
TEXT05  FCC     "Tecken: "
        FCB     4
*
TEXT09  FCC     "Subtrahera (00-FF):"
        FCB     4
*
TEXT12  FCC     "Ny Adress: "
        FCB     4
*
STRRAM  FCC     "Ram slut="
        FCB     4
*
* VEKTORER
*
        ORG     $E7F8
*
        FDB     IO        IRQ VEKTOR
        FDB     SWISER    SWI VEKTOR
        FDB     POWDWN    NMI VEKTOR
        FDB     CSTART    RESTART VEKTOR KALL START
*
        END
