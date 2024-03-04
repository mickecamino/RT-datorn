        NAM    DIR - PRINT DIRECTORY CONTENT
        PAG
*****************************************************************
*  DIR - PRINT DIRECTORY CONTENT                                *
*        INCLUDING DELETED FILES.                               *
*                                                               *
* 'DIR' UTILITY WILL PRINT COMPLETE PROFILE OF DISK FILES       *
*       FILE NO., BEGIN, END TRACK AND SECTOR NUMBERS AS        *
*       WELL AS FILE SIZE, CREATION DATE AND FILE ATTRIBUTES.   *
*       FINALLY, ANY DELETED FILES WILL BE FLAGGED WITH AN (*)  *
*       ASTERISK IN FIRST CHARACTER OF FILE NAME AND 'DELETED'  *
*       MESSAGE WILL BE PRINTED AT END OF DIRECTORY LINE IF THE *
*       "DELETED FILES DISPLAY OPTION" IS SELECTED BY PLACING A *
*       ( + ) PLUS SYMBOL IN THE COMMAND LINE WHEN "DIR" IS     *
*       INVOKED.                                                *
*       FORMAT:  DIR,+  ....FOR DISPLAY OF DELETED FILES.       *
*****************************************************************
        OPT    PAG
*
* 'DIR' UTILITY COPYRIGHT (C), 1979 BY
*
*   TECHNICAL SYSTEMS CONSULTANTS, INC.
*   BOX 2570
*   WEST LAFAYETTE, INDIANA  47906
*   USA

* MODIFIED 'DIR' UTILITY BY

*   ALLEN CLARK
*   2502 REGAL OAKS LANE
*   LUTZ, FLA 33549
*   JULY 27, 1980

**   SYMBOL DEFINITIONS. (SCANDEF)

FMS     EQU    $D406     FMS CALL ENTRY
WARMS   EQU    $CD03     FLEX WARM START
GETHEX  EQU    $CD42     GET HEX VALUE
NXTCH   EQU    $CD27     GET NEXT CHARACTER
CLASS   EQU    $CD21     CLASSIFY CHARACTER
FCB     EQU    $C840     SYSTEM FCB
RPTERR  EQU    $CD3F     REPORT ERROR CONDITION
EOL     EQU    $CC02     END OF COMMAND CHARACTER
BUFPNT  EQU    $CC14     BUFFER POINTER
WASN    EQU    $CC0C     WORKING DRIVE NUMBER
* SCANDEF END

LINBUF  EQU    $C080     INPUT LINE BUFFER
PCRLF   EQU    $CD24     PRINT CR/LF
OUTDEC  EQU    $CD39     PRINT DECIMAL DIGITS
PUTCHR  EQU    $CD18     PRINT CHARACTER
PSTRNG  EQU    $CD1E     PRINT STRING
OUTHEX  EQU    $CD3C     PRING HEX DIGITS

*    SCRATCH VARIABLES

        ORG    $0
* SCANVAR
NAME    RMB    11        MATCH NAME
AF      RMB    1         "ALL FILES" FLAG
DC      RMB    1         DIRECTORY COUNT
CT      RMB    2         ENTRY COUNT
CM      RMB    2         CURRENT MATCH POINTER
WD      RMB    1         WORKING DRIVE FLAG
DS      RMB    1         DRIVE SCAN FLAG
DP      RMB    2         DRIVE POINTER
MA      RMB    2         MATCH POINTER
EC      RMB    2         END OF COMMAND POINTER
* SCANVAR END

SECS    RMB    2         SECTOR COUNT
LARG    RMB    2         LARGEST FILE SIZE
LEFT    RMB    2         SECTORS LEFT
FTOT    RMB    2         TOTAL FILES
DLFLG   RMB    1         DELETED FILES
OPTFLG  RMB    1         DELETED FILES DISPLAY FLAG
VARLEN  RMB    0

        ORG    $C100
**   MAIN PROGRAM.


DIR     BRA    DIR0      SKIP VERSION NUMBER
        FCB    4         VERSION NUMBER (4).
DIR0    LEAS   -VARLEN,S
        LEAU   0,S
        CLR    OPTFLG,U
        LDX    BUFPNT    POINT AT LINE BUFFER
DIRF    LBSR   GNC       CR OR EOL ?
        BEQ    INT0
        CMPA   #'+       DELETED FILES DISPLAY OPTION ?
        BEQ    DIRG
        BRA    DIRF
