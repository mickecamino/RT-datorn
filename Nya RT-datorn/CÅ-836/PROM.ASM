         NAM     PROM
*
* PROGRAM TO READ PROM BASED CMD-FILES
* TO RAM
* WRITTEN BY MIKAEL KARLSSON 2024-05-04
*
* BASED ON PROM.ASM FROM MPU-LAREN
* NR 2 1983, WRITTEN BY GUNNAR EJEMOH
*
* REQUIRES PROM ON CARD 836
* EPROM AT ADDRESS $E0B0, $E0C0 AND $E0D0
* RAM AT ADDRESS $E400-E4FF
*
* PROGRAM IN PROM ARE STANDARD FLEX CMD-FILES
*
* CALL THE PROGRAM WITH GET PROM
* IN STARTUP.TXT
*
* VERSION 1.0 2024-05-06
* INITIAL RELEASE
* VERSION 1.1 2024-05-07
* VERSION 1.2 2024-05-30
* VERSION 1.3 2024-06-14 
* ADDED SIGNATURE TO BE USED WITH PROMDIR.CMD
*
EPROM   EQU     $E0B0     BASE ADDRESS FOR EPROM
COMTAB  EQU     $E400     COMMAND TABLE
RAM     EQU     $E7FA     SAVE 6 BYTES FOR VARIABLES
PROMVAL EQU     2         EPROM SELECTOR
WARMS   EQU     $CD03     FLEX VARM START
SIGNTR  EQU     $E7F7     MY SIGNATURE
*
        ORG     RAM       SOME VARIABLES
PRMSTA  RMB     2         CMD-FILE START ADDRESS IN EPROM
RAMSTO  RMB     2         WHERE IN RAM SHOULD IT GO
TRNSFR  RMB     2         TRANSFER ADDRESS
*
* PUT THE ADDRESS FOR THE COMMAND TABLE INTO FLEX
*
        ORG     $CC12     HOOK INTO FLEX
        FCB     $E4       OUR TABLE IS AT $E400
*
        ORG     SIGNTR    SIGNATURE AREA
        FCC     'PMK'     SIGNATURE
*
        ORG     COMTAB    ALWAYS AT $E400
*
* ENTER ALL COMMANDS FOR THE EPROM BASED UTILS
* AFTER LAST COMMAND, ENTER A 0
*
* EACH ENTRY TAKES BETWEEN 4 AND 11 BYTES
*
        FCC     'ASN'
        FCB     0
        FDB     JMPTAB
        FCC     'CAT'
        FCB     0
        FDB     CAT
        FCC     'COPY'
        FCB     0
        FDB     COPY
        FCC     'DATE'
        FCB     0
        FDB     DATE
        FCC     'DELETE'
        FCB     0
        FDB     DELETE
        FCC     'VERIFY'
        FCB     0
        FDB     VERIFY
        FCC     'VERSION'
        FCB     0
        FDB     VERSION
        FCC     'LIST'
        FCB     0
        FDB     LIST
        FCC     'TTYSET'
        FCB     0
        FDB     TTYSET
        FCC     'NEWDISK'
        FCB     0
        FDB     NEWDISK
        FCC     'DIR'
        FCB     0
        FDB     DIR
        FCC     'DIRR'
        FCB     0
        FDB     DIRR
        FCC     'DISKIDEN'
        FCB     0
        FDB     DISKIDEN
        FCC     'APPEND'
        FCB     0
        FDB     APPEND
        FCC     'BUILD'
        FCB     0
        FDB     BUILD
        FCC     'O'
        FCB     0
        FDB     OCMD
        FCC     'SAVE'
        FCB     0
        FDB     SAVE
        FCC     'RENAME'
        FCB     0
        FDB     RENAME
        FCC     'ASMB'
        FCB     0
        FDB     ASMB
        FCC     'XBASIC'
        FCB     0
        FDB     XBASIC
        FCC     'EDIT'
        FCB     0
        FDB     EDIT
        FCC     'DEBUG'
        FCB     0
        FDB     DEBUG
        FCB     0
*
JMPTAB  EQU     *         START ADDRESSES
*
* HERE ARE ALL START ADDRESSES FOR THE PROGRAMS
* THAT ARE IN THE EPROM
* X SHOULD CONTAIN THE START ADDRESS FOR THE PROGRAM
* IN EPROM
*
* EACH ENTRY TAKES 10 BYTES
*
        PSHS    X,Y,A,B,U SAVE REGISTERS
        LDX     #$0000    START ADDRESS
        LDU     1         WHAT EPROM? 1, 2 OR 3
STORE   STX     PRMSTA    PUT IN PRMSTA
        JMP     LADDA     JUMP
*
CAT     PSHS    X,Y,A,B,U
        LDX     #$00F6
        LDU     1
        BRA     STORE
*
COPY    PSHS    X,Y,A,B,U
        LDX     #$03A8
        LDU     1
        BRA     STORE
*
DATE    PSHS    X,Y,A,B,U
        LDX     #$07DB
        LDU     1
        BRA     STORE
*
DELETE  PSHS    X,Y,A,B,U
        LDX     #$08EF
        LDU     1
        BRA     STORE
*
VERIFY  PSHS    X,Y,A,B,U
        LDX     #$0A4C
        LDU     1
        BRA     STORE
