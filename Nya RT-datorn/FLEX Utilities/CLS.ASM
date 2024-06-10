        NAM     CLS
*
* Ett litet program som rensar skärmen
* Använder kontrolltecken för CÅ-815
* $ 1B + 05 - Radera skärmen + cursor home
*
OUTCH   EQU     $CD0F     FLEX OUTCH
WARMS   EQU     $CD03     FLEX WARM START
*
        ORG     $C100
START   LDA     #$1B      ESC
        JSR     OUTCH     OUTPUT CHARACTER
        LDA     #$05      CLEAR SCREEN + HOME
        JSR     OUTCH     OUTPUT CHARACTER
        JMP     WARMS     DONE - JUMP TO FLEX
        END     START     