DIRG    LBSR   GNC
        STA    -2,X      RUB OUT (+) FROM BUFFER
        BNE    DIRG
        COM    OPTFLG,U  SET OPT DISP FLG

INT0    LBSR   INIT      INITIALIZE

DIR1    LBSR   SEL       SELECT NEXT DRIVE
        BCS    DIR2      IF END OF DRIVES
        LBSR   PDR       PROCESS DRIVE
        BRA    DIR1      LOOP

DIR2    JSR    PCRLF     PRINT TRAILING CR/LF
        JMP    WARMS     RETURN TO SYSTEM

**   DRIVE - PROCESS NEXT DRIVE.

DRIVE   CLRA   CLEAR VARIABLES
        CLRB
        STD    SECS,U    SECTOR COUNT
        STD    LARG,U    LARGEST FILE SIZE
        STD    FTOT,U    TOTAL FILE COUNT
        JSR    PCRLF     OUTPUT BLANK LINE
        LDA    #16       OPEN SIR
        LBSR   FMSC
DRIVE1  LBNE   FILERR    IF ERROR
        LDA    #7        GET SIR
        LBSR   FMSC
        BNE    DRIVE1    IF ERROR
        LDD    FCB+21    SAVE SECTORS LEFT
        STD    LEFT,U
        LEAX   DIRST,PCR OUTPUT TITLE
        JSR    PSTRNG    PRINT IT
        LDB    FCB+3     GET DRIVE
        CLRA
        PSHS   D
        LEAX   0,S       PRINT DRIVE
        CLRB
        JSR    OUTDEC
        LEAS   2,S
        LEAX   VST,PCR PRINT VOLUME INFORMATION
        JSR    PSTRNG
        LDX    #FCB+4    POINT TO NAME
        LDB    #8        SET COUNT
        LBSR   PDC       PRINT NAME
        LEAX   NMST,PCR  "NAME"
        LDB    #3        SET COUNT
        LBSR   PDC       PRINT IT
        LDX    #FCB+15   POINT TO NUMBER
        JSR    OUTDEC    PRINT IT
        LEAX   CSTR,PCR  "CREATED"
        LDB    #13       SET COUNT
        LBSR   PDC       PRINT STRING
        LDY    #FCB+23   POINT TO DATE
        LBSR   OUTDAT    PRINT IT
        JSR    PCRLF     PRINT CR & LF
        LEAX   HDR,PCR   PRINT COLUMN HEADERS
        JSR    PSTRNG
        JMP    PCRLF     PRINT CR & LF

**   DRVEND - END OF DRIVE PROCESSOR.

DRVEND  JSR    PCRLF     PRINT BLANK LINE
        LEAX   FST,PCR   "FILES="
        JSR    PSTRNG    PRINT IT
        CLRB
        LEAX   FTOT,U    POINT TO COUNT
        JSR    OUTDEC    PRINT FILE COUNT
        LBSR   OUTCOM    PRINT COMMA
        LEAX   SST,PCR   "SECTORS="
        LDB    #8
        LBSR   PDC       PRINT IT
        LEAX   SECS,U    POINT TO SECTOR COUNT
        JSR    OUTDEC    PRINT SECTORS
        LBSR   OUTCOM    PRINT COMMA
        LEAX   LST,PCR   "LARGEST="
        LDB    #8
        LBSR   PDC       PRINT IT
        LEAX   LARG,U    POINT TO LARGEST VALUE
        JSR    OUTDEC    PRINT LARGEST
        LBSR   OUTCOM    OUTPUT COMMA
        LEAX   FRST,PCR  "FREE="
        LDB    #5
        LBSR   PDC       PRINT IT
        CLRB
        LEAX   LEFT,U    PRINT FREE SECTOR COUNT
        JSR    OUTDEC
        JMP    PCRLF

**   GROUP - START OF NEXT MATCH GROUP.

GROUP   CLRA             CLEAR COUNTS
        CLRB
        STD    FTOT,U
        STD    SECS,U
        JMP    PCRLF     PRINT BLANK LINE

**   MATCH - PROCESS NEXT MATCHED ENTRY.

MATCH   LDA    FCB+4     GET 1st CHAR OF NAME
        BPL    MATCH0
        TST    OPTFLG,U
        LBEQ   SKIP2
