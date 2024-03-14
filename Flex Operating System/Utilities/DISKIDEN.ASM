************************************
*  DISK IDENT UTILITY C1983        *
* COMPUTER SYSTEMS CONSULTANTS     *
* 1454 LATTA LANE CONYERS GA 30207 *
************************************
        TTL    DISKIDEN
        OPT    PAG
        ORG    $C100
**
** MNEMONIC EQUATES
**
TRACKS  EQU    $00
SECTRS  EQU    TRACKS+1
SIDDEN  EQU    $02
DENSIT  EQU    SIDDEN+1
TRKSIZ  EQU    $04
SIZE58  EQU    TRKSIZ+1
REFORM  EQU    $06
FREECT  EQU    $07
FREEPT  EQU    $09
FREELS  EQU    $0B
**
STARTR BRA START1
**
VERSIN  FCB    $81,$2E,$81,$3A,$81 VERSION 1.0:1
        FCC    " DISK IDENTIFICATION "
**
** INITIALIZATION
**
START1  CLRA              RESERVE STACK SPACE
        CLRB
        PSHS   D
        PSHS   D
        PSHS   D
        PSHS   D
        PSHS   D
        PSHS   D
        PSHS   D
        PSHS   D
        TFR    S,U        POINT U-REG TO STACK
**
** GET SIR AND ASK IF CHANGES
**
GETCHG  LBSR   GETDRV     GET DRIVE AND SIR
        LEAX   QCONTN,PCR "CONTINUE?"
        LDD    #$4E59     NY
        LBSR   OUTGET
        CMPA   #$4E       N
        BEQ    FINISH
GETUPD  LDX    #SYSFCB    GET SIR
        LDA    #$09       READ SINGLE SECTOR
        STA    ,X
        LDD    #$0003     SIR ADDRESS
        STD    $1E,X
        JSR    CALFMS     CALL FMS
        LBNE   ANLBAD
        LEAX   QNEWVN,PCR "NEW "
        JSR    PSTRNG
        LEAX   QDSKNM,PCR "DISK VOLUME NAME: "
        JSR    PRTSTR
        JSR    INBUFF     GET INPUT
        LDX    #LINBUF
        LDA    ,X         CHECK FOR INPUT
        CMPA   #$20
        BLS    GETNNM
        LDY    #SYSFCB+$50 STORE IT
        LDB    #$0B
GETSNM  LDA    ,X+
        CMPA   #$20
        BHS    GETSTN
        LDA    #$20
        LEAX   -$01,X
GETSTN  STA    ,Y+
        DECB
        BNE    GETSNM
GETNNM  LEAX   QNEWVN,PCR "NEW "
        JSR    PSTRNG
        LEAX   QDSKNO,PCR "DISK VOLUME NUMBER: "
        JSR    PRTSTR
        JSR    INBUFF     GET INPUT
        LDA    LINBUF     CHECK FOR INPUT
        CMPA   #$20
        BLS    GETPUT
        JSR    GETDEC     GET NUMBER
        STX    SYSFCB+$5B STORE IT
GETPUT  LDX    #SYSFCB    PUT SIR
        LDA    #$0A       WRITE SINGLE SECTOR
        STA    ,X
        LDD    #$0003     SIR ADDRESS
        STD    $1E,X
        JSR    CALFMS     CALL FMS
        LBNE   ANLBAD
**
** NORMAL EXIT PROGRAM
**
FINISH  JSR    PRCRLF     DO CRLF
        LEAX   QFINIS,PCR "COMPLETED!"
FINIS1  JSR    PSTRNG
FINIS2  JMP    WARMST    EXIT TO FLEX
**
** ERROR EXIT
**
ERROUT  JSR    PRCRLF     DO CRLF
        LEAX   QERROR,PCR "ABORTED!"
        BRA    FINIS1
**
** GET DRIVE NUMBER
**
GETDRV  JSR    GETHEX     SCAN FOR PARAMETER ON LINE
        BCS    GETDRB
        TSTB
        BEQ    GETDRD
        TFR    X,D
        ANDB   #$03       MASK DRIVE NUMBER
GETDRF  LDX    #SYSFCB    FILL IN FCB
        STB    $03,X      DRIVE NUMBER
        BRA    ANLSIR
