        NAM    Backup utility
        PAG
***************************************************
* Typed and adapted by:   Stig Boberg
*                         Rydsv{gen 112 B
*                         58248 Link|ping
* 82-06-22
***************************************************
* [ndrad av ]ke Sten{ng i jan 1983
*
* +++BACKUP                (se 1)
* +++BACKUP,+              (se 1 och 2)
* +++BACKUP,1,0            (se 1)
* +++BACKUP,.TXT,.CMD      (se 3)
* +++BACKUP,1,0,.TXT,.CMD
* +++BACKUP ............. +
* +++P,BACKUP............ (se 4)
*
* Programmet g|r backup fr}n drive A till B:
* 1. Alla TXT filer som {r {ldre p} drive B eller
*    om inte backup flaggan {r satt i originalfilen.
* 2. Alla TXT som inte finns p} drive B (fr}gar f|rst).
* 3. Upp till 8 extension kan anv{ndas.
* 4. Utskrift sker till printer f|r kopierade filer.
*
* Default {r: DRIVE A = #1, DRIVE B = #2,
* och TXT fil.
*
* DRIVE A och B finns under rubriken "Temporary data",
* och kan {ndras efter behov.
*
* Backup flaggan som s{tts i originalfilen sker i en
* ledig plats i directoryt (byte 16 i FCB).
*******************************************************
        OPT    PAG
* FLEX equates.
*
MONTH   EQU    $CC0E
DAY     EQU    $CC0F
YEAR    EQU    $CC10
EOL     EQU    $CC02
ERRTYP  EQU    $CC20
OUTSW   EQU    $CC22
PSTRNG  EQU    $CD1E
PCRLF   EQU    $CD24
GETCHR  EQU    $CD15
GETHEX  EQU    $CD42
SYSFCB  EQU    $C840
FMS     EQU    $D406
WARMS   EQU    $CD03
PUTCHR  EQU    $CD18
NXTCH   EQU    $CD27
RPTERR  EQU    $CD3F
MEMEND  EQU    $CC2B
CLOSEA  EQU    $D403

********************************************************
* Mich. constants
*
OPENDR  EQU    $06
GETIFR  EQU    $07
CLOSEF  EQU    $04
DLFILE  EQU    $0C
EOT     EQU    $04
OPENWR  EQU    $02
OPENRD  EQU    $01

********************************************************
* Program begins here.
*
        ORG    $C100     FLEX utility area

BAKUP   EQU    *
        BRA    START
        FCC    $81,'.',$85,'   S.B-].S'  Version number #1.5

********************************************************
* Temporary data, flags, pointers and the like
*
MODAY   FDB    0
YR      FCB    0
NDATA   FDB    0         End of data in buffer
YESCOP  FCB    0
FCODE   FCB    0         Function code
COFLAG  FCB    0

DRIVEA  FCB    1         "Original" drive #1 as default
DRIVEB  FCB    2         Backup drive #2 as default
********************************************************
* MAIN ROUTINE
*
START   JSR    NXTCH
        BSR    SPACO     Is it CR, EOL, Space or Comma
        CMPA   #'+
        BNE    START2
START1  STA    YESCOP    Flags for other files copy
        BRA    BAKUP1
START2  BSR    SPACO
        CMPA   #'.
        BEQ    START3
        CMPA   #'4       Only numbers!
        LBHS   ERR15
        CMPA   #'/
        LBLS   ERR15
        ANDA   #3        Only drive #0 to #3 allowed
        STA    DRIVEA
        JSR    NXTCH
        BSR    SPACO     Space or comma?
        CMPA   #'4
        LBHS   ERR15
        CMPA   #'/
        LBLS   ERR15
        ANDA   #3
        STA    DRIVEB
        BRA    START
SPACO   CMPA   #$D
        BEQ    BAKUP1
        CMPA   EOL
        BEQ    BAKUP1
        CMPA   #'        Space?
        BEQ    SPACO2
        CMPA   #',       Comma?
        BEQ    SPACO2
        RTS
SPACO2  JSR    NXTCH
        RTS
START3  LDY    #YCOPY
EXTEN   LDB    #3        Extension
EXTEN1  JSR    NXTCH
        STA    ,Y+       Move Ext to YCOPY string
        DECB
        BNE    EXTEN1
        JSR    NXTCH
        JSR    NXTCH
        CMPA   #'.
        BEQ    EXTEN
        PSHS   A
        LDA    #$F0      Set end of string mark
        STA    ,Y+
        PULS   A
        CMPA   #'+
        BEQ    START1

BAKUP1  EQU    *
        LDD    MONTH     Save system date as
        STD    MODAY     this is changed during
        LDA    YEAR      backup process
        STA    YR

BAKUP2  LDA    #01
        STA    OUTSW     Output to terminal
        BRA    BAKUP3

BAKUPM  CLR    OUTSW
        JSR    PCRLF
        INC    OUTSW
        LDX    #STMSG    "More backup (Y/N*)?"
        LBSR   PSTRN
        JSR    GETCHR
        ANDA   #$5F
        CMPA   #'Y
        BEQ    BAKUP3
        LBRA   EXIT

BAKUP3  LDX    #STMSG1   Header
        LBSR   PSTRN
        LDA    DRIVEB
        ADDA   #$30
        JSR    PUTCHR
        LDX    #STMSG2
        LBSR   PSTRN
        JSR    GETCHR
        CMPA   #$20      If space then do backup
        BEQ    OPEN
        ANDA   #$5F
        CMPA   #'E
        LBEQ   EXIT      Exit to FLEX
        BRA    BAKUP3

*********************************************************
* Open system directory and go through all names, exit
* when done.

OPEN    LDX    #SYSFCB
        LDA    DRIVEA
        STA    3,X       Force drive A
        LDA    #OPENDR
        STA    0,X
        JSR    FMS       Open sys directory
        LBSR   ERRXIT
        LDA    #GETIFR
        STA    0,X

OPEN1   LDX    #SYSFCB
        JSR    FMS
        BEQ    OPEN2
        LDB    1,X       See if error is EOF
        CMPB   #08       if so make graceful exit
        LBEQ   EXIT
        LBSR   ERRXIT    is not 08 then error
        LBRA   EXIT

OPEN2   LDA    4,X       End of sys directory
        LBEQ   BAKUPM    Job done, more?
        BMI    OPEN1     If negative then deleted
        LBSR   TYPCHK    See if type to copy
        BNE    OPEN1     Returns Z=1 if NOT ***
        LBSR   OPN4RD    If OK to backup then see
        CMPB   #$04      if file exists on backup
        BEQ    OPEN4     00=there, 04=missing
        LBSR   AGE       Returns C=1 if older
        BCC    OPEN3     Not older (C=0), next
        BRA    OPEN5     Older,do backup

OPEN3   LDA    16,X      Flags for backup
        CMPA   #1        Is it backup flag?
        BNE    OPEN5     No, do backup set flag
        LBSR   CLOSRD    clean up and
        BRA    OPEN1     try next

OPEN4   TST    YESCOP    Asks for other files copy?
        BEQ    OPEN1     No others!
        LBSR   COPYQ     Should it be copied?
        CMPA   #0        See if EQ
        LBEQ   OPEN1     If so no copy
        BRA    OPEN7     else copy file

OPEN5   TST    COFLAG
        BNE    OPEN5A
        LBSR   READA     Copy ?
        CMPA   #$D
        BEQ    OPEN5A    Yes!
        ANDA   #$5F
        CMPA   #'Y
        BEQ    OPEN5A    Yes!
        LBSR   CLOSRD    No copy wanted
        LBRA   OPEN1
OPEN5A  LBSR   CLOSRD    Close read file
        LBSR   DLTRDF    Delete old file

OPEN7   LBSR   OPNSRC    Open source file
        LBSR   DDLDATE   Move date
        LBSR   OPNDST    Open destination file
        LBSR   COPFIL    Copy and
        LBSR   CLSFLS    close both

***************************************************
* Set backupflag in original file.

BACKFL  LDX    #SYSFCB
        LDA    ,X
        STA    FCODE     Save the funtion code
        LDA    #1        Backup flag
        STA    16,X      Set backup flag
        LDA    #$0B
        STA    ,X
        JSR    FMS
        LBSR   ERRXIT
        LDA    FCODE
        STA    ,X        Restore
        LDA    #0
        STA    16,X      Restore
        LBRA   OPEN1     Loop , look for next file

*********************************************************
* Restore system date and exit. No files open at
* this point
ERR15   LDX    #SYSFCB
        LDA    #15       Error, illegal drive number
        STA    1,X
        JSR    RPTERR
EXIT    JSR    CLOSEA    Just in case!
        LDD    MODAY
        STD    MONTH
        LDA    YR
        STA    YEAR
EXIT1   JSR    NXTCH     Restore the Command line
        CMPA   #$D
        BEQ    EXIT2
        CMPA   EOL
        BNE    EXIT1
EXIT2   JMP    WARMS     OUT=======>

*********************************************************
* Check type of file and return Z=1 of not to be
* copied. Enter with X pointing to FCB to be checked.
* File extensions to be copied in list below.

TYPCHK  LEAX   12,X      Point to extension
        LDU    #YCOPY    To be copied

TYPCH1  PSHS   X,U       Save for next pass
        LDB    #03       Loop counter

TYPCH2  LDA    0,U+
        BMI    TYPCH6    End of list: Copy
        CMPA   0,X+
        BNE    TYPCH5    Not that one, loop
        DECB
        BEQ    TYPCH6    Ext in list: Now copy
        BRA    TYPCH2

TYPCH5  PULS   X,U       Restore X and U
        LEAU   3,U       Point to next entry
        BRA    TYPCH1    and try again

TYPCH6  PULS   X,U       Restore stack
        RTS

* File types to make backup from

YCOPY   FCC    /TXT/,$F0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

*********************************************************
* Open file named in directory for drive B
* Return B=04 if not there, else B=00

OPN4RD  LDX    #RDFCB+4
        LDU    #SYSFCB+4
        LBSR   COPYNM    Copy file name
        LDX    #RDFCB
        LDA    DRIVEB
        STA    3,X       Force drive B
        LDA    #OPENRD
        STA    0,X
        JSR    FMS       Open for read
        BEQ    OPN4R1    Bingo, file there
        LDB    1,X
        CMPB   #04       Not there
        BEQ    OPN4R1
        LBSR   ERRXIT    Else error
        LBRA   EXIT

OPN4R1 RTS

*********************************************************
* Compare creation dates. Returns C=1 if file
* in drive B is older then file in drive A.

AGE     LDX    #SYSFCB
        LDU    #RDFCB
        LDA    27,U      Compare year
        CMPA   27,X
        BEQ    AGE1      If equal
        BLO    YCOP      If older
        BRA    NCOP      else

AGE1    LDA    25,U
        CMPA   25,X      Try month or
        BEQ    AGE2
        BLO    YCOP
        BRA    NCOP

AGE2    LDA    26,U      as last resort
        CMPA   26,X      dates
        BHS    NCOP

YCOP    ORCC   #01       SET C=1
        RTS
NCOP    ANDCC  #$FE      SET C=0
        RTS

*********************************************************
* Close file named in RDFCB

CLOSRD  LDX    #RDFCB
        LDA    #CLOSEF
        STA    0,X
        JSR    FMS
        LBSR   ERRXIT
        RTS

*********************************************************
* Delete file named in RDFCB

DLTRDF  LDX    #RDFCB
        LDA    #DLFILE
        STA    0,X
        JSR    FMS
        LBSR   ERRXIT
        RTS

*********************************************************
* Open file named in SYSFCB, print file name

OPNSRC  LDX    #RDFCB+4
        LDU    #SYSFCB+4
        LBSR   COPYNM
        LDX    #RDFCB
        LDA    DRIVEA
        STA    3,X
        LDA    #1
        STA    0,X
        JSR    FMS
        LBSR   ERRXIT
        LDA    #-1
        STA    59,X      No space compression
        LDX    #RDFCB+4
        CLR    OUTSW
        BSR    PRNAM
        RTS

*********************************************************
* Print file name pointed to by  X
PRNAM   JSR    PCRLF
        LDB    #8
PRNAM1  LDA    ,X+
        BNE    PRNAM2
        LDA    #'
PRNAM2  JSR    PUTCHR    Print file name
        DECB
        BNE    PRNAM1
        LDA     #'.
        JSR    PUTCHR    Print extension
        BSR    GOPUT
        BSR    GOPUT
        BSR    GOPUT
        INC    OUTSW
        RTS

GOPUT   LDA    0,X+
        JSR    PUTCHR
        RTS

*********************************************************
* File missing on backup disk in drive B
* Ask if it should be copied
* Return A=0 if NO, A=-1 if YES

COPYQ   LDX    #SYSFCB+4
        BSR    PRNAM
        LDX    #PRQUEST "XXXXXXXX.XXX is not on backupdisk.."
        LBSR   PSTRN
        JSR    GETCHR
        ANDA   #$5F      Make lower case
        CMPA   #'Y
        BEQ    COPYQ1
        CMPA   #'N
        BEQ    COPYQ2
        CMPA   #$D
        BEQ    COPYQ2
        CMPA   #'E
        LBEQ   EXIT
        BRA    COPYQ

COPYQ1  INC    COFLAG
        LDA    #-1
        RTS

COPYQ2  LDA    #0
        RTS

*********************************************************
* Open backup file on drive B, use WRTFCB

OPNDST  LDX    #WRTFCB+4
        LDU    #SYSFCB+4
        LBSR   COPYNM    Copy file name
        LDX    #WRTFCB
        LDA    DRIVEB
        STA    3,X       DRIVE B
        LDA    #OPENWR
        STA    0,X       Open for write
        JSR    FMS
        LDA    #-1
        STA    59,X      No space compression
        RTS

*********************************************************
* Read the filename of drive A and ask for backup

READA   LDX    #SYSFCB+4
        LBSR   PRNAM     Print file name
        LDX    #CINFO1   ".. backup it..."
        LBSR   PSTRN
        LDA    DRIVEA
        ADDA   #$30
        JSR    PUTCHR    Print drive #A
        LDX    #CINFO2   "to drive.."
        LBSR   PSTRN
        LDA    DRIVEB
        ADDA   #$30
        JSR    PUTCHR    Print drive #B
        LDX    #CINFO3   "(Y*/N)?"
        LBSR   PSTRN
        JSR    GETCHR
        RTS

*********************************************************
* Copy file RDFCB to file WRTFCB
* Use large buffer

COPFIL  LDX    #RDFCB
        LDU    #BUFFER

* First fill buffer

COPF1   JSR    FMS
        BEQ    COPF3
        LDA    1,X
        CMPA   #08       See if EOF
        BEQ    COPF5     if so write out
        LBSR   ERRXIT
        LBRA   EXIT

COPF3   STA    0,U+
        CMPU   MEMEND    Buffer full?
        BNE    COPF1     Then write

COPF5   TST    -U        Back up past "0"
        BEQ    COPF5
        LEAU   1,U
        STU    NDATA     Mark first "0"
        LDX    #WRTFCB
        LDU   #BUFFER

* Then write buffer to drive B

COPF7   LDA    0,U+
        JSR    FMS
        BEQ    COPF9
        LDB    1,X
        LBSR   ERRXIT
        LBRA   EXIT

COPF9   CMPU   NDATA
        BNE    COPF7
        LDB    RDFCB+1   See if more to
        CMPB   #08       read from RDFCB
        BNE    COPFIL    if=08 then done
        CLR    OUTSW
        LDX    #CINFO4   ".. copied from.."
        LBSR   PSTRN
        LDA    DRIVEA
        ADDA   #$30
        JSR    PUTCHR    Print drive #A
        LDX    #CINFO5   "to drive.."
        LBSR   PSTRN
        LDA    DRIVEB
        ADDA   #$30
        JSR    PUTCHR    Print drive #B
        INC    OUTSW
        JSR    PCR       LF
CORTS   CLR    COFLAG
        RTS

*********************************************************
* Close both files (RDFCB and WRTFCB)

CLSFLS  LDB    #CLOSEF
        LDX    #RDFCB
        STB    0,X
        JSR    FMS
        LBSR   ERRXIT
        LDX    #WRTFCB
        STB    0,X
        JSR    FMS
        LBSR   ERRXIT
        RTS

*********************************************************
* Move file creation date to backup file

DDLDATE LDD    RDFCB+25
        STD    MONTH
        LDA    RDFCB+27
        STD    YEAR
        RTS

*********************************************************
* FMS Error. Report, reset system date and make
* a graceful exit to FLEX

ERRXIT  BNE    ERRX1
        RTS

ERRX1   JSR    RPTERR
        JSR    CLOSEA
        LBRA   EXIT

*********************************************************
* Copy from FCB pointed to by U to FCB pointed
* to by X

COPYNM  LDB    #11       # of char

COPYN1  LDA    0,U+
        STA    0,X+
        DECB
        BNE    COPYN1
        RTS

********************************************************
* Print strings
*
PSTRN   LDA    ,X+
        CMPA   #4
        BNE    PSTRN1
        RTS
PSTRN1  JSR    PUTCHR
        BRA    PSTRN

********************************************************
* STRINGS
*
STMSG   FCC    $07,$D,$A,'More backup? (Y/N*)? ',4
STMSG1  FCC    $D,$A,$A,'                      *** '
        FCC    'BACKUP utility ***',$D,$A,$A
        FCC    'Insert backup disk in drive ',4
STMSG2  FCC    ' and press SPACE to make backup or (E)xit ? ',4

PRQUEST FCC    '  is not on backup disk, copy it? (Y/N*/E)? ',7,4

CINFO1  FCC    '  Backup it from drive ',4
CINFO2  FCC    ' to drive ',4
CINFO3  FCC    ' (Y*/N)? ',7,4
CINFO4  FCC    '  copied from drive ',4
CINFO5  FCC    ' to drive ',4

*********************************************************
* FCB'S and data areas
*
        ORG    $0100
RDFCB   RMB    320       Read file FCB
WRTFCB  RMB    320       Write file FCB
BUFFER  RMB    0         Marks beginning of buffer

********************************************************

        END    BAKUP
