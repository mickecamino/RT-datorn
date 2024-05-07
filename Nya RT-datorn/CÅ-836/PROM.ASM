         NAM     PROM
*
* PROGRAMMET L[SER NED PROMBASERADE CMD-FILER
* TILL RAM
* SKRIVET AV MIKAEL KARLSSON 2024-05-04
*
* BASERAT P] PROM.ASM UR MPU-LAREN
* NR 2 1983, SKRIVET AV GUNNAR EJEMOH
*
* F\RUTS[TTER PROM P] KORT 836
* EPROM P] $E0B0, $E0C0 och $E0D0
* RAM P] ADRESS $E400-E4FF
*
* PROGRAMMET I PROM [R STANDARD CMD-FILER
*
* KALLA UPP PROGRAMMET MED GETPROM
* I STARTUP.TXT
*
* VERSION 1.0 2024-05-06
* VERSION 1.1 2024-05-07
*
EPROM   EQU     $E0B0     BASADRESS F\R EPROM
COMTAB  EQU     $E400     KOMMANDO-TABELLEN
JMPTAB  EQU     $E500     HOPP-TABELLEN
LADDA   EQU     $E700     SJ[LVA PROGRAMMET
RAM     EQU     JMPTAB+$F0 PLATS F\R VARIABLER
PROMVAL EQU     2         EPROMV[LJARE
WARMS   EQU     $CD03     FLEX VARMSTART
*
        ORG     RAM       LITE VARIABLER
PRMSTA  RMB     2         CMD-FILENS STARTDARESS I EPROMET
RAMSTO  RMB     2         VART I RAM DET SKA SPARAS
TRNSFR  RMB     2         TRANSFERADRESS
*
* L[GG IN ADRESS TILL KOMMANDOTABELL I FLEX
*
        ORG     $CC12     HAKA P] I FLEX
        FCB     $E4       TABELL I RAM P] $E400
*
        ORG     COMTAB
* H[R SKRIVS ALLA KOMMANDON IN SOM LIGGER I PROM
* EFTER SISTA KOMMANDOT SKRIVS 0
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
        ORG     JMPTAB
*
* H[R FINNS STARTADRESSER TILL ALLA PROGRAMEN
* SOM [R LAGRADE I EPROM
* X SKA INNEH]LLA STARTADRESSEN F\R PROGRAMMET
* I EPROMET
*
        PSHS    X,Y,A,B,U SPARA UNDAN REGISTER
        LDX     #$0000    STARTADRESSEN
        LDU     1         VILKET EPROM?
STORE   STX     PRMSTA    L[GG I PRMSTA
        JMP     LADDA     HOPPA
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
        LBRA    STORE     NOT! LBRA BEH\VS FR.O.M NU
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
        LDU     2         ANDRA EPROMET
        LBRA    STORE
*
*
        ORG     LADDA
*
LOAD1   LDX     PRMSTA    STARTADRESSEN I EPROM
*
LOAD2   BSR     LESPRM    H[MTA 1 BYTE, L[GG I A
        CMPA    #2        [R DET 02? DVS. START OF RECORD?
        BEQ     LESREC    JA; L[S D] IN RECORDET OCH DATA
        CMPA    #$16      [R DET TRANSFER ADRESS?
        BSR     LESPRM    H[MTA TRANSFER-ADRESSEN MSB
        STA     TRNSFR    SPARA MSB
        BSR     LESPRM    H[MTA TRANSFER-ADRESSEN LSB
        STA     TRNSFR+1  SPARA LSB
        PULS    X,Y,A,B,U ]TERST[LL REGISTER
        JMP     [TRNSFR]  OCH HOPPA TILL STARTADRESSEN
*
* L[S FLEX FILE RECORD 
*
LESREC  BSR     LESPRM    H[MTA RAM-ADRESSEN MSB
        TFR     A,B       LAGRA I B
        BSR     LESPRM    H[MTA RAM-ADRESSEN LSB
        EXG     A,B       V[ND P] DET S] DET BLIR R[TT
        STD     RAMSTO    SPARA I RAMSTO
        BSR     LESPRM    H[MTA ANTAL BYTES I RECORD
        TFR     A,B       LAGRA DET I B
*
* KLART MED FLEX FILE RECORD
* LADDA NU NER PROGRAMMET FR]N EPROM TILL RAM
*
LESRCD2 BSR     LESPRM    H[MTA EN BYTE FR]N PROGRAMMET
        LDY     RAMSTO    VAR SKA DET SPARAS?
        STA     0,Y+      SPARA DET I MINNET, \KA Y
        STY     RAMSTO    SPARA N[STA ADRESS
        DECB              [R VI NERE P] 0?
        BNE     LESRCD2   NEJ; FORTS[TT TILLS VI [R DET.
        BRA     LOAD2     JA, LETA EFTER FLER RECORDS
*
* SUBRUTIN SOM L[SER EN BYTE FR}N DET NYA EPROM-
* KORTET 836 P} ADRESS $E0B0, $E0C0 ELLER $E0D0
* IN: X-REG - ADRESSEN I EPROM ATT L[SA FR]N
*     U-REG - VILKET EPROM SOM SKA L[SAS
*
* RETURNERAR: A-REG - EN BYTE DATA FR]N EPROMET
* 
LESPRM  CMPU    PROMVAL   VILKET EPROM SKA ANV[NDAS
        BLO     PROM1     MINDRE [N 2 = PROM #1
        BEQ     PROM2     LIKA MED 2 = PROM #2
        BGT     PROM3     ST\RRE [N 2 = PROM #3
*
PROM1   STX     EPROM     F\RSTA EPROMET
        LDA     EPROM     L[S DATA
        BRA     LAGRA     LAGRA I RAM
PROM2   STX     EPROM+$10 ANDRA EPROMET
        LDA     EPROM+$10 L[S DATA
        BRA     LAGRA     LAGRA I RAM
PROM3   STX     EPROM+$20 TREDJE EPROMET
        LDA     EPROM+$20 L[S DATA
*
LAGRA   INX               N[STA POSITION
        RTS               ]TERG]
*
        END