MATCH0  JSR    PCRLF     START NEW LINE
        LEAX   CT,U      PRINT FILE NUMBER
        LDB    #1
        JSR    OUTDEC
        LBSR   OUT2SP    PRINT SPACES
        LDX    #FCB+4    POINT TO NAME
        LDB    #8
        LBSR   PRNAM     PRINT NAME
        LDA    #'.
        JSR    PUTCHR    OUTPUT '.'
        LDB    #3
        LBSR   PRNAM     PRINT EXT
        BSR    OUT2SP    OUTPUT SPACE
        LDA    #'P       RESET SPACE
        TST    FCB+23    CHECK SECTOR MAP
        BEQ    MATCH1    IF NO SECTOR MAP
        LDA    #'R       SET "R", RANDOM
MATCH1 JSR     PUTCHR    OUTPUT RANDOM FLAG
        BSR    OUT2SP    OUTPUT 2 SPACES
        LDX    #FCB+17   OUTPUT FIRST TRACK
        LBSR   OUTPNT
        BSR    OUT2SP
        LDX    #FCB+19   OUTPUT END
        LBSR   OUTPNT
        BSR    OUTSP
        LDX    #FCB+21
        LDB    #1
        JSR    OUTDEC    OUTPUT SIZE
        BSR    OUT2SP
        LDY    #FCB+25
        LBSR   OUTDAT    OUTPUT DATE
        BSR    OUT2SP
        LDX    #FCB      POINT TO FCB
        LDD    #'W<<8+$80 CHECK WRITE PROTECT
        BSR    OUTPR
        LDD    #'D<<8+$40 CHECK DELETE PROTECT
        BSR    OUTPR
        LDD    #'C<<8+$10 CHECK CATALOG PROTECT
        BSR    OUTPR
        TST    DLFLG,U   IS DELETED FILE FLAG SET?
        BEQ    SKIP      IF NOT, SKIP DELETED MSG
        LEAX   DELMSG,PCR POINT TO 'DELETED' MSG
        LDB    #7
        BSR    PDC
        BRA    SKIP2

SKIP    LDD    FCB+21    GET FILE SIZE
        CMPD   LARG,U    CHECK AGAINST LARGEST
        BLS    SKIP1     IF NOT LARGER
        STD    LARG,U    UPDATE LARGEST
SKIP1   ADDD   SECS,U    ADD TO SECTOR COUNT
        STD    SECS,U    UPDATE SECTOR COUNT
        INC    FTOT+1,U  COUNT FILE
        BNE    SKIP2
        INC    FTOT,U
SKIP2   CLR    DLFLG,U
        RTS

**   OUTPUT SPACE(S)

OUT2SP  BSR    OUTSP     OUTPUT FIRST SPACE
OUTSP   LDA    #'        SETUP SPACE
        JMP    PUTCHR    PRINT IT

**   PRINT FILE NAME.

PRNAM   LDA    0,X+      GET CHARACTER
        BMI    PRNAM4
        BNE    PRNAM3    IF NULL
        LDA    #'        SETUP SPACE
PRNAM3  JSR    PUTCHR    PRINT CHAR
        DECB
        BNE    PRNAM     LOOP THROUGH NAME
        RTS              RETURN
PRNAM4  LDA    #'*       LOAD AN ASTERISK (*)
        BRA    PRNAM3    PRINT IT

**   PDC - PRINT DATA UNDER COUNT CONTROL.
*    ENTRY (X)=STRING ADDRESS
*          (B)=COUNT
*    EXIT  (B)=0

PDC     LDA    0,X+      GET CHARACTER
        BEQ    PDC2      IF NULL
        JSR    PUTCHR    PRINT IT
        DECB             DEC COUNT
        BNE    PDC       LOOP THROUGH STRING
        RTS    RETURN

PDC2    CLRB
        RTS

**   OUTPR - OUTPUT PROTECTION CODE
*    ENTRY (B)=PROTECTION CODE MASK
*          (A)=LETTER TO PRINT
*          (X)=FCB ADDRESS

OUTPR   BITB   15,X      TEST BYTE
        BNE    OUTPR2
        LDA    #'        SETUP SPACE
OUTPR2  JMP    PUTCHR    PRINT CHARACTER

**   OUTD - OUTPUT DATE DIGIT.

OUTD    PSHS   A         SAVE DIGIT
        CLR    0,-S      MAKE 16 BITS WIDE
        CMPA   #9        LESS THAN 10?
        BHI    OUTD2
        BSR    OUTSP     OUTPUT SPACE