GETDRB  LEAX   QILLDN,PCR "ILLEGAL DRIVE NUMBER"
        LBRA   ERROUT
GETDRD  LDB    WRKDRV     TRY TO USE DEFAULT WORK DRIVE
        BPL    GETDRF
        LEAX   QNODRV,PCR "DRIVE MUST BE SPECIFIED"
        LBRA   ERROUT
**
** ANALYZE SIR PARAMETERS
**
ANLSIR  LDX    #SYSFCB    GET SIR
        LDA    #$09       READ SINGLE SECTOR
        STA    ,X
        LDD    #$0003     SIR ADDRESS
        STD    $1E,X
        JSR    CALFMS     CALL FMS
        BEQ    ANLSOK
ANLBAD  LEAX   QSIRIN,PCR "BAD SIR"
        JSR    PSTRNG
        LBRA   ERROUT     ERROR EXIT
ANLSOK  LDD    $66,X      GET MAX TRACK AND SECTOR
        STD    TRACKS,U   SAVE MAX TRACK AND SECTOR
        LDD    $5F,X      GET LAST POINTER
        STD    FREELS,U   SAVE FREE POINTER
        LDD    $5D,X      GET FREE POINTER
        STD    FREEPT,U   SAVE FREE POINTER
        BEQ    ANLFRO     ZERO OK
        TSTB              CHECK SECTOR
        BEQ    ANLBAD
        CMPB   SECTRS,U
        BHI    ANLBAD
        CMPA   TRACKS,U   TRACK
        BHI    ANLBAD
        TSTA              NON-ZERO OK
        BEQ    ANLBAD
ANLFRO  LDD    $61,X      GET FREE COUNTER
        STD    FREECT,U   SAVE FREE COUNTER
        LDD    TRACKS,U   GET MAX TRACK AND SECTOR
        LEAX   TRKSEC,PCR LOOK UP IN TABLE
ANLSIN  CMPD   ,X++
        BEQ    ANLSIX
        LEAX   $04,X
        TST    ,X
        BNE    ANLSIN
ANLSIX  LDD    ,X         GET SIDES AND DENSITY
        STD    SIDDEN,U
        LDD    $02,X      GET TRACKS AND SIZE
        STD    TRKSIZ,U
**
** PRINT DISK INFO
**
PRTDIN  LDY    #SYSFCB+$40 POINT TO SIR
        LDA    #$04       EOT
        STA    $1B,Y
        LEAX   QDSKNM,PCR "DISK VOLUME NAME: "
        JSR    PSTRNG
        LEAX   $10,Y      DISK NAME
        LBSR   PRTSTR
        LEAX   QDSKNO,PCR "DISK VOLUME NUMBER: "
        JSR    PSTRNG
        LEAX   $1B,Y      DISK NUMBER
        CLRB  
        JSR    OUTDEC
        LEAX   QCDATE,PCR "DISK CREATION DATE: "
        JSR    PSTRNG
        LEAX   $22,Y      DATE
        CLR    ,X
        CLRB
        JSR    OUTDEC
        LDA    #$2F /
        JSR    PUTCHR
        LEAX   $23,Y
        CLR    ,X
        CLRB
        JSR    OUTDEC
        LDA    #$2F /
        JSR    PUTCHR
        LEAX   $24,Y
        CLR    ,X
        CLRB
        JSR    OUTDEC
        TST    SIZE58,U   CHECK FOR FORMAT
        LBEQ   MAXTRS
        LEAX   QFORMT,PCR "DISK FORMAT: "
        JSR    PSTRNG
        LDB    TRACKS,U   TRACKS
        CLRA
        INCB
        PSHS   D
        TFR    S,X
        CLRB
        JSR    OUTDEC
        LEAX   QTRACK,PCR " TRACKS, "
        JSR    PRTSTR
        LDB    SECTRS,U   SECTORS
        STB    $01,S
        TFR    S,X
        CLRB
        JSR    OUTDEC
        PULS   D
        LEAX   QSECTR,PCR " SECTORS "
        JSR    PRTSTR
        TST    SIDDEN,U   CHECK SIDES
        BEQ    PRTDI0
        LEAX   QDBLSD,PCR ", DOUBLE-SIDED"
        JSR    PRTSTR
