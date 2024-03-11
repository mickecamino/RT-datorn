        NAM    MEMEX.CMD
        OPT    PAG
        PAG
**************************************
*       MEMEX- ETT RELOKERBART       *
* MEMORY EXAMINE/CHANGE PROGRAM      *
* -- F\R FLEX9 DOS.
* UR '68 MICRO JOURNAL' JAN.83 S.36  *
**************************************
*
* ANPASSAT TILL RT-DATORN MED
* C] 790 TERMINAL
*
* AV
*    NILS-OLOV JOHANSSON
*    STAVANGERG. 72
*    163 33 SP]NGA
*
* 128 BYTES VISAS P] SK[RMEN I HEX OCH
* ASCII KOD. CURSORN FLYTTAS INOM 
* MINNESBLOCKET MED TANGENTERNA:
*
* V[NSTER-PIL   (BS,$08)
* H\GER-PIL     (HT,$09)
* UPP-PIL       (+ ,$2B)
* NER-PIL       (- ,$2D)
*
* VISAT MINNESBLOCK [NDRAS MED:
*
* CTRL F   FRAM]T
* CTRL B   BAK]T
* CTRL A   NY ADDRESS
* 
* CTRL T   BYT MODE HEX/ASCII
* CTRL [   ESCAPE TILL FLEX
*
*************************************
*
* INGEN F\RKLARANDE TEXT [R MED F\R
* ATT H]LLA NER STORLEKEN P] LISTNINGEN
* KOMPLETT LISTNING MED KOMMENTARER SE
* 68 MICRO JOURNAL JAN.-83 SID.36
*
*************************************
***  EQUATES
VOUTCH  EQU    $D3F9     VECTOR ADDRESS
WARMS   EQU    $CD03
VINCH   EQU    $F804     VECTOR I CBUG EJ EKO
LF      EQU    10
CR      EQU    13
* DEFINIERA CURSORSTYRNING
BS      EQU    8         V[NSTER
HT      EQU    9         H\GER
VT      EQU    $2B       '+' UPP
FF      EQU    $2D       '-' NER
*
XYOFS   EQU    $4040     OFFSET CURSORPOSITIONERING
DARK    EQU    $1B15     SL[CK CURSOR
LIT     EQU    $1B02     T[ND CURSOR
CLSCR   EQU    $1B05      RADERA SK[RMEN
*
        ORG    0         DEFINIERA VARIABEL NAMN TILL
LINEBUF RMB    5         STACK OFFSET
VAL     RMB    2
MODE    RMB    1
INCOUNT RMB    1
OCOUNT  RMB    1

VARLEN  RMB    0         L[NGD P] VARIABELLISTAN
*
        ORG    $C100
*
MEMEX   BRA    START
VER     FCB    3         F\R C] 790
START   LEAS   -VARLEN,S RESERVERA PLATS
 LEAU   0,S              VARIABEL [R OFFSET TILL U
*
MEMEX1  LBSR   CLRSCR
        LDD    #$1A
        LBSR   LOADCUR
        LEAX   ADRPRM,PCR
        LBSR   PSTRNG
        LDD    #$22
        LBSR   LOADCUR
        CLRB  
        LEAX   LINEBUF,U
INADR   LBSR   INCH
        CMPA   #CR
        BEQ    RETU
        CMPA   #BS
        BEQ    BACKUP
        LBSR   CLASS
        BPL    INADR
        CMPB   #4
        BEQ    INADR
        STA    B,X
        LBSR   OUTCH
        INCB
        BRA    INADR
BACKUP  TSTB
        BEQ    INADR
        DECB
        PSHS   X
        LEAX   BACKSP,PCR
        LBSR   PSTRNG
        PULS   X
        BRA    INADR
RETU    STA    B,X
        LBSR   GETHEX
        STX    VAL,U
        CLR    MODE,U
*
DUMPB   LBSR   PRNTADR
        LDB    VAL+1,U
        PSHS   B
        ANDB   #%10000000
        STB    VAL+1,U
        LDD    #$0200
        LBSR   LOADCUR
        LEAX   DUMPM,PCR
        LBSR   PSTRNG
        LDB    #16
        STB    OCOUNT,U
HLOOP1  LDB    #08
        STB    INCOUNT,U
        LDA    #CR
        LDB    #LF
        LBSR   OUT2CH
        LEAX   VAL,U
        LBSR   OUT4H
        LDA    #'-
        LBSR   OUTCH
        LDX    VAL,U
HLOOP2  LBSR   OUT2H
        LDA    #$20
        LBSR   OUTCH
        DEC    INCOUNT,U
        BNE    HLOOP2
        LDA    #$20
        LBSR   OUTCH
        LDB    #08
        STB    INCOUNT,U
        LDX    VAL,U
HLOOP3  LDA    ,X+
        LBSR   CLASS
        BEQ    GOODCH
        LDA    #$5F
GOODCH  LBSR   OUTCH
        DEC    INCOUNT,U
        BNE    HLOOP3
        STX    VAL,U
        DEC    OCOUNT,U
        BNE    HLOOP1
        LEAX   -$0080,X
        STX    VAL,U
        PULS   B
        STB    VAL+1,U
        LDD    #$1600
        LBSR   LOADCUR
        LEAX   HDIR,PCR
        LBSR   PSTRNG
*
HEXLOOP LBSR   PRNTADR
        LBSR   HPOSIT
INPUT   LBSR   INCH
        LEAX   TBLEND,PCR
        PSHS   X
        LEAX   COMTBL,PCR
HCOM    CMPA   ,X
        BEQ    FINDH
        LEAX   3,X
        CMPX   ,S
        BLO    HCOM
        LEAS   2,S
        TST    MODE,U
        BEQ    HEXXX
        LBSR   CLASS
        BNE    INPUT
        BRA    MEMMOD
*
FINDH   LEAS   2,S
        JMP    1,X       
HEXXX   LBSR   CLASS
        BPL    INPUT
        LBSR   OUTCH
        LBSR   ASCHEX
        RPT    4
        ASLA
        PSHS   A
        LBSR   INCH
        LBSR   CLASS
        BMI    HEX12
        PULS   A
        LBSR   UPDATE
        BRA    HEXLOOP
HEX12   LBSR   OUTCH
        LBSR   ASCHEX
        ADDA   ,S+
MEMMOD  LDX    VAL,U
        STA    ,X
        LBSR   UPDATE
        LDB    VAL+1,U
        INCB
        BEQ    HEXLOOP
        CMPB   #$80
        BEQ    HEXLOOP
        STB    VAL+1,U
        BRA    HEXLOOP
*
COMTBL  FCC    BS
        BRA    HLEFT
        FCC    FF
        BRA    HDOWN
        FCC    VT
        BRA    HUP
        FCC    HT
        BRA    HRIGHT
        FCC    20
        BRA    TOGGLE
        FCC    1
        BRA    CHSTART
        FCC    6
        BRA    FPAGE
        FCC    2
        BRA    BPAGE
        FCC    $1B
TBLEND  BRA    HEXIT
*
FPAGE   LDD    VAL,U
        ADDD   #$0080
        STD    VAL,U
        LBRA   DUMPB
BPAGE   LDD    VAL,U
        SUBD   #$0080
        STD    VAL,U
        LBRA   DUMPB
TOGGLE  COM    MODE,U
        LBRA   HEXLOOP
HLEFT   LDB    VAL+1,U
        DECB
        CMPB   #$7F
        LBEQ   INPUT
        CMPB   #$FF
        LBEQ   INPUT
        STB    VAL+1,U
        BSR    UPDATE
        LBRA   HEXLOOP
HRIGHT  LDB    VAL+1,U
        INCB
        LBEQ   INPUT
        CMPB   #$80
        LBEQ   INPUT
        STB    VAL+1,U
        BSR    UPDATE
        LBSR   HEXLOOP
HUP     LDB    VAL+1,U
        BMI    NEG
PLUS    SUBB   #$08
        BMI    ADD80
        BRA    OK
NEG     SUBB   #$08
        BMI    OK
ADD80   ADDB   #$80
OK      STB    VAL+1,U
        BSR    UPDATE
        LBRA   HEXLOOP
HDOWN   LDB    VAL+1,U
        BPL    DPLUS
MINUS   ADDB   #$08
        BPL    ADD80
        BRA    OK
DPLUS   ADDB   #$08
        BPL    OK
        BRA    ADD80
*
CHSTART LBRA   MEMEX1
HEXIT   LEAS   VARLEN,S
        LBSR   CLRSCR
        JMP    WARMS
*
UPDATE  LDX    VAL,U
        LDA    MODE,U
        PSHS   A
        CLR    MODE,U
        BSR    HPOSIT
        LBSR   OUT2H
        COM    MODE,U
        BSR    HPOSIT
        LDA    -1,X
        LBSR   CLASS
        BEQ    UPASC
        LDA    #$5F
UPASC   BSR    OUTCH
        PULS   A
        STA    MODE,U
        RTS
*
PRNTADR LDD    #$0022
        LBSR   LOADCUR
        LEAX   VAL,U
        LBRA   OUT4H
*
HPOSIT  LDB    VAL+1,U
        RPT    4
        LSRB
        LSLB             MULTIPLY BY 2
        ANDB   #$0F
        ADDB   #5
        PSHS   B
        LDB    VAL+1,U
        ANDB   #$F
        CMPB   #8
        BLO    POSOK
        SUBB   #8
        INC    ,S        MOVE TO NEXT ROW
POSOK
        TST    MODE,U
        BNE    ASCMOD
        LDA    #3
        MUL
        ADDB   #5
        BRA    DOLOAD
ASCMOD  ADDB   #30
DOLOAD  PULS   A
        LBRA   LOADCUR
*
******************
* LOW LEVEL SUBR.
******************
*
* ACCD = XY-POSITION
LOADCUR PSHS D
        LDD    #DARK     SL[CK CURSORN
        BSR    OUT2CH
        LDA    #$1B      ESC.
        BSR    OUTCH
        PULS   D
        ADDD   #XYOFS
        BSR    OUT2CH
        LDD    #LIT      T[ND CURSORN
        BRA    OUT2CH
*
CLRSCR  LDD    #CLSCR
        BRA    OUT2CH
*
OUT2CH  BSR    OUTCH
        TFR    B,A
OUTCH   JMP    [VOUTCH]
*
INCH    JMP    [VINCH]   *EJ EKO
*
PDAT    BSR    OUTCH
PSTRNG  LDA    ,X+
        CMPA   #4
        BNE    PDAT
        RTS
*
GETHEX  CLRA
        CLRB
        PSHS   D
        LDA    #CR
FINDCR  CMPA   B,X
        BEQ    FOUND
        INCB
        BRA    FINDCR
FOUND   TSTB
        BEQ    GETEXIT
        DECB
        LDA    B,X
        BSR    ASCHEX
        STA    1,S
        DECB
        BMI    GETEXIT
        LDA    B,X
        BSR    ASCHEX
        RPT    4
        LSLA
        ADDA   1,S
        STA    1,S
        DECB
        BMI    GETEXIT
        LDA    B,X
        BSR    ASCHEX
        STA    0,S
        DECB
        BMI    GETEXIT
        LDA    B,X
        BSR    ASCHEX
        RPT    4
        LSLA
        ADDA   ,S
        STA    ,S
GETEXIT PULS   X,PC
*
ASCHEX  SUBA   #$30
        CMPA   #9
        BLS    ASC2
        SUBA   #7
ASC2    RTS
*
CLASS   PSHS   A
        CMPA   #$7A
        BHI    NEITHER
        SUBA   #$20
        BMI    NEITHER
        SUBA   #$10
        CMPA   #9
        BLS    HEX
        SUBA   #$10
        CMPA   #6
        BLS    HEX
        ANDCC  #%11110111
        BRA    CLASS1
HEX     ORCC   #%00001000
CLASS1  SEZ
        PULS A,PC
NEITHER ANDCC #%11110011
        PULS A,PC
*
OUTHL   LSRA
        LSRA
        LSRA
        LSRA
OUTHR   ANDA   #$F
        ADDA   #'0
        CMPA   #'9
        BLS    OUTH1
        ADDA   #7
OUTH1   LBRA   OUTCH
OUT2H   LDA    ,X
        BSR    OUTHL
        LDA    ,X+
        BRA    OUTHR
OUT4H   BSR    OUT2H
        BRA    OUT2H
*
ADRPRM  FCC    'ADDRESS:****',4
DUMPM   FCC    '      0  1  2  3  4  5  6  7'
        FCB    CR
        FCB    LF
        FCC    '      8  9  A  B  C  D  E  F   ASCII'
        FCB    CR
        FCB    LF
        FCC    '      /  /  /  /  /  /  /  /  -------',4
HDIR    FCC    '^F=FORW. ^B=BACKW. ^[=Exit to FLEX'
        FCB    CR
        FCB    LF
        FCC    '^A=NEW ADDRESS. ^T=TOGGLE HEX/ASC',4
*
BACKSP  FCB    BS
        FCC    '*'
        FCB    BS
        FCB    4
*
        END    MEMEX