OUTD2   CLRB
        LEAX   0,S
        JSR    OUTDEC    PRINT DIGITS
        PULS   D,PC      RETURN

**   OUTPUT DATE.

OUTDAT  LDA    1,Y       GET DAY
        BSR    OUTD      PRINT IT
        BSR    OUTM      "-"
        LEAX   MNTH,PCR  POINT TO MONTH STRING
        CLRA
        LDB    0,Y       GET MONTH
        BEQ    OUTDA1
        LDA    #3        DETERMINE MONTH
        DECB
        MUL
OUTDA1  LEAX   D,X
        LDB    #3        SET COUNT
        BSR    PDC       PRINT MONTH
        BSR    OUTM      "-"
        LDA    2,Y       GET YEAR
        BRA    OUTD      PRINT IT

**   OUTCOM - PRINT COMMAND AND SPACE

OUTCOM  LDA    #',       PRINT COMMA
        JSR    PUTCHR
        BRA    OUTSP     PRINT SPACE

**   PRINT MINUS SIGN.

OUTM    LDA    #'-       SETUP '-'
        JMP    PUTCHR    PRINT IT

**   PRINT DISK ADDRESS.

OUTPNT  JSR    OUTHEX    OUTPUT DIGIT
        BSR    OUTM      PRINT '-'
        LEAX   1,X
        JMP    OUTHEX    PRINT REST

**   STRINGS

HDR     FCC    'FILE#   NAME   TYPE  R  BEGIN   END'
        FCC    '   SIZE    DATE     PRT',4
FST     FCC    '    FILES=',4
SST     FCC    'SECTORS='
LST     FCC    'LARGEST='
FRST    FCC    'FREE='
DIRST   FCC    'DIRECTORY OF DRIVE NUMBER ',4
CSTR    FCC    '    CREATED: '
VST     FCC    'DISK: ',4
NMST    FCC    '  #'
MNTH    FCC    'JANFEBMARAPRMAYJUN'
        FCC    'JULAUGSEPOCTNOVDEC'
DELMSG  FCC    'DELETED',4

**   SCAN PROCESSORS.

**   ANM - ASSEMBLE NEXT MATCH STRING.

*    EXIT  EQ IF NO MORE STRINGS
*          NE IF STRING ASSEMBLED,AND
*          (NAME)=MATCH NAME

ANM     LDX    CM,U      SET SCAN ADDRESS
        STX    BUFPNT
        LDA    0,X       CHECK CHARACTER
        CMPA   #$D
        BEQ    ANM6      IF END OF MATCHES
        CMPA   EOL
        BEQ    ANM6      IF END OF MATCHES
        LEAX   NAME,U
        LEAY   0,X
        CLRA             CLEAR NAME
        CLRB  
        STD    0,X++
        STD    0,X++
        STD    0,X++
        STD    0,X++
        STD    0,X++
        STA    0,X
        LDB    #8        SET NAME SIZE
ANM1    JSR    NXTCH     GET CHARACTER
        BCS    ANM2      IF NOT ALPHANUMERIC
        STA    0,Y+      STORE IN NAME
        DECB             COUNT CHARACTER
        BNE    ANM1      IF NOT END OF NAME
        JSR    NXTCH     GET CHARACTER
        BCC    ANM4      IF TOO LONG
ANM2    CMPA   #'.       CHECK CHARACTER
        BNE    ANM5      IF END OF MATCH STRING
        LEAY   NAME+8,U  SET EXTENSION
        LDB    #3        SET LENGTH
ANM3    JSR    NXTCH     GET CHARACTER
        BCS    ANM5      IF END OF MATCH STRING
        STA    0,Y+      STORE IN NAME
        DECB             COUNT CHARACTER
        BNE    ANM3      IF NOT END OF EXTENSION
        JSR    NXTCH     GET CHARACTER
ANM4    LBCC   SYNERR    IF TOO LONG
ANM5    LDX    BUFPNT    SET NEXT ADDRESS
        STX    CM,U
        LBSR   GROUP     CALL GROUP PROCESSOR
        ANDCC  #$FB      FORCE NE
ANM6    RTS              RETURN

**   FMSC - CALL FMS.

*    ENTRY (A)=FUNCTION NUMBER
*    EXIT  (CC)=FMS RESPONSE

