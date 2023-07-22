        NAM    EPROM
*
* AV ]KE HOLM 801117
* PROGRAMSNUTT F\R ATT FLYTTA
* INNEH]LLET I 8 ST EPROM 2516
* PÅ KORT C]-8025 TILL RAM
*
* KAN ANV[NDAS F\R ATT 
* SNABBT LADDA IN EN BASICTOLK
*
EPROM   EQU    $E0C0     EPROMKORTETS ADRESS
BEGA    EQU    $A002     TEMP LAGRING EPROMADRESS
ENDA    EQU    $A004     TEMP LAGRING RAMADRESS
SLUT    EQU    $3FFF     MAX 16 K DATA
START   EQU    $100      START ADRESS FÖR BASIC
*
*
* PROGRAMMET KAN KNAPPAS IN I RAM
* ELLER UTG\RA EN DEL AV MONITORPROGRAMMET
*
* DETTA PROGRAM G]R DIREKT TILL
* BASICTOLKENS STARTADRESS EFTER
* AVSLUTAD DATAFLYTTNING
*
        ORG    $A100     DETTA EXEMPEL [R I RAM
*
FLYTT   LDX    #0        B\RJAN AV RAM-MINNET
        STX    ENDA      SPARA TEMPOR[RT
        LDX    #0        F\RSTA ADRESSEN TILL EPROM
FLYTT2  STX    EPROM     L[GG UT TILL J3
        STX    BEGA      SPARA TILLSVIDARE
        LDA    EPROM     H[MTA DATA
        LDX    ENDA      PEKA PÅ RAM
        STA    ,X        LÄGG IN I RAM
        INX              N[STA
        STX    ENDA    
        LDX    BEGA
        INX              N[STA EPROMPOSITION
        CPX    #SLUT+1
        BNE    FLYTT2
*
KLART   JMP    START
*
        END