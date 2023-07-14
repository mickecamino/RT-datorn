        NAM    DKPGM
*
* PROGRAM F\R ATT ANVNDA DIGITALKLOCKAN
* C]-8005 TILLSAMANS MED INDIKATORKORTET C]-8005
*
* AV ]KE HOLM 1980-06-13
*
* KLOCKAN ST[LLES FR]N TANGENTERNA
* MED F\LJANDE FUNKTIONER:
* L STANNA KLOCKAN
* F SNABB INST[LLNING
* S L]NGSAM INST[LLNING
* \VRIGA STARTAR KLOCKAN
*
PIAURD  EQU    $8050     DATASIDAN
PIAURC  EQU    $8051     KONTROLLREG
PIAURS  EQU    $8052     STYRNING
URTAVL  EQU    $80E0     ADRESS TILL DISPLAY
KEY     EQU    $80E6     TANGENTAVKODARE
INFLG   EQU    $80E8     BIT=0 OM TANGENT TRYCKT
PDATA   EQU    $E07E     RUTIN I TBUG
*
        ORG    $A100
*
SETUP   CLR    PIAURC
        CLR    PIAURS+1  NOLLA KONTROLLREG
        LDA    #$F0      PA0-3 IN, PA4-7 UT
        STA    PIAURD
        LDA    #7        PB0-2 UTG]NGAR
        STA    PIAURS
        LDA    #4
        STA    PIAURC
        STA    PIAURS+1
        RTS
*
* H[R STARTAR PROGRAMMET OM TIDEN
* SKALL PRESENTERAS P] DE SEX LYS-
* DIOSINDIKATORERNA
DSPTID  BSR    SETUP
LOOP    LDA    INFLG     KNAPP TRYCKT?
        BMI    LOOP10    NIX
        LDA    KEY       H[MTA KNAPPV[RDET
        ANDA   #$1F      MASKA BIT 5-7
        CMPA   #$10
        BEQ    HOLD      STANNA KLOCKAN
        CMPA   #$0F
        BEQ    FAST      SNABB INST[LLNING
        CMPA   #$13
        BEQ    SLOW      L]MGSAM INST[LLNING
        BRA    RUN
*
HOLD    LDA    #4
        BRA   SETT
*
FAST    LDA    #1
        BRA    SETT
*
RUN     CLRA
        BRA    SETT

*
SLOW    LDA    #2
SETT    STA    PIAURS    L[GG UT STYRKOD
LOOP10  LDX    #URTAVL   PEKA P] INDIKATORERNA
        BSR    GETIME    H[MTA TIDEN
        BRA    LOOP
*
GETIME  CLRB             10-TALS TIMMAR
        BSR    URDATA
        STA    0,X
        LDB    #$10      1-TALS TIMMAR
        BSR    URDATA
        ADDA   #$80      L[GG TILL PUNKT
        STA    1,X
        LDB    #$20      10-TALS MINUTER
        BSR    URDATA
        STA    2,X
        LDB    #$60      1-TALS MINUTER
        BSR    URDATA
        ADDA   #$60      L[GG TILL PUNKT
        STA    3,X
        LDB    #$50      10-TALS SEKUNDER
        BSR    URDATA
        STA    4,X
        LDB    #$40      1-TALS SEKUNDER
        BSR    URDATA
        STA    5,X
        RTS
*
URDATA  STB    PIAURD    V[LJ SIFFRA
        BSR    RETURN    V[NTA
        LDA    PIAURD    H[MTA SIFFRAN
        ANDA   #$0F      MASKA MSB
        ADDA   #$30      G\R OM TILL ASCII
RETURN  RTS
*
* RUTIN SOM KAN ANROPAS F\R
* TIDSUTSKRIFT I EGNA PROGRAM
*
TIDST   JSR    SETUP
TIDSTR  LDX    #TIDRAM
        BSR    GETIME    L[GG IN TIDEN I RAM
        LDA    #4        EOT-KOD
        STA    8,X
        LDA    5,X
        STA    7,X
        LDA    4,X
        STA    6,X       FIXA F\R ATT F]
        LDA    3,X       PLATS MED TV] KOLON
        STA    4,X
        LDA    2,X
        STA    3,X
        LDA    #':
        STA    2,X
        STA    5,X
        JMP    PDATA     SKRIV UT TIDEN
*
TIDRAM  RMB    9         PLATS F\R TIDSANGIVELSE
*
        END    TIDST