FMSC    LDX    #FCB      SET FCB ADDRESS
        STA    0,X       STORE FUNCTION
        JMP    FMS       CALL FMS

**   GDE - GET DIRECTORY ENTRY.
*
*    EXIT  EQ SET IF NO MORE ENTRIES
*          NE SET IF ENTRY FOUND, AND
*          ENTRY IN FCB

GDE0    LBSR   SKIP      CALL SKIP PROCESSOR

GDE     LDA #7 GET DIRECTORY ENTRY
        BSR FMSC
        BNE GDE7 IF ERROR
        TST 4,X CHECK NAME
        BEQ GDE6 IF END OF DIRECTORY
        BPL GDE15 IF GOOD FILE
        TST OPTFLG,U DELETED FILE DISPLAY OPTION ?
        BEQ GDE IF NOT, GET NEXT ENTRY
        COM DLFLG,U ELSE, SET DELETED FILE FLAG

*  ENTRY FOUND, CHECK AGAINST MATCH

GDE15   INC    CT+1,U    COUNT ENTRY
        BNE    GDE16
        INC    CT,U
GDE16   TST    AF,U      CHECK "ALL FILES"
        BNE    GDE5      IF PROCESSING ALL
        LEAX   4,X
        LEAY   NAME,U
        LDB    #8
        TST    OPTFLG,U
        BEQ    GDE2
        LDA    ,X
        CMPA   #$FF
        BEQ    GDE5
GDE2    LDA    0,Y+      GET MATCH CHARACTER
        BEQ    GDE3      IF END OF NAME PART
        CMPA   0,X+      CHECK AGAINST ENTRY
        BNE    GDE       0 IF NO MATCH
        DECB             COUNT CHARACTER
        BNE    GDE2      LOOP THROUGH NAME
GDE3    LDX    #FCB+12    CHECK EXTENSION
        LEAY   NAME+8,U
        LDB    #3
GDE4    LDA    0,Y+      GET EXTENSION MATCH
        BEQ    GDE5      IF MATCH
        CMPA   0,X+      CHECK AGAINST ENTRY
        BNE    GDE0      IF NO MATCH
        DECB             COUNT CHARACTER
        BNE    GDE4      IF NOT END OF EXTENSION
GDE5    ANDCC  #$FB      SET "NE"
GDE6    RTS

*    CHECK ERROR.

GDE7    LDA    1,X       CHECK ERROR NUMBER
        CMPA   #8
        LBNE   FILERR    IF NOT END OF DIRECTORY
        RTS              RETURN EQ SET

**   GNC - GET NEXT CHARACTER.

*    ENTRY (X)=BUFFER POINTER
*    EXIT  (X) ADVANCED
*          (A)=CHARACTER
*          EQ SET IF END OF COMMAND

GNC     LDA    0,X+      GET CHARACTER
        CMPA   #$D
        BEQ    GNC1      IF END OF COMMAND
        CMPA   EOL
GNC1    RTS

**   SCAN INITIALIZE.

*    EXIT  (DP)=DRIVE POINTER
*          (MA)=MATCH POINTER
*          (EC)=END OF COMMAND ADDRESS
*          (DS) <> 0 IF SCANNING DRIVES
*          (AF) <> 0 IF PROCESSING ALL FILES
*          (WD) <> 0 IF USING WORK DRIVE
*          (DC) = 0

INIT    CLRA             CLEAR FLAGS
        STA    DS,U
        STA    AF,U
        STA    WD,U
        STA    DC,U
        STA    DLFLG,U
        LDX    BUFPNT    INITIALIZE POINTERS
        STX    DP,U      DRIVE POINTER
        STX    MA,U      MATCH POINTER
        STX    EC,U      END OF COMMAND

*    LOOK FOR END OF DRIVE LIST

INIT1   BSR    GNC       GET NEXT CHARACTER
        BEQ    INIT2     IF END OF COMMAND
        CMPA   #'.       CHECK CHARACTER
        BEQ    INIT2     IF END OF DRIVE LIST
        JSR    CLASS     CLASSIFY CHARACTER
        BCS    INIT1     IF SEPARATOR
        CMPA   #'9
        BLS    INIT1     IF NUMBER
INIT2   LEAX   -1,X      INDICATE MATCH LIST
        STX    MA,U

*    LOOK FOR END OF MATCH LIST.

INIT3   BSR    GNC       GET NEXT CHARACTER
        BNE    INIT3     IF NOT END OF COMMAND


