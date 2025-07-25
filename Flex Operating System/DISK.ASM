        NAM     C[-837 DISK DRIVER
        OPT     PAGE
        PAG
* COPYRIGHT 1983 PERIPHERAL TECHNOLOGY
* ALL RIGHTS RESERVED
* 6809 SINGLE/DOUBLE DENSITY DRIVERS
*
* GENERAL INFORMATION
*
* TRACK 0 IS ALWAYS SINGLE DENSITY
* THERE ARE 10 SECTORS PER SIDE - SINGLE DENSITY
* THERE ARE 18 SECTORS PER SIDE - DOUBLE DENSITY
* THESE DRIVERS MAY BE USED WITH 35,40 OR 80 TRACK DRIVES
*
* WORKS WITH C[-837 DOUBLE DENSITY FLOPPY CONTROLLER
* WITH WD2797 CONTROLLER IC
*
* NOTE - NO SUPPORT FOR PRINTER SPOOLING
* IN THIS DRIVER
*
* C[-837 REGISTER EQUATES
*
DRVREG  EQU     $E014
COMREG  EQU     $E018
TRKREG  EQU     $E019
SECREG  EQU     $E01A
DATREG  EQU     $E01B
*
* WD2797 COMMAND EQUATES
*
SEEKCM  EQU     $18       SEEK COMMAND
RESTCM  EQU     $08       RESTORE COMMAND
READCM  EQU     $88       READ COMMAND
WRITCM  EQU     $A8       WRITE COMMAND
*
* DISK DRIVER JUMP TABLE
*
        ORG     $DE00
READ    JMP     READ1     READ SINGLE SECTOR
WRITE   JMP     WRIT1     WRITE SINGLE SECTOR
VERIFY  JMP     VER1      VERIFY SECTOR
RESTOR  JMP     REST1     RESTORE TO TRACK ZERO
DRVSEL  JMP     DRVS1     SELECT DRIVE
CDRRDY  JMP     CDRR1     CHECK DRIVE READY
QDRRDY  JMP     CDRR1     QUICK CHECK READY
DCOLDS  JMP     RTN       COLD START, JUST RETURN
DWARMS  JMP     RTN       WARM START, JUST RETURN
*
TCRDR   FCB     0         CURRENT DRIVE REGISTER
DRTMP   FDB     0         TEMPORARY STORAGE
TDEN    FCB     0         DENSITY FLAG OF CURRENT DRIVE
SSEL    FCB     0         SIDE FLAG OF CURRENT TRACK
TTRKRG  FCB     0,0,0,0   CURRENT TRACK REGISTER
*
*READ DISK DRIVER
*
READ1   BSR     SEEK      CHECK IF SEEK NEEDED
        ORA     #READCM   READ COMMAND
        SEI               TURN OFF INTERRUPTS
        STA     COMREG    GIVE COMMAND TO DISK
        JSR     DELAY     DELAY
READ3   LDA     DRVREG    READ FAST STATUS REGISTER
        BMI     READ4     TEST FOR DRQ?
        BEQ     READ3     TEST FOR DISK BUSY
        BRA     ERTST     NO = CHECK FOR ERRORS
READ4   LDA     DATREG    GET DATA
        STA     ,X+       WRITE IN NEXT MEMORY LOCATION
        BRA     READ3     GO GET NEXT BYTE
*
ERTST   LDB     COMREG    READ STATUS
        BITB    #$10      TEST FOR RECORD NOT FOUND (RNF)
        BNE     ER3
ER2     BITB    #$1C      ONLY TEST ERROR CONDITIONS
        CLI               ALLOW INTERRUPTS
RTN     RTS               RTS
*
* IF ERROR WAS CAUSED BY 'RECORD NOT FOUND' SEE
* IF THE ERROR WAS CAUSED BY THE USER CHANGING
* THE DISKETTE TO ONE OF OPPOSITE DENSITY.
* THIS ERROR RECOVERY IS MADE BY REVERSING THE
* DENSITY FLAG AND ALLOWING FLEX TO RE-READ THE SECTOR.
*
ER3     LDA     TDEN      CURRENT DENSITY
        EORA    #$40      TOGGLE IT
        STA     TDEN
        ORA     TCRDR     CURRENT DRIVE #
        STA     DRVREG    SET DENSITY & DRIVE#
        BRA     ER2
*
* WAIT FOR BUSY FLAG TO CLEAR
*
BUSY    LDB     COMREG    GET STATUS REGISTER
        BITB    #1        CHECK BUSY BIT
        BNE     BUSY      LOOP TILL NOT BUSY
        RTS
*
SEEK    CMPA    TRKREG    COMPARE TRACK
        BEQ     SEEK2     IF SAME DON'T SEEK
        STA     DATREG    SET UP TRACK
        JSR     DELAY
        LDA     #SEEKCM   SEEK COMMAND
        STA     COMREG    GIVE COMMAND TO DISK
        JSR     DELAY
        PSHS    B         SAVE SECTOR
        BSR     BUSY      WAIT FOR DONE
        JSR     WAIT      WAIT FOR HEAD TO SETTLE
        PULS    B         RESTORE SECTOR
SEEK2   STB     SECREG    SET SECTOR REG
        JSR     DELAY
        PSHS    B         SAVE SECTOR
        TST     TRKREG    TEST FOR TRACK 0
        BNE     SEEK3     NO
        CLR     TDEN      SET SS
        LDA     TCRDR     TRACK # SD
        STA     DRVREG
SEEK3   CLRA              SET FOR SIDE 1
        TST     TDEN      NO: TEST DENSITY FLAG
        BNE     SEEK6     DOUBLE DENSITY SIDE TEST
        CMPB    #10       IS SECTOR<10?
        BLS     SEEK5     YES: SELECT SIDE 1
SEEK4   LDA     #2        NO: SELECT SIDE 2
SEEK5   STA     SSEL      SIDE SELECT FLAG
        PULS    B         RESTORE B
        JMP     DELAY     DELAY
*
SEEK6   CMPB    #18       IS SECTOR <18 ?
        BLS     SEEK5     YES: SELECT SIDE 1
        BRA     SEEK4     NO: SELECT SIDE 2
*
* WRITE DISK DRIVER
*
WRIT1   BSR     SEEK      CHECK IF SEEK NEEDED
        ORA     #WRITCM   WRITE COMMAND
        SEI               SET INTERRUPT MASK
WRIT3   STA     COMREG    WRITE COMMAND TO REGISTER
        BSR     DELAY
        LDB     ,X+       GET FIRST DATA BYTE TO XFER
WRIT4   LDA     DRVREG    READ FAST STATUS REGISTER
        BMI     WRIT5     TEST FOR DRQ
        BEQ     WRIT4     TEST FOR DISK BUSY
        JSR     ERTST     NOT BUSY CHECK FOR ERRORS
        BITB    #$5C      MASK OUT GARBAGE BITS
        RTS
WRIT5   STB     DATREG    WRITE DATA BYTE TO 2797
        LDB     ,X+
        BRA     WRIT4     LOOP TILL ALL DATA TRANSFERRED
*
* RESTORE DISK DRIVER
*
REST1   STX     DRTMP     SAVE FCB ADDRESS IN TEMPS
        BSR     DRVS1     SELECT DRIVE
        LDA     #RESTCM   RESTORE COMMAND
        STA     COMREG    GIVE COMMAND TO DISK
        BSR     DELAY     DELAY
        JSR     BUSY      WAIT UNTIL DONE
        LDX     DRTMP     RESTORE INDEX REGISTER
        BITB    #$40      WRITE PROTECTED?
        BNE     REST2     YES: GIVE ERROR
        CLC               SET FOR NO ERROR
        RTS               RETURN
REST2   LDB     #$B       WRITE PROTECTED ERROR CODE
REST3   CLC               SET FOR NO ERROR
        RTS               RETURN
*
* DRIVE SELECT DISK DRIVER
*
DRVS1   LDA     3,X       GET DRIVE # FROM FCB
        CMPA    #3        GREATER THAN 3?
        BLS     DRVS2     IF LESS THEN 4 OKAY
        CLRA              SET FOR ZERO
DRVS2   BSR     DRVS3     SET X TO PROPER BUFFER FOR DRIVE
        LDB     TRKREG    GET TRACK
        STB     ,X        SAVE IN TEMPORARIES
        STA     TCRDR     SAVE NEW DRIVE IN CURRENT DRIVE NUMBER BYTE
        ORA     #$40      SET DD DEFAULT
        STA     DRVREG    SELECT DRIVE
        BSR     DRVS3     SET X TO PROPER BUFFER FOR DRIVE
        LDA     ,X        GET LAST TRACK AT
        STA     TRKREG    RESET TRACK REG. FOR 2797
        CLC               CLEAR ERROR FLAG
        BRA     DELAY     DELAY AND RETURN
*
DRVS3   LDX     #TTRKRG   ADDRESS OF LAST DISK ADDRESS FOR DRIVE
DRVS31  LDB     TCRDR     GET LAST USED DRIVE NUMBER
        ABX
        RTS               RETURN
*
* DELAY ROUTINE
*
DELAY   JSR     DELAY1
DELAY1  JSR     DELAY2
DELAY2  JSR     DELAY3
DELAY3  RTS
*
* WAIT 20 MILI-SECONDS
*
WAIT    PSHS    X
        LDX     #2500
WAIT1   LEAX    -1,X
        BNE     WAIT1
        PULS    X,PC
*
* CHECK DRIVE READY DISK DRIVER
*
CDRR1   LDA     3,X       GET DRIVE NUMBER
        CMPA    #1        GREATER THEN ONE (1)?
        BLS     REST3     NO: RETURN
        LDB     #$80      YES: DRIVES NOT READY ERROR
        SEC               SET ERROR FLAG
        RTS               RETURN
*
* VERIFY DISK DRIVER
*
VER1    LDA     #READCM   READ COMMAND
        SEI               SET INTERRUPT MASK
        ORA     SSEL      SIDE #
        STA     COMREG    SET READ CMD
        BSR     DELAY     DELAY
        JSR     BUSY      WAIT UNTIL ALL DONE READING
        CLI               ENABLE INTERRUPTS
        BITB    #$18      SET PROPER CODES FOR FMS
        RTS               RETURN
*
        END
