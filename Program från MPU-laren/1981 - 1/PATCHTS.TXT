        NAM    PATCHTS
        OPT    PAG
*PATCH AV EN BYTE I EN SPECIFICERAD TRACK O SEC
*SUNE JOHANSSON 1981,1,30
* LENNART UUSITALO
*MPU-LAREN NR.1 1981
*KOP.AV A.BRATT 81.03.21
*
* FLEX SYSTEM REFERENSER
*
WIDCNT  EQU    $AC04     TERMINAL BREDDS PARAMETER
WORKDR  EQU    $AC0C     ARBETS-DRIVE NR.
LIBUPO  EQU    $AC14     LINE BUFFER POINTER
WARMS   EQU    $AD03     WARMSTART ENTRY POINT
GETCHR  EQU    $AD15     GET CHARACTER
PUTCHR  EQU    $AD18     PUT CHARACTER
INBUFF  EQU    $AD1B     INPUT INTO LINE BUFFER
PSTRNG  EQU    $AD1E     PRINT STRING
CLASS   EQU    $AD21     CLASSIFY CHARACTER
PCRLF   EQU    $AD24     PRINT CR,LF
ADDBX   EQU    $AD36     ADD B-REG TO X-REG
OUTHEX  EQU    $AD3C     OUT 1 BYTE HEX = 2 ASCII
RPTERR  EQU    $AD3F     REPORT ERROR
GETHEX  EQU    $AD42     GET HEXADECIMAL NUMBER
FMS     EQU    $B406     FMS CALL
FCB     EQU    $A840     FCB BAS ADRESS
*
        ORG    $A100
*
SECLI   BRA    START2
VN      FCB    3
TRACK   FCB    0
SECTOR  FCB    0
BNRDAT  RMB    1         DATA I EN VISS BYTE
BYTNRP  RMB    2         BYTE POINTER
TEMPX   RMB    2
BYTENR  RMB    1         BYTENUMMER I SEKTORN
WIDD    RMB    1         TERMINAL BREDD 8/16
ADRESS  RMB    1
MAXTRA  FCB    $22
MAXSEC  FCB    $A
*
* TAG IN EN BYTE -SUBRUTIN
*
UTPINP  JSR    PSTRNG
INPBYT  JSR    INBUFF
        LDX    LIBUPO
        LDA    ,X
        CMPA   #'X       EXIT
        BEQ    EXWAR1
        JSR    GETHEX
        BCS    MARKF
        TSTB
        BEQ    MARKF
        STX    TEMPX
        TST    TEMPX
        BNE    MARKF
        LDA    TEMPX+1
        CLC
        RTS
MARKF   SEC
        RTS
ERROR1  JSR    RPTERR
EXWAR1  JMP    WARMS
START2  LDB    #16
        LDA    WIDCNT    TESTA OM BRED ELLER SMAL DUMP
        BEQ    BREDD
        CMPA   #64
        BHS    BREDD
        LDB    #$08
BREDD   STB    WIDD
        LDX    #FCB      TAG REDA P] MAX DISK-ADRESS
        LDA    WORKDR
        STA    3,X
        LDA    #3        MARKERA SECTOR 0.3
        CLR    30,X
        STA    31,X
        LDA    #9
        STA    0,X
        JSR    FMS
        LDA    102,X
        STA    MAXTRA
        LDA    103,X
        STA    MAXSEC
SECLI1  LDX    #VILTRA   VILKET SP]R
        BSR    UTPINP
        BCS    SECLI1
        CMPA   MAXTRA
        BHI    SECLI1
        STA    TRACK
SECLI2  LDX    #VILSEC   VILKEN SEKTOR ?
        BSR    UTPINP
        BCS    SECLI2
        CMPA   MAXSEC
        BHI    SECLI2
        STA    SECTOR
        LDX    #FCB      L[S AKTUELL SEKTOR
        LDA    WORKDR
        STA    3,X
        LDA    TRACK
        STA    30,X
        LDA    SECTOR
        STA    31,X
        LDA    #9
        STA    ,X
        JSR    FMS
        BNE    ERROR1
PRINT1  JSR    PCRLF     SKRIV UT DEN
        LDX    #TRA
        JSR    PSTRNG
        LDA    TRACK
        LDX    #TRACK
        JSR    OUTHEX
        LDX    #SEC
        JSR    PSTRNG
        LDX    #SECTOR
        JSR    OUTHEX
        JSR    PCRLF     SKRIV UT HUVUD
        LDX    #HUVUD1
        LDA    WIDD
        CMPA   #8
        BHI    WRITH
        LDX    #HUVUD2
WRITH   JSR    PSTRNG
        JSR    PCRLF     PRINTA UT SECTORN
        LDX    #FCB+$40  PEKA P] DATA
        CLR    ADRESS    NOLLA ADRESS R[KNARE
PRINT4  JSR    PRINT5
        TST    ADRESS
        BNE    PRINT4
BYTE2   LDX    #VILBYT   VILKEN BYTE
        JSR    UTPINP
        BCS    BYTE2
        STA    BYTENR
        LDX    #FCB+$40  TAG REDA P] POINTER
        TAB
        JSR    ADDBX
        STX    BYTNRP    SPARA POINTERN T.V.
        LDA    ,X         H[MTA DATA BYTE
        STA    BNRDAT
BYTE3   JSR    PCRLF
        LDX    #BNRDAT
        JSR    OUTHEX
        BSR    OUTS
        LDA    #'/
        JSR    PUTCHR
        BSR    OUTS
        JSR    BYTE3
        LDX    BYTNRP
        STA    ,X         SKRIV IN DET NYA V[RDET
        LDX    #FCB
        LDA    #10       LAGRA DET P] SKIVAN
        STA    ,X
        JSR    FMS
        BNE    ERRO11
        JMP    SECLI1
ERRO11  JMP    ERROR1
OUT2HS  JSR    OUTHEX    SKRIV UT 2 HEX + SPACE
OUTS    LDA    #'       '
        JMP    PUTCHR
*
* SUBR. F\R ATT SKRIVA UT EN RAD
*
PRINT5  STX    TEMPX
        LDX    #ADRESS   SKRIV UT ADRESSEN
        BSR    OUT2HS
        BSR    OUTS
        LDX    TEMPX     SKRIV UT DATA
        LDB    WIDD
PRINT6  BSR    OUT2HS
        INX
        INC    ADRESS
        BEQ    PASCII
        DECB
        BNE    PRINT6
PASCII  LDX    TEMPX     SKRIV UT ASCII
        LDB    WIDD
PRASC   LDA    ,X
        JSR    CLASS
        BCC    PRASC1
        LDA    #'.
PRASC1  JSR    PUTCHR
        INX
        DECB
        BNE    PRASC
        JMP    PCRLF     LF + RETURN
HUVUD1  FCC    "ADR 0 1 2 3 4 5 6 7 8 9 A B C D E F  ASCII"
        FCB    4
HUVUD2  FCC    "ADR 0 1 2 3 4 5 6 7  ASCII"
        FCB    4
VILTRA  FCC    "VILKEN TRACK,HEX, (0-22), EL EXIT (X) ?"
        FCB    4
VILSEC  FCC    "VILKEN SEKTOR, HEX, (0-A), EL EXIT (X) ?"
        FCB    4
VILBYT  FCC    "VILKEN BYTE ,HEX, ELLER EXIT (X)?"
        FCB    4
TRA     FCC    "TRACK"
        FCB    4
SEC     FCC    "SECTOR"
        FCB    4
        END    SECLI