*   CHECK LISTS FOR EXITENCE

INIT4   LEAX   -1,X      SET END OF COMMAND
        STX    EC,U
        CMPX   MA,U      CHECK MATCH ADDRESS
        BNE    INIT5     IF LIST EXISTS
        INC    AF,U      INDICATE "ALL FILES"
INIT5   LDX    MA,U      CHECK DRIVE LIST
        CMPX   DP,U
        BNE    INIT6     IF DRIVE LIST EXISTS
        INC    WD,U      INDICATE WORK DRIVE
INIT6   RTS              RETURN

**   PDR - PROCESS DRIVE.

*    ENTRY DRIVE NUMBER SET IN FCB

PDR     LDX    MA,U      INITIALIZE MATCH ADDRESS
        STX    CM,U
        LBSR   DRIVE     CALL USER DRIVE ROUTINE
        TST    AF,U
        BEQ    PDR1      IF NOT PROCESSING ALL FILES
        LBSR   GROUP     CALL GROUP PROCESSOR
        BRA    PDR2      PROCESS DIRECTORY

PDR1    LBSR   ANM       ASSEMBLE NEXT MATCH
        BEQ    PDR5      IF NO MORE MATCHES

*    OPEN DIRECTORY.

PDR2    LDA    #6        OPEN DIRECTORY
        LBSR   FMSC
        BNE    FILERR    IF ERROR
        CLR    CT,U      CLEAR ENTRY COUNTER
        CLR    CT+1,U

PDR3    LBSR   GDE       GET DIRECTORY ENTRY
        BEQ    PDR4      IF NO MORE ENTRIES

*  MATCH FOUND, CALL PROCESSOR

        LBSR   MATCH     CALL USER ENTRY PROCESS

        BRA    PDR3      GET NEXT ENTRY

*    END OF DIRECTORY ENCOUNTERED.

PDR4    TST    AF,U      CHECK "ALL"
        BEQ    PDR1      IF NOT PROCESSING ALL
PDR5    RTS              RETURN

**   SEL - SELECT NEXT DRIVE.

*    EXIT  CS IF NO NEXT DRIVE
*          CC IF NEXT DRIVE, AND
*          DRIVE NUMBER SET IN FCB
*          (DC) INCREMENTED

SEL     TST    DC,U      CHECK DIRECTORY COUNT
        BNE    SEL0      NOT FIRST TIME
        TST    WD,U
        BEQ    SEL2      IF DRIVE SPECIFIED
        LDA    WASN      SET WORK DRIVE
        STA    FCB+3
        BPL    SEL3      IF NOT "ALL"
        INC    DS,U      INDICATE "ALL"
        BRA    SEL1

SEL0    LBSR   DRVEND    END OF DRIVE CALL
SEL1    TST    DS,U      CHECK SCAN
        BEQ    SEL2      IF NOT SCANNING

*    SCANNING, SELECT NEXT DRIVE.

        LDA    #20       SELECT NEXT DRIVE
        LBSR   FMSC
        BNE    SEL4      IF NO MORE DRIVES
        BRA    SEL3      INDICATE FOUND

*    NOT SCANNING, ASSEMBLE DRIVE NUMBER

SEL2    LDX    DP,U      CHECK DRIVE POINTER
        CMPX   MA,U
        BEQ    SEL4      IF ALL DRIVES PROCESSED
        STX    BUFPNT
        JSR    GETHEX    ASSEMBLE DRIVE NUMBER
        BCS    SYNERR    IF ERROR IN ASSEMBLY
        TFR    X,D        MASK AND SET DRIVE
        ANDB   #3
        STB    FCB+3
        LDX    BUFPNT    UPDATE DRIVE POINTER
        STX    DP,U
SEL3    INC    DC,U      COUNT DRIVE
        CLRA             CLEAR CARRY
        RTS              RETURN

*    ALL DRIVES PROCESSED.

SEL4    LDX    EC,U      SET BUFFER POINTER
        STX    BUFPNT
        ORCC   #1        SET CARRY
        RTS              RETURN

*  PROCESS SYNTAX ERROR

SYNERR  LDX    #FCB      SET "COMMAND ERROR"
        LDA    #26
        STA    1,X
FILERR  JSR    RPTERR    REPORT ERROR
        JMP    WARMS     RETURN TO SYSTEM
* END SCANPROC

        END    DIR
