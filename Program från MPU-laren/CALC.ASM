************************************************
*   CALCULATOR   DEC,HEX,BIN--ADD,SUB,CONVERT  *
*     uses FLEX (tm) subroutines               *
*                                              *
*              By Merle Giesfeldt              *
*       ACORN COMPUTER SYSTEMS, Inc.           *
*                                              *
* SAMPLE:                                      *
*  Calc(D$%+-=) $F5E3 - %0001 1010 + D678 = $  *
*  $=xxxx                                      *
************************************************
* Ur '68' Micro Journal Volume V Issue X
* Oktober 1983, sid 39 - 40.
************************************************
* Inknappat av Ingemar Skarp}s 840329
* och testat p} RT-dator.
* Jag har {ndrat orginalets H = hex till $
*                           B = bin till %
* f|r att f|lja god programmerare sed
*
************************************************
* Giltiga kommandon:                           *
* %10101010 + %1010101 = %  (cr)               *
* %1111 1111 (svar)                            *
* %11111111 = $ (cr)                           *
* $00FF (svar)                                 *
* Du kan allts} konvertera mellan olika tal-   *
* baser och addera och subtrahera mellan tv}   *
* olika talbaser och f} svaret i den tredje    *
* talbasen.                                    *
************************************************
*
* FLEX SYSTEM DEFINED ENTRY POINTS AND EQUATES
WARMS   EQU    $CD03     FLEX WARM START ADDRESS
PUTCHR  EQU    $CD18     OUTPUT CHARACTER ROUTINE
INBUFF  EQU    $CD1B     INPUT LINE BUFFER
PSTRNG  EQU    $CD1E     PRINT STRING
NXTCH   EQU    $CD27     GET NEXT CHARACTER FROM INPUT BUFFER
OUTDEC  EQU    $CD39     OUTPUT DECIMAL NUMBER
OUTADR  EQU    $CD45     OUTPUT HEXADECIMAL ADDRESS
*
        ORG    $100
*
CALC    LDX    #MATHST   PRINT HEADING
        JSR    PSTRNG    PSTRNG FLEX
        JSR    INBUFF    INBUFF FLEX
        JSR    GETNUM    GET FIRST NUMBER
        PSHS   X         STORE IN BUFFER
*
DOMATH  CMPA   #'+       (PLUS)
        BEQ    ADD
        CMPA   #'-       (MINUS)
        BEQ    SUB
        CMPA   #'=       (EQUAL)
        BEQ    EQUAL
        BRA    QUIT      ENTRY ERROR
*
ADD     JSR GETNUM
        PSHS   A         SAVE SIGN
        TFR    X,D       PUT NUMBER I D REG
        ADDD   1,S       ADD NUMBERS
        BRA    SUB2
*
SUB     JSR GETNUM
        PSHS   A         SAVE SIGN
        LDD    1,S       PUT BUFFER I D REG
        STX    1,S       PUT NEW NUM IN BUFFER
        SUBD   1,S       SUBTRACT NUMBERS
*
SUB2    STD    1,S       SAVE ANSWER IN BUFFER
        PULS   A         GET MATH SIGN
        BRA    DOMATH
*
EQUAL   LDA    #$0A      (LINE FEED)
        JSR    PUTCHR    PUTCHR
*
EQU1    JSR    NXTCH    NXTCHR FLEX
        CMPA   #$20      (SPACE)
        BEQ    EQU1      SKIP OVER SPACES
        JSR    PUTCHR    PUTCHR FLEX
        PSHS   A         TEMP SAVE BASE CODE
        LDA    #'=
        JSR    PUTCHR    PUTCHR
        PULS   A         GET BASE CODE
        CMPA   #'$       HEX NUMBER?
        BEQ    OTHEX
        CMPA   #'%       BINARY NUMBER?
        BEQ    OTBIN
*
* OUTPUT DECIMAL IF NO BASE CODE
*
        LEAX   ,S        LOAD ADDR OF ANSWER
        CLRB             SUPPRESS LEADING ZEROS
        JSR    OUTDEC    OUTDEC FLEX
        BRA    QUIT      DONE
*
OTHEX   LEAX   ,S        LOAD ADDR OF ANSWER
        JSR    OUTADR    OUTADR FLEX
        BRA    QUIT      DONE
*
OTBIN   LEAX   ,S        LOAD ADDR OF ANSWER
        BSR    OBIN1     OUTPUT BINARY NUMBER
*
QUIT    LEAS   2,S       RESTORE STACK
        JMP    CALC      NEXT CALCULATION
*
OBIN1   BSR    OBIN2     OUTPUT FIRST BYTE
*
OBIN2   LDA    ,X+       GET BYTE
        BSR    OBIN3     OUTPUT NIBBLE
*
OBIN3   LDB    #4        BIT COUNT
*
OBIN4   LSLA             TEST BIT
        PSHS   A         TEMP SAVE BYTE
        BCC    OBIN5     IF BIT = 0
        LDA    #'1
        BRA    OBIN6
*
OBIN5   LDA    #'0
*
OBIN6   JSR    PUTCHR    PUTCHR FLEX
        PULS   A         RESTORE BYTE
        DECB             DEC BIT COUNT
        BNE    OBIN4     IF NIBBLE NOT DONE
        PSHS   A         SAVE BYTE
        LDA    #$20      (SPACE)
        JSR    PUTCHR    PUTCHR
        PULS   A         RESTORE BYTE
        RTS
*
GETNUM  JSR    NXTCH     NXTCH FLEX
        CMPA   #'X       QUIT ?
        LBEQ   WARMS     WARMST
        CMPA   #'D       DECIMAL NUMBER ?
        BEQ    DEC
        CMPA   #'$       HEX NUMBER ?
        BEQ    HEX
        CMPA   #'%       BINARY NUMBER ?
        BEQ    BIN
        CMPA   #$20      (SPACE)
        BEQ    GETNUM    SKIP SPACES
        BRA    QUIT      ENTRY ERROR
*
BIN     LDX    #$0000    CLEAR BUFFER
*
BIN2    JSR    NXTCH     NXTCH FLEX
        CMPA   #$20      (SPACE)
        BEQ    BIN2      SKIP SPACES
        CMPA   #'0       (ZERO)
        BNE    BIN3
        TFR    X,D       TRANSFER BUFFER TO D REG
        LSLB             SHIFT IN BIT
        ROLA
        TFR    D,X       SAVE IN BUFFER
        BRA    BIN2      GET NEXT BIT
*
BIN3    CMPA   #'1       (ONE)
        BNE    HEX3      IF ALL BITS ENTERED
        TFR    X,D       TRANSFER BUFFER TO D REG
        LSLB             SHIFT IN BIT
        ROLA
        ADDD   #1        MAKE BIT = 1
        TFR    D,X       SAVE D IN BUFFER
        BRA    BIN2      GET NEXT BIT
*
DEC     JSR    $CD48     INDEC FLEX
        BRA    HEX2
*
HEX     JSR    $CD42     GETHEX FLEX
*
HEX2    JSR    NXTCH     NXTCH GET SIGN
        CMPA   #$20      (SPACE)
        BEQ    HEX2      SKIP SPACES
*
HEX3    RTS
*
MATHST  FCB    $0A,$0D,$0A
        FCC "     (X=exit)",$A,$D
        FCC " Calc(D$%+-=)  ",4
*
        END CALC