*
VERSION PSHS    X,Y,A,B,U
        LDX     #$0AE4
        LDU     1
        BRA     STORE
*
LIST    PSHS    X,Y,A,B,U
        LDU     1
        LDX     #$2000
        BRA     STORE
*
TTYSET  PSHS    X,Y,A,B,U
        LDX     #$2041
        LDU     1
        BRA     STORE
*
NEWDISK PSHS    X,Y,A,B,U
        LDX     #$23F8
        LDU     1
        BRA     STORE
*
DIR     PSHS    X,Y,A,B,U
        LDX     #$2C71
        LDU     1
        BRA     STORE
*
DIRR    PSHS    X,Y,A,B,U
        LDX     #$30BC
        LDU     1
        BRA     STORE
*
DISKIDEN PSHS    X,Y,A,B,U
        LDX     #$34FF
        LDU     1
        BRA     STORE
*
APPEND  PSHS    X,Y,A,B,U
        LDX     #$39E7
        LDU     1
        BRA     STORE
*
BUILD   PSHS    X,Y,A,B,U
        LDX     #$3C0A
        LDU     1
        LBRA    STORE     NOTE! LBRA NEEDED AS OF NOW
*
OCMD    PSHS    X,Y,A,B,U
        LDX     #$3CCB
        LDU     1
        LBRA    STORE
*
SAVE    PSHS    X,Y,A,B,U
        LDX     #$3E2F
        LDU     1
        LBRA    STORE
*
RENAME  PSHS    X,Y,A,B,U
        LDX     #$3FB6
        LDU     1
        LBRA    STORE
*
ASMB    PSHS    X,Y,A,B,U
        LDX     #$3FFA
        LDU     1
        LBRA    STORE
*
XBASIC  PSHS    X,Y,A,B,U
        LDX     #$6EDB
        LDU     1
        LBRA    STORE
*
EDIT    PSHS    X,Y,A,B,U
        LDX     #$BBA0
        LDU     1
        LBRA    STORE
*
DEBUG   PSHS    X,Y,A,B,U
        LDX     #$0000
        LDU     2         SECOND EPROM
        LBRA    STORE
*
*
LADDA   EQU     *         LOAD ROUTINE
*
LOAD1   LDX     PRMSTA    START ADDRESS IN EPROM
*
LOAD2   BSR     LESPRM    GET  1 BYTE, PUT IN A
        CMPA    #2        IS IT 02? I.E. START OF RECORD?
        BEQ     LESREC    YES, READ THE RECORD AND DATA
        CMPA    #$16      IS ITTRANSFER ADDRESS?
        BSR     LESPRM    GET TRANSFER-ADDRESS MSB
        STA     TRNSFR    SAVE MSB
        BSR     LESPRM    GET TRANSFER-ADDRESS LSB
        STA     TRNSFR+1  SAVE LSB
        PULS    X,Y,A,B,U RESTORE REGISTERS
        JMP     [TRNSFR]  AND JUMP TO START ADDRESS
*
* READ FLEX FILE RECORD
*
LESREC  BSR     LESPRM    GET RAM-ADDRESS MSB
        TFR     A,B       PUT IN B
        BSR     LESPRM    GET RAM-ADDRESS LSB
        EXG     A,B       SWAP THE TWO BYTES TO GET IT RIGHT
        STD     RAMSTO    SAVE IN RAMSTO
        BSR     LESPRM    GET NUMBER OF BYTES IN RECORD
        TFR     A,B       PUT IT IN B
*
* DONE WITH FLEX FILE RECORD
* NOW LOAD THE PROGRAM INTO RAM
*
LESRCD2 BSR     LESPRM    GET ONE BYTE
        LDY     RAMSTO    WHERE IT SHOULD BE STORED
        STA     0,Y+      SAVE IT, INCREASE Y
        STY     RAMSTO    SAVE NEXT RAM ADDRESS
        DECB              ARE WE AT 0?
        BNE     LESRCD2   NO, CONTINUE UNTIL WE ARE
        BRA     LOAD2     YES, LOOK FOR MORE RECORDS
*
* SUB ROUTINE THAT READS ONE BYTE FROM THE NEW EPROM
* CARD 836 AT ADDRESSES $E0B0, $E0C0 OR $E0D0
* IN: X-REG - ADDRESS IN EPROM TO READ FROM
*     U-REG - WHAT EPROM TO READ
*
* RETURNS: A-REG - ONE BYTE READ FROM EPROM
* 
LESPRM  CMPU    PROMVAL   WHAT EPROM SHOULD WE READ FROM
        BLO     PROM1     LESS THAN 2 = PROM #1
        BEQ     PROM2     EQUAL WITH 2 = PROM #2
        BGT     PROM3     LARGER THAN 2 = PROM #3
*
PROM1   STX     EPROM     FIRST EPROM
        LDA     EPROM     READ DATA
        BRA     LAGRA     PUT IN RAM
PROM2   STX     EPROM+$10 SECOND EPROM
        LDA     EPROM+$10 READ DATA
        BRA     LAGRA     PUT IN RAM
PROM3   STX     EPROM+$20 THIRD EPROM
        LDA     EPROM+$20 READ DATA
*
LAGRA   INX               NEXT POSITIONS
        RTS               RETURN
*
        END