PRTDI0  LDA    DENSIT,U   CHECK DENSITY
        BEQ    PRTDI2
        LEAX   QDBLDN,PCR ", DOUBLE-DENSITY"
        TSTA
        BPL    PRTDI1
        LEAX   QEXTDN,PCR ", EXTRA-DENSITY"
PRTDI1  JSR    PRTSTR
PRTDI2  TST    TRKSIZ,U   CHECK TRACKS
        BEQ    PRTDI3
        LEAX   QDBLTK,PCR ", DOUBLE-TRACK"
        JSR    PRTSTR
PRTDI3  LDA    #$2C ,
        JSR    PUTCHR
        LDA    #$20
        JSR    PUTCHR
        LDA    SIZE58,U   GET SIZE
        JSR    PUTCHR
        LDA    #$22 "
        JSR    PUTCHR
        BRA    PRTFRE
MAXTRS  BSR PRTMAX        PRINT MAX TRACK/SECTOR
**
** OUTPUT FREE LIST INFO
**
PRTFRE  LEAX   QFREEC,PCR "FREE SECTORS"
        JSR    PSTRNG
        LEAX   FREECT,U
        CLRB
        JSR    OUTDEC
        LEAX   QFREEF,PCR "FREE TRACK/SECTORS: FIRST "
        JSR    PSTRNG
        LEAX   FREEPT,U
        JSR    OUTHEX
        LDA    #$2F /
        JSR    PUTCHR
        LEAX   FREEPT+1,U
        JSR    OUTHEX
        LEAX   QFREEL,PCR ", LAST "
        JSR    PRTSTR
        LEAX   FREELS,U
        JSR    OUTHEX
        LDA    #$2F /
        JSR    PUTCHR
        LEAX   FREELS+1,U
        JMP    OUTHEX
**
** PRINT MAX TRACK/SECTOR
**
PRTMAX  LEAX   QMAXTS,PCR "MAX TRACK/SECTOR"
        JSR    PSTRNG
        LEAX   TRACKS,U
        JSR    OUTHEX
        LDA    #$2F      /
        JSR    PUTCHR
        LEAX   SECTRS,U
        JMP    OUTHEX
**
** PRINT STRING POINTED TO BY X-REG
**
PRTSTR  PSHS   X,Y
PRTST1  LDA   ,X+
        CMPA  #$04
        BEQ   PRTSTX
        JSR   PUTCHR
        BRA   PRTST1
PRTSTX  PULS   X,Y,PC
**
** OUTPUT STRING AND GET RESPONSE
**
OUTGET  PSHS   X,B,A
OUTGEA  LDX    $02,S
        JSR    PSTRNG
        JSR    GETCHR
        ANDA   #$7F       MASK PARITY
        CMPA   #$03       CHECK FOR CNTRL-C
        LBEQ   FINISH
OUTGEC  CMPA   #$5F
        BLS    OUTGEU
        ANDA   #$5F       CHANGE TO UPPER CASE
OUTGEU  CMPA   ,S
        BEQ    OUTGEX
        CMPA   $01,S
        BNE    OUTGEA
OUTGEX  CMPA   ,S
        LEAS   $04,S
        RTS
