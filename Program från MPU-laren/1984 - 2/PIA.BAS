1 REM Programinitiering av PIA
2 REM Inknappat A.Bratt
3 REM Ur MPU-laren nr.2 1984
4 REM 
5 REM GENE EMBRY
6 REM 9/28/80
7 REM
11 REM
15 GOSUB 4010:REM CLEAR + HOME
20 GOSUB 9800: REM TO INITIALIZE THE PROGRAM VARIABLES
99 REM
100 REM MAIN SECTION
101 REM
110 GOSUB 4020: REM DO HOME
112 PRINT TAB(W-LEN(T$)/2);T$
114 PRINT
116 PRINT TAB(5);"This program will assist you to determine the code"
118 PRINT "necessary to initialize a PIA device. We assume that the"
120 PRINT "SWTPC configuration for the PIA is used.":PRINT
122 INPUT "What is the memory location of CRA ";A$
130 INPUT "Will Side A of PIA be used";Q$
132 IF Q$="n" THEN Q$="N"
134 IF Q$="N" THEN 200
150 LET P$=A$
152 LET P$="$"+P$+' Clear out control register'
154 LET C$="CLR ":GOSUB 8000: REM Print a line of code
156 LET S$="A": IF F1 <> 0 THEN S$="B"
160 GOSUB 1000: REM Determine how the side will be used.
162 LET C$="LDA":GOSUB 8000: REM Print a line
166 LET O$="-1":IF F1 <> 0 THEN O$="+1"
168 LET C$="STA":P$="$"+A$+O$:GOSUB 8000
170 GOSUB 2000:REM Configure CA1 (CB1)
180 GOSUB 3000:REM Configure CA2 (CB2)
182 LET P$="#%"+LEFT$(P,4)+"-"+RIGHT$(P$,4)+"    Note configuration"
184 LET C$="LDA A":GOSUB 8000
186 LET O$="":IF F1 <> 0 THEN O$="+2"
188 LET C$="STA A":P$="$"+A$+O$:GOSUB 8000
190 IF F1<> 0 THEN 900:REM Done
199 REM
200 REM Check for Side B configuration.
201 REM
210 IF F1=0 THEN GOSUB 9700:REM Might want to configure Side B
220 IF F1=2 THEN 900:REM Side B will not be used
230 LET P$=A$+"+2"
240 GOTO 152:REM Configure Side B
299 REM
900 REM FINISHED
901 REM
970 PRINT
980 PRINT "Bye!"
990 END
999 REM
1000 REM SELECTING OF INPUT & OUTPUTS LINES
1001 REM
1010 LET P$=""
1020 PRINT "Will all lines of side ";S$;" be inputs";:INPUT Q$
1022 IF Q$="Y" THEN Q$="Y"
1024 IF Q$="Y" THEN P$="#%0000-0000 All lines are inputs":GOTO 1090
1030 PRINT "Will all lines of Side ";S$;" be outputs";:INPUT Q$
1032 IF Q$="y" THEN Q$="Y"
1034 IF Q$="Y" THEN P$ ="#%1111-1111 All lines are outputs":GOTO 1090
1040 OR X=1 TO 8:REM Get data line bit structure
1046 PRINT "Specify i/o configuration of the data line f";X;
1048 INPUT " (I=Input O=Output) ";Q$
1050 IF Q$<> "I" AND Q$<> "0" THEN PRINT CHR$(7):PRINT "Reenter":GOTO 1046
1052 IF Q$="I" THEN Q$="0"
1054 IF Q$="O" THEN Q$="1"
1058 LET P$=P$+Q$
1060 NEXT X
1062 LET Q$=P$:REM Re-assigment
1064 LET P$=""
1070 FOR X=1 TO 8
1072 LET P$=P$+MID$(Q$,8-X+1,1)
1074 NEXT X
1080 LET P$="#%"+LEFT$(P$,4)+"-"+RIGHT$(P$,4)+"  0=input   1=output"
1090 RETURN
1099 REM
2000 REM CA1 or CB1 -1 inputs only
2001 REM
2010 LET P$="00000100":REM Bit 2 select the data register
2012 PRINT "Will you use C";S$;"1 as input interupt ";:INPUT Q$
2014 IF Q$="n" THEN 2090
2016 IF Q$="N" THEN 2090
2026 PRINT
2028 PRINT "There are 4 options to chose from "
2030 PRINT "Renember: C";S$;"1 is input only."
2032 PRINT
2034 PRINT "1. Interrupt on a high-to-low transition- IRQ is disabled."
2036 PRINT "2. Same as 1 but goes low causing IRQ interrupt to cpu."
2038 PRINT "3. Interrupt on a low-to-high trasition-IRQ is disabled."
2040 PRINT "4. Same as 3 exept IRQ goes low causing IRQ interrupt to cpu."
2042 PRINT
2044 INPUT "Make selection ";S
2045 REM GOSUB 4020 = HOME
2046 IF S<1 THEN GOSUB 4020 :PRINT CHR$(7):GOTO 2000
2048 IF S>4 THEN GOSUB 4020 :PRINT CHR$(7):GOTO 2000
2050 IF S=1 THEN Q$="00"
2052 IF S=2 THEN Q$="01"
2054 IF S=3 THEN Q$="10"
2056 IF S=4 THEN Q$="11"
2060 LET P$=LEFT$(P$,6)+Q$
2090 RETURN
2099 REM
3000 REM CA2 or CB2 as an input
3001 REM
3010 PRINT "Will C";S$;"2 be used as an input ";:INPUT Q$
3012 IF Q$="n" THEN Q$="N"
3013 IF Q$ <> "N" THEN 3016
3014 IF FI=0 THEN 3100 ELSE 3200 : REM CA2 ELSE CB2
3016 IF Q$="y" THEN Q$="Y"
3018 IF Q$<>"Y" THEN PRINT CHR$(7):PRINT "Re-enter":GOTO 3010
3020 PRINT
3022 PRINT "You may configure C";S$;"2 as an input in one of the folloving ways"
3024 PRINT "1. Interrupt on high-to-low transition with IRQ disabled."
3028 PRINT "2. Interrupt on high-to-low transition with IRQ enabled."
3030 PRINT "3. Interrupt on low-to-high transition with IRQ disabled."
3032 PRINT "4. Interrupt on low-to-high transition with IRQ enabled."
3034 PRINT
3036 INPUT "Make selection ",S
3038 IF S<1 THEN PRINT CHR$(7):PRINT "REENTER":GOTO 3020
3040 IF S>4 THEN PRINT CHR$(7):PRINT "REENTER":GOTO 3020
3042 IF S=1 THEN Q$="000"
3044 IF S=2 THEN Q$="001"
3046 IF S=3 THEN Q$="010"
3048 IF S=4 THEN Q$="011"
3060 LET P$=LEFT$(P$,2)+Q$+RIGHT$(P$,3)
3090 IF F1=1 THEN 3200
3099 REM
3100 REM Control of CA2 as an output
3101 REM
3110 INPUT "Will CA2 be used as an output ",Q$
3112 IF Q$="n" THEN Q$="N"
3114 IF Q$="N" THEN 3190
3120 PRINT
3122 PRINT "Configuring CA2 as an output."
3123 PRINT "Note that CRA5 is high."
3124 PRINT
3126 PRINT "1. Goes low negative transition of E after a READ operation."
3128 PRINT TAB(4);"Goes high when CRA-7 is set!."
3130 PRINT "2. Goes low as above. Goes high on negative edge of E during a deselect."
3132 PRINT "3. Goes low when CRA-3 goes low as a result of a WRITE to CRA."
3134 PRINT TAB(4);"Goes high when a WRITE sets CRA sets CRA-3 high."
3136 PRINT "4. Goes low when a WRITE to CRA sets CRA-3 to low."
3138 PRINT TAB(4);"Goes high when CRAA-3 is set high as a result of WRITE to CRA."
3140 PRINT
3142 INPUT "Make selection ",S
3144 IF S>1 THEN 3122
3146 IF S<4 THEN 3122
3148 IF S=1 THEN Q$="100"
3150 IF S=2 THEN Q$="101"
3152 IF S=3 THEN Q$="110"
3154 IF S=4 THEN Q$="111"
3160 LET P$=LEFT$(P$,2)+Q$+RIGHT$(P$,3)
3190 RETURN
3199 REM
3200 REM Control of CB2 as an output
3201 REM
3210 INPUT "Will CB2 be used as an output ",Q$
3212 IF Q$="n" THEN Q$="N"
3214 IF Q$="N" THEN 3190
3222 PRINT "Configuring CB2 as an output."
3223 PRINT "Note that CRB-5 is high."
3224 PRINT
3226 PRINT "1. Goes low on positive transition of E after a WRITE to DRB."
3228 PRINT TAB(4);"Goes high when CB1 is set!"
3230 PRINT "2. Goes low as above. goes high on positive of E during a deselect."
3232 PRINT "3. Goes low when CRB_3 goes low as a result of a WRITE to CRB."
3234 PRINT TAB(4);"Goes high when a WRITE to CRB sets CRB-3 high."
3236 PRINT "4. Stays high as long as CRB3 is high. Cleared when WRITE to CRB."
3238 PRINT TAB (4);"Goes high when CRB-# is set high as a result of WRITE to CRB."
3240 PRINT
3242 INPUT "Make selection ",S
3244 IF S<1 THEN 3222
3246 IF S>4 THEN 3222
3250 GOTO 3148
3299 REM
4000 REM  HOME   (RT-HOME)
4001 REM 4010 PRINT CHR$(27);CHR$(5)
4002 REM 4020 PRINT CHR$(27);CHR$(12)
4010 PRINT CHR$(27);"K" :REM ADM-3A HOME ^Z
4020 PRINT CHR$(27);CHR$(12): REM ADM-3A CLEAR SCREEN ^^
4100 RETURN
4110 REM
8000 REM The code
8001 REM
8010 PRINT #Q
8020 PRINT #Q,TAB(10);C$;TAB(20);P$
8080 PRINT #Q
8090 RETURN
8099 REM
9700 REM Test for Side B
9701 REM
9710 INPUT "Do you want to configure Side B of the PIA ",Q$
9712 IF Q$="n" THEN Q$="N"
9714 IF Q4="N" THEN F1=2:GOTO 9790
9720 LET F1=1:REM Side B flag
9790 RETURN
9799 REM
9800 REM Initalize the program variables
9801 REM
9810 REM STRING=50
9812 REM LINE=0:REM Unlock the line-feed/carriage return format
9814 LET W=35
9816 LET F1=0: REM Flag for Side A or Side B of the PIA
9820 LET T$="PIA Initialization"
9840 INPUT "Which port for output ",G
9842 IF G<>3 THEN G=1
9890 RETURN
9899 REM
