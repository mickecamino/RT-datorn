* 
*  ( MAIN.CMD )
*
* AV TBL 80-07-02 REV 1
*
* BESKRIVNING:
* -----------
*
*   MAIN ÄR ETT KOMMANDO UNDER FLEX 9.
*   FUNKTIONEN BESTÅR I ATT AVKÄNNA ÅTTA
*   OMKOPPLARE ANSLUTNA TILL EN PIA OCH
*   TÄNDA RESPEKTIVE SLÄCKA ÅTTA
*   LYSDIODER SÅ ATT DE SPEGLAR OMKOPPLARNAS
*   STATUS. DÅ SAMTLIGA ÅTTA OMKOPPLARE
*   ÄR TILL AVSLUTAS MAIN. UTSKRIFTEN "KLART"
*   SKRIVS UT OCH KONTROLLEN ÅTERGÅR TILL FLEX.
*
*
* EXTERNA REFERENSER:
* ------------------
PSTRNG  EQU     $CD1E     SKRIV UT TEXTSTRÄNG (FLEX).
WARMS   EQU     $CD03     ÅTERGÅNGSPUNKT I FLEX
*
* LOKALA REFERENSER
* -----------------
*
PSTART  EQU     $C100     PROGRAMMETS START ADRESS.
PIAACR  EQU     $E061     KONTROLLREGISTER SIDA A
PIABCR  EQU     $E063     KONTROLLREGISTER SIDA B
PIAADR  EQU     $E060     DATA REGISTER SIDA A
PIABDR  EQU     $E062     DATA REGISTER SIDA B
*
        ORG     PSTART    GE ASSEMBLERN STARTADRESSEN
START   BRA     STRT      HOPPA ÖVER NÄSTA BYTE
        FCB     1         VERSIONSNUMMER. FLEX KONVENTION
STRT    JSR     INIT      SÄTT UPP PIAN
MAIN10  JSR     OKTEST    TESTA OMKOPPLARNA
        BEQ     SLUT      TESTA OM AVSLUTA
        JSR     LIGHT     TÄND LYSDIODEN
        BRA     MAIN10
*
SLUT    JSR     FINISH    AVSLUTA
        JMP     WARMS
*
* ****************************
*                            *
*  SUBRUTIN INIT             *
*                            *
******************************
*
* BESKRIVNING:
* -----------
*   DENNA RUTIN SÄTTER UPP EN PIA MED
*   A-SIDAN SOM ÅTTA INGÅNGAR.
*   B-SIDAN SOM ÅTTA UTGÅNGAR.
*
* INDATA:
* ------
*  INGA
*
* UTDATA:
* ------
*  INGA
*
INIT    EQU     *
        CLRA              A = 0000 0000
        STA     PIAACR    VÄLJ DATARIKTNINGSREGISTRET
        STA     PIABCR    VÄLJ DATARIKTNINGSREGISTRET
        STA     PIAADR    8 INGÅNGAR PÅ A-SIDAN
        COMA              A = 1111 1111
        STA     PIABDR    8 UTGÅNGAR PÅ B-SIDAN
        LDA     #$04      ÖPPNA FÖR DATA TRANSFER
        STA     PIAACR    STÄNG RIKTNINGSREG
        STA     PIABCR          -"-
        RTS
*
*
***************************************
*                                     *
*  SUBRUTIN OKTEST                    *
*                                     *
***************************************
*
* BESKRIVNING:
*   DENNA RUTIN LÄSER AV LÄGET PÅ
*   OMKOPPLARNA 1-8. TILLSTÅNDET
*   LEVERERAS I B-ACC. BIT 0 MOTSVARAR
*   OMKOPPLARE NR 0. BITEN ÄR 1
*   OM OMKOPPLAREN ÄR TILL.
*
*
* INDATA: 
*  INGA
*
* UTDATA:
*
*  A-ACC BITMÖNSTER FÖR OMKOPPLARNA.
*  B-ACC 0 OM ALLA OMKOPPLARE I TILLÄGE.
*       1 I ÖVRIGA FALL
*
OKTEST  EQU     *
        CLRB              RETURFLAGGAN
        LDA     PIAADR    LÄS TILLSTÅNDET
        CMPA    #$FF      ÄR ALLA TILL?
        BEQ     OKT100
        INCB    B=1 EJ ALLA I TILL LÄGE
        RTS
*
OKT100  TSTB              B=0 8 TILL
        RTS
*
*
******************************
*                            *
*  SUBRUTIN LIGHT            *
*                            *
******************************
*
* BESKRIVNING:
* -----------
*    SUBRUTIN FÖR ATT TÄNDA LYSDIODERNA ANSLUTNA       
*    TILL EN PIA. 8 DIODER ÄR ANSLUTNA, VILKEN
*    SOM SKA TÄNDAS ANGES I INDATA.
*
* INDATA:
* ------
*   A-ACC BITMÖNSTER FÖR TÄNDANDE AV
*         LYSDIODERNA 1-8
*
* UTDATA:
* ------
*  INGA
*
LIGHT   EQU     *
        STA     PIABDR    TÄND DIODERNA
        RTS
*
*
*****************************
*                           *
*  SUBRUTIN FINISH          *
*                           *
*****************************
*
* BESKRIVNING:
* -----------
*  SUBRUTIN FÖR ATT SKRIVA UT TEXTEN
*  "KLART" PÅ BILDSKÄRMEN.
*
* INDATA:
* ------
*  INGA
*
* UTDATA:
* ------
*  INGA
*
* ANVÄNDA RUTINER:
* ---------------
*   PSTRNG  FLEX STRÄNGUTSKRIVARE
*
FINISH  EQU     *
        LDX     #TEXT01   "KLART"
        JSR     PSTRNG
        RTS
*
TEXT01  FCC     "KLART"   ASCII TECKEN
        FCB     $D,$A     CR+LF
        FCB     4         EOT
*
*
        END     START