**
** TRACK/SECTOR TABLE
**
TRKSEC  EQU    *          MAX TRK/SEC
        FDB    $220A,$0000,$0035 35 TRK 10 SEC 5" SSSD
        FDB    $2214,$0200,$0035 35 TRK 20 SEC 5" DSSD
        FDB    $270A,$0000,$0035 40 TRK 10 SEC 5" SSSD
        FDB    $2714,$0200,$0035 40 TRK 20 SEC 5" DSSD
        FDB    $4F0A,$0000,$0235 80 TRK 10 SEC 5" SSSD
        FDB    $4F14,$0200,$0235 80 TRK 20 SEC 5" DSSD
        FDB    $2112,$0002,$0035 34 TRK 18 SEC 5" SSDD
        FDB    $2124,$0202,$0035 34 TRK 36 SEC 5" DSDD
        FDB    $2211,$0002,$0035 35 TRK 17 SEC 5" SSDD
        FDB    $2222,$0202,$0035 35 TRK 34 SEC 5" DSDD
        FDB    $2212,$0002,$0035 35 TRK 18 SEC 5" SSDD
        FDB    $2224,$0202,$0035 35 TRK 36 SEC 5" DSDD
        FDB    $2711,$0002,$0035 40 TRK 17 SEC 5" SSDD
        FDB    $2722,$0202,$0035 40 TRK 34 SEC 5" DSDD
        FDB    $2712,$0002,$0035 40 TRK 18 SEC 5" SSDD
        FDB    $2724,$0202,$0035 40 TRK 36 SEC 5" DSDD
        FDB    $4F12,$0002,$0235 80 TRK 18 SEC 5" SSDD
        FDB    $4F24,$0202,$0235 80 TRK 36 SEC 5" DSDD
        FDB    $4C0F,$0000,$0038 77 TRK 15 SEC 8" SSSD
        FDB    $4C1E,$0200,$0038 77 TRK 30 SEC 8" DSSD
        FDB    $4C1A,$0002,$0038 77 TRK 26 SEC 8" SSDD
        FDB    $4C1D,$00F2,$0038 77 TRK 29 SEC 8" SSED
        FDB    $4C34,$0202,$0038 77 TRK 52 SEC 8" DSDD
        FDB    $4C3A,$02F2,$0038 77 TRK 58 SEC 8" DSED
TRKEND  FDB    $0000,$0000,$0000 END OF TABLE
**
QFINIS  FCC    "DISKIDEN COMPLETED!"
        FCB    $07,$04
QERROR  FCC    "DISKIDEN ABORTED!"
        FCB    $07,$04
QSIRIN  FCC    "SYSTEM INFO RECORD INVALID!"
        FCB    $07,$04
QCONTN  FCC    "CHANGE DISK NAME OR NUMBER(Y/N)? "
        FCB    $07,$04
QFREER  FCC    "FREE LIST COUNT INCORRECT!"
        FCB    $07,$04
QNEWVN  FCC    "NEW "
        FCB    $04
QDSKNM  FCC    "DISK VOLUME NAME: "
        FCB    $04
QDSKNO  FCC    "DISK VOLUME NUMBER: "
        FCB    $04
QCDATE  FCC    "DISK CREATION DATE: "
        FCB    $04
QMAXTS  FCC    "MAXIMUM TRACK/SECTOR: "
        FCB    $07,$04
QFREEC  FCC    "FREE SECTORS: "
        FCB    $04
QFREEF  FCC    "FREE TRACK/SECTORS: FIRST "
        FCB    $04
QFREEL  FCC    ", LAST "
        FCB    $07,$04
QILLDN  FCC    "ILLEGAL DRIVE NUMBER!"
        FCB    $07,$04
QNODRV  FCC    "DRIVE MUST BE SPECIFIED!"
        FCB    $07,$04
QFORMT  FCC    "DISK FORMAT: "
        FCB    $04
QTRACK  FCC    " TRACKS, "
        FCB    $04
QSECTR  FCC    " SECTORS"
        FCB    $04
QDBLSD  FCC    ", DOUBLE-SIDED"
        FCB    $04
QDBLDN  FCC    ", DOUBLE-DENSITY"
        FCB    $04
QEXTDN  FCC    ", EXTRA-DENSITY"
        FCB    $04
QDBLTK  FCC    ", DOUBLE-TRACK"
        FCB    $04
**
** FLEX ENTRY POINTS
**
LINBUF  EQU    $C080
SYSFCB  EQU    $C840
WRKDRV  EQU    $CC0C
WARMST  EQU    $CD03
GETCHR  EQU    $CD15
PUTCHR  EQU    $CD18
INBUFF  EQU    $CD1B
PSTRNG  EQU    $CD1E
PRCRLF  EQU    $CD24
NXTCHR  EQU    $CD27
OUTDEC  EQU    $CD39
OUTHEX  EQU    $CD3C
GETHEX  EQU    $CD42
OUTADR  EQU    $CD45
GETDEC  EQU    $CD48
STATUS  EQU    $CD4E
CALFMS  EQU    $D406
**
        END    STARTR
                                                                                                                            