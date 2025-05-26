        NAM     SETCLOCK
********************************************************
********************************************************
** THIS PROGRAM IS USED TO INITIALLY SET THE CLOCK/   **
** AND CALENDAR   IT  MAY ALSO BE USED IF SOME TYPE   **
** OF POWER OUTAGE HAS CAUSED THE CHIP TO LOSE DATA   **
**                                                    **
**  tHE PROGRAM ASSUMES THAT THE BOARD IS INSTALLED   **
** IN PORT #4 AT ADDRESS $E010. HOWEVER IF NO BOARD   **
** IS INSTALLED THE PROGRAM WILL SO STATE AND EXIT    **
** TO FLEX GRACEFULLY.                                **
**                                                    **
**  ALL DATA MUST BE ENTERED AS TWO DECIMAL DIGITS.   **
** NUMBERS <10 SHOULD BE PREFACED WITH A '0'          **
**   AUGUST 7,2024 WOULD BE ENTERED AS FOLLOWS        **
** (YEAR ? 20)24                                      **
** (MONTH?) 08                                        **
** (DAY  ?) 07                                        **
** PRINTING IN BRACKETS ARE THE COMPUTER PROMPTS      **
** DAY OF WEEK FROM SUNDAY REFER TO NUMBER OF DAYS    **
** PAST. EX FOR THURSDAY ENTER 4  (THIS IS A SINMGLE  **
** DIGIT)                                             **
** HOUR IS IN 24 HOUR FORMAT SO 6:00 PM IS HOUR 18.   **
** SET MINUTES TO 1 OR 2 FROM PRESENT THEN TYPE ANY   **
** CHARACTER AT THIS MINUTE TO SYNC THE CLOCK.        **
**                                                    **
********************************************************
********************************************************
*
* FLEX ROUTINES
*
PSTRNG  EQU     $CD1E
GETCHR  EQU     $CD15
WARMS   EQU     $CD03
*
* EXTERNAL EQUATES
*
VERSION EQU     1
CLOCK   EQU     $E008
*
        ORG     $C100
*
* MAIN PROGRAM
*
        FCB     VERSION
TIME1   LBSR    INIT
        BCC     OK2       IF SET NO BOARD
        LEAX    NOBD,PCR
        JSR     PSTRNG    REPORT THIS
        JMP     WARMS     EXIT
OK2     LEAX    INTRO,PCR
        JSR     PSTRNG
        LEAY    BLOCK,PCR LIST OF MAX FOR EACH DIGIT
        LEAX    YEAR,PCR
        JSR     PSTRNG
        BSR     GET2
        LEAX    MONTH,PCR
        JSR     PSTRNG
        JSR     GET2
        LEAX    DAY,PCR
        JSR     PSTRNG
        JSR     GET2
        LEAX    DOW,PCR
        JSR     PSTRNG
        BSR     GET1
        LEAX    HOUR,PCR
        JSR     PSTRNG
        BSR     GET2
        LEAX    MINUTE,PCR
        JSR     PSTRNG
        BSR     GET2
        LEAX    LPYR,PCR
        JSR     PSTRNG
        JSR     GETCHR
        CMPA    #'Y
        BNE     ON1       IF LEAP YEAR SET CLOCK BIT
        LDA     DAY10
        ORA     #$4       BIT IS IN MONTH DATA
        STA     DAY10
ON1     LDA     H10       24 HOUR FORMAT ONLY
        ORA     #$8       SO SET BIT IN HOURS
        STA     H10
        LEAX    ERROR1,PCR WANT TO REDO
        JSR     PSTRNG
        JSR     GETCHR
        CMPA    #'Y
        BEQ    TIME1
        BSR     SET       PUT DATA IN CLOCK
        LEAX    START,PCR
        JSR     PSTRNG
        JSR     GETCHR    DON'T RELEASE CLOCK UNTIL TOLD TO
        CLRA
        STA     CLOCK+2   RELEASE HOLD
        JMP     WARMS
*
* SUBROUTINES
*
GET1    LDB     #1
        BRA     GET
GET2    LDB     #2
GET     JSR     GETCHR    GET TWO NUMBERS AND VERIFY LIMITS
        CMPA    #$30      THEN STORE IN DATA BLOCK
        BLT     G2ERR
        CMPA    #$39
        BGT     G2ERR
        SUBA    #$30
        CMPA    11,Y      COMPARE TO LIMIT
        BGT     G2ERR
        STA     ,Y+       THEN STORE
        DECB
        BEQ     RTN1
        BRA     GET
RTN1    RTS
G2ERR   LEAX    ERRORS,PCR
        JSR     PSTRNG
        BRA     GET
*
* SETUP PIA AND CHK FOR BOARD
*
INIT    CLRA
        STA     CLOCK+1
        STA     CLOCK+2
        COMA
        STA     CLOCK
        STA     CLOCK+2
        LDA     #$3E
        STA     CLOCK+1
        STA     CLOCK+3
        LDB     CLOCK+2
        CMPA    CLOCK+3
        BCC     OK
NFG     ORCC    #1
        BRA     RTN
OK      ANDCC   #$FE
RTN     RTS
*
* SET DATA IN CLOCK/CALENDAR
*
SET     LDA     #$80
        STA     CLOCK+2
        BSR     DELAY
ON      LDB     #$8C
        LEAX    CLOCK,PCR
DLY2    STB     CLOCK+2
        LDA     ,X+
        STA     CLOCK
        ORB     #$10
        STB     CLOCK+2
        ANDB    #$8F
        STB     CLOCK+2
        CMPB    #$80
        BEQ     ON3
        DECB
        BRA     DLY2
ON3     RTS
*
*
DELAY   PSHS    A
        LDA     #$13
DELAY1  LBRN    DELAY
        DECA
        BEQ     OVER
        BRA     DELAY1
OVER    PULS    A
        RTS
*
* STRINGS
*
INTRO   FCC     /ENTER DATE & TIME/
        FCB     4
NOBD    FCC     /NO CLOCK BOARD INSTALLED/
        FCB     4
YEAR    FCC     /YEAR? 20/
        FCB     4
MONTH   FCC     /MONTH?  /
        FCB     4
DAY     FCC     /DAY?    /
        FCB     4
DOW     FCC     /DAYS FROM SUNDAY?/
        FCB     4
HOUR    FCC     /HOUR?   /
        FCB     4
MINUTE  FCC     /MINUTE? /
        FCB     4
LPYR    FCC     /LEAP YEAR?/
        FCB     4
START   FCC     /PRESS ANY KEY TO START CLOCK>>>>>>/
        FCB     4
ERRORS  FCC     /ERROR  RE-ENTER!!!/
        FCB     4
ERROR1  FCC     /WANT TO REDO FOR MISTAKES?/
        FCB     4
*
BLOCK   EQU     *
        ORG     BLOCK
*
YR10    RMB     1
YR1     RMB     1
MO10    RMB     1
MO1     RMB     1
DAY10   RMB     1
DAY1    RMB     1
DOWK    RMB     1
H10     RMB     1
H1      RMB     1
MI10    RMB     1
MI1     RMB     1
*
MAX     FCB     9,9,1,9,3,9,6,2,9,5,9
        END     CALSET

