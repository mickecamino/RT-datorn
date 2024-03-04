        NAM VOXMEM.CMD
        PAG
**********************************************
* FLEX 9 UTILITY                             *
*                                            *
* VOXMEM -- A PROGRAM WHICH TALKS.           *
* THIS PROGRAM DOES A MEMORY EXAMINE,        *
* AND READS OUT BOTH THE ADDRESS AND         *
* THE CONTENTS OF EACH LOCATION.             *
*                                            *
* Vn 1.6 by ]. Sten{ng 82-01-30.             *
* Some of the routines are from other        *
* speech programs.                           *
*                                            *
* THIS PROGRAM IS WRITTEN FOR THE 'VS-1      *
* SPEAKER BOARD' FROM ALFORD AND ASSOCI-     *
* ATES, U.S.A.                               *
*                                            *
*  COMMANDS:                                 *
*  , - OUTPUT NEXT ADDRESS AND BYTE          *
*  . - OUTPUT NEXT BYTE                      *
*  / - REPEAT ADDRESS AND BYTE               *
*  N - NEW ADDRESS                           *
*  C - CONTINUOUS  BYTE-INFO, CR=STOP        *
*  ? - MENU + NEW STARTADDRESS               *
*  E - EXIT TO FLEX                          *
**********************************************
        OPT    PAG

* I/O PORT ADDRESS
PIA     EQU    $E050     VS-1 SPEAKER PORT
ACIA    EQU    $E008     TERMINAL PORT

* EQUATES
WARMS   EQU    $CD03
GETCHR  EQU    $CD15
PUTCHR  EQU    $CD18
PCRLF   EQU    $CD24
PSTRNG  EQU    $CD1E

* PROGRAM START

        ORG    $C100

START   LDX    #PIA      POINT TO THE SPEAKER PORT
        CLR    1,X       RESET DIRECTION CONTROL REGS
        CLR    3,X
        LDA    #$FF
        STA    0,X       SET BOTH SIDES FOR OUTPUTS
        STA    2,X
        LDA    #$3E      NOW SET A-SIDE CONTROL
        STA    1,X
        LDA    #$06      AND B-SIDE COANTROL
        STA    3,X
        LDA    #$3E      SEND STOP CODE TO THE SPEAKER
        STA    0,X
        LDA    #$36
        STA    1,X       STROBE
INIT1   DECA             INSURE GOOD STROBE DELAY
        BNE    INIT1     BY LOOPING OUT
        LDA    #$3E      THEN UNSTROBE
        STA    1,X
        LDA    #$83      SET MID-FINE INFL/OUTS OFF
        STA    2,X
        LDA    2,X       CLEAR PENDING OPTO-INPUTS

START2  LEAX   MSG1,PCR
        JSR    PSTRNG    PRINT MENU
START3  LEAX   MSG2,PCR
        JSR    PSTRNG    PRINT "STARTADDRESS"
        LBSR   BADDR     GET STARTING ADDRESS

* RE-ENTRY IF ADDRESS IS DESIRED

LOOP1   TFR    Y,D       MSB INTO A
        LBSR   SAY2H     SAY LEFT 2 ADDR DIG
        TFR    Y,D       NEXT ADDR AGAIN
        TFR    B,A       LSB IN A
        LBSR   SAY2H     SAY RIGHT 2 ADDR DIG
        LDX    #$B000
WAIT1   LEAX   -1,X
        BNE    WAIT1

* RE-ENTRY ON CONTENTS ONLY

LOOP2   JSR    PCRLF
        TFR    Y,D       MSB INTO A
        LBSR   OUT2H     PRINT ADDRESS
        TFR    Y,D
        TFR    B,A       LSB INTO A
        LBSR   OUT2H     PRINT LSB
        LDA    #$20      SPACE
        JSR    PUTCHR
        LDA    0,Y       GET CONTENTS
        LBSR   OUT2H     PRINT IT
        LDA    #$20      SPACE
        JSR    PUTCHR
        LDA    0,Y       GET CONTENTS AGAIN
        LBSR   SAY2H     SAY IT
        LEAY   1,Y       INCREMENT ADDRESS
        LEAX   MSG3,PCR
        BSR    PSTRN
        JSR    GETCHR    GET NEXT COMMAND
        CMPA   #',       IS IT COMMA?
        BEQ    LOOP1     ADDRESS IF YES
        CMPA   #'.       IS IT PERIOD?
        BEQ    LOOP2     DATA ONLY IF YES
        CMPA   #'/       IS IT SLASH?
        BEQ    BACKUP    YES
        CMPA   #'N       IS IT N?
        BEQ    START3    GET NEW ADDRESS
        CMPA   #'?       IS IT ?
        BEQ    START2    GET MENU AND NEW ADDRESS
        CMPA   #'C       IS IT C?
        BEQ    CONT      GET CONTINUOS BYTE
        CMPA   #'E       IS IT E?
        BEQ    EXIT
        BRA    START2
EXIT    JMP    WARMS
BACKUP  LEAY   -1,Y      REPEAT
        BRA    LOOP1

* PRINT WITHOUT CR/LF

PSTRN   LDA    ,X+
        CMPA   #4
        BNE    PSTRN1
        RTS
PSTRN1  JSR    PUTCHR
        BRA    PSTRN

* CONTINUOUS BYTES

CONT    JSR    PCRLF
        TFR    Y,D       MSB INTO A
        LBSR   OUT2H     PRINT ADDRESS
        TFR    Y,D
        TFR    B,A       LSB INTO A
        LBSR   OUT2H     PRINT LSB
        LDA    #$20      SPACE
        JSR    PUTCHR
        LDA    ,Y        GET CONTENTS
        BSR    OUT2H     PRINT IT
        LDA    #$20
        JSR    PUTCHR
        LDA    ,Y        GET CONTENTS AGAIN
        BSR    SAY2H     SAY IT
        LEAY   1,Y
        LDX    #$B000    DELAY
WAIT    LEAX   -1,X
        BNE    WAIT
        LDA    ACIA    CHECK IF ANY KEY'S BEEN HIT
        LSRA
        BCC    CONT      NO, SAY MORE BYTE
        LDA    ACIA+1    A KEY HAS BEEN HIT
        ANDA   #$7F      MASK PARITY
        CMPA   #$0D      IS IT CR?
        BEQ    CONT2     YES, GO TO STOP
        BRA    CONT      SAY MORE BYTE
CONT2   LEAX   MSG4,PCR
        BSR    PSTRN
GET     JSR    GETCHR    GET CHAR
        CMPA   #'N       IS IT N?
        LBEQ   START3    GET NEW ADDRESS
        CMPA   #'E       IS IT E?
        BEQ    EXIT      TO FLEX
        BRA    CONT

* SAY 2 HEX ROUTINE

SAY2H   PSHS   A,Y       SAVE BYTE
        LSRA
        LSRA
        LSRA             MOVE MSB RIGHT
        LSRA
        BSR    SAY1H     SAY LEFT DIGIT
        PULS   A
        ANDA   #$0F      MASK RIGHT
        BSR    SAY1H     SAY RIGHT DIGIT
        PULS   Y
        RTS

* SAY 1 HEX ROUTINE

SAY1H   ASLA             MULTIPLY BY 2
        LEAY   WTABLE-HERE1,PC POINT TO WORD TABLE
HERE1   LEAY   A,Y       POINT TO WORD POINTER
        LDD    0,Y       GET POINTER
        LEAY   START-HERE2,PC POINT TO PGM START
HERE2   LEAY   D,Y       POINT TO WORD

OUT     LDA    0,Y+
        CMPA   #$FF
        BNE    OUT1
        RTS
OUT1    BSR    LOOP
        BRA    OUT

* SEND PHONEME

LOOP    LDX    #PIA
        TST    1,X       CHECK FOR PORT READY
        BPL    LOOP      LOOP IF NOT
        TST    0,X       ELSE CLEAR FLAG
        STA    0,X       SEND PHONEME
        LDA    #$36      STROBE THE DATA
        STA    1,X
LOOPS   DECA             INSURE POSITIVE STROBE
        BNE    LOOPS
        LDA    #$3E
        STA    1,X       UNSTROBE THE DATA
        RTS

* PRINT 2 HEX ROUTINE

OUT2H   PSHS   A         SAVE BYTE
        LSRA
        LSRA
        LSRA             MOVE MSB RIGHT
        LSRA
        BSR    OUT1H
        PULS   A

OUT1H   ANDA   #$0F      MASK RIGHT
        ADDA   #'0
        CMPA   #'9
        BLS    OUTEX     OUTPUT IF <10
        ADDA   #$7       CONVERT FOR A-F
OUTEX   JMP    PUTCHR

* BUILD ADDRESS ROUTINE

BADDR   BSR    BYTE      GET LS BYTE
        PSHS   A
        BSR    BYTE      GET LS BYTE
        TFR    A,B
        PULS   A         COMBINE
        TFR    D,Y       MOVE INTO Y
        RTS
* INPUT ONE BYTE
BYTE    BSR    INHEX     GET MS DIGIT
        ASLA
        ASLA
        ASLA
        ASLA
        PSHS   A         SAVE DIGIT
        BSR    INHEX     GET LS DIGIT
        ADDA   0,S+      ADD B TO A
        RTS
* INPUT ONE DIGIT
INHEX   JSR    GETCHR    GET DIGIT
        SUBA   #$30
        BMI    INHEX     REPEAT IF NG
        CMPA   #$9
        BLE    IHEXIT
        CMPA   #$11
        BMI    INHEX     REPEAT IF NG
        CMPA   #$16
        BGT    INHEX     REPEAT IF NG
        SUBA   #7        CONVERT IF OK
IHEXIT  RTS

* WORD STARTING ADDRESS TABLE

WTABLE  FDB    ZEREO-START
        FDB    ONE-START
        FDB    TWO-START
        FDB    THREE-START
        FDB    FOUR-START
        FDB    FIVE-START
        FDB    SIX-START
        FDB    SEVEN-START
        FDB    EIGHT-START
        FDB    NINE-START
        FDB    A-START
        FDB    B-START
        FDB    C-START
        FDB    D-START
        FDB    E-START
        FDB    F-START

* WORD TABLE (PHONEME)
ZEREO   FCB    $92,$4B,$6B,$63,$75,$7E,$FF
ONE     FCB    $6D,$72,$71,$4D,$4D,$7E,$FF
TWO     FCB    $AA,$76,$68,$7E,$FF
THREE   FCB    $B9,$AB,$7C,$69,$7E,$FF
FOUR    FCB    $9D,$66,$66,$6B,$7E,$FF
FIVE    FCB    $5D,$63,$55,$7C,$4F,$7E,$FF
SIX     FCB    $9F,$4B,$59,$5F,$7E,$FF
SEVEN   FCB    $9F,$42,$4F,$40,$4D,$7E,$FF
EIGHT   FCB    $46,$61,$A2,$EA,$EA,$7E,$FF
NINE    FCB    $8D,$55,$49,$69,$4D,$7E,$FF
A       FCB    $80,$46,$61,$7E,$FF
B       FCB    $8E,$7C,$7C,$7E,$FF
C       FCB    $9F,$7C,$7C,$7E,$FF
D       FCB    $DE,$DE,$DE,$7C,$7C,$7E,$FF
E       FCB    $6C,$6C,$7E,$FF
F       FCB    $46,$5D,$5D,$7E,$FF

* MESSAGE STRINGS
MSG1    FCC    $D,$A,'*** VOXMEM  Vn 1.6 by ]. Sten{ng 1982 ***',$D,$A
        FCC    $D,$A,'COMMANDS:',$D,$A
        FCC    '  , - OUTPUT NEXT ADDRESS AND BYTE',$D,$A
        FCC    '  . - OUTPUT NEXT BYTE',$D,$A
        FCC    '  / - REPEAT ADDRESS AND BYTE',$D,$A
        FCC    '  N - NEW ADDRESS',$D,$A
        FCC    '  C - CONTINUOUS BYTE-INFO, CR=STOP',$D,$A
        FCC    '  ? - MENU + NEW STARTADDRESS',$D,$A
        FCC    '  E - EXIT TO FLEX',4
MSG2    FCC    $D,$A,$A,'STARTADDRESS ?',$D,$A
        FCC    '>',4
MSG3    FCC    ' COMMAND ? ',4
MSG4    FCC    ' (CR)=STOP-CONTINUE, (N)EW ADDRESS, (E)XIT TO FLEX ? ',4

        END    START
