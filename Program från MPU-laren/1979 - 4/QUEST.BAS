1 REM QEST AV ROGER CHAFFEE
2 REM INSPIRERAD AV WILL CROWTHER"S 'ADVENTURE'
3 REM INKNAPPAD AV TBL & GRU (SVETT!!)
13 REM VARIABELBESKRIVNING
14 REM N  NODE ( GROTT) NUMMER
15 REM M0 DRAG R[KNARE
16 REM T  NUVARADE L[GE F\R SKATTEN ( -1 F\R B[RANDE )
17 REM T1,T2 F\RSTA OCH ANDRA G\MST[LLEN ( NOD NUMMER )
18 REM M6  SPARAR DRAGNUMRET N[R HAN SADE NEJ, HAN VILLE
19 REM INTE TA SKATTEN MED SIG.
20 REM M   KARTA \VER MELLANF\RBINDELSER
21 REM M(I,J) [R N[STA NOD FR]N NOD J N[R DU G]R
22 REM N,E,U,D,W,S F\R I = 1,2,3,4,5,6
23 REM
24 REM -  STUDS -
25 REM ATT G] TILL (NOD-2 ) BETYDER ATT STUDSA TILLBAKA TILL
26 REM DEN NOD DU KOM FR]N.
27 REM
28 REM TV]NGS- OCH ELLER SLUMPDRAG
29 REM M(1,N)=-2 BETYDER TV]NGSDRAG S] FORT DU N]R
30 REM NODE N. I S] FALL M(2,N) AV DE G]NGER DU G]R TILL
31 REM NODE M(3,N). OM DU INTE G]R DIT, M(4,N)
32 REM AV G]NGERNA DU G]R TILL NOD (5,N), OCH RESTEN AV G]NGERNA
33 REM G]R DU TILL NOD 6,N)
34 REM
35 REM NODERNA > 100
36 REM NODE N + 100 BETYDER NOD N OM DU INTE HAR SKATTEN
37 REM OCH NODE N+1 OM DU HAR DEN.
38 REM NODE N + 200 BETYDER NODE N+1 OM DU HAR SKATTEN ANDRA
39 REM G]NGEN, OCH NOD N ANNARS.
40 REM NODE N+ 500 BETYDER SNURRA I EN DELAY LOOP OCH SEDAN
41 REM G] TILL NOD  N. DETTA ANV[NDS F\R ATT FALLA NED I UTG]NGS
42 REM SCAKTET, OCH DU KAN \NSKA ATT JUSTERA F\RDR\JNINGSTIDEN.
43 REM (RAD 6250).
44 REM
45 REM Q$  INPUT STR[NG
46 REM A$  TECKEN ATT J[MF\RA I UTPUT RUTINEN.
47 REM A2  ANTAL TECKEN I A$
48 REM A1  OUTPUT FR]N INPUT RUTINEN.U
49 REM P   PIRAT FLAGGA  1 OM PIRATEN HAR TAGIT DIG, 0 ANNARS.
50 REM P1  R[KNARE F\R PIRATRUTINEN
51 REM N9  SPARAR GAMMAL NOD I DRAG RUTINEN, F\R STUDS
52 REM N8  SPARAR NOD VI STUDSADE FR]N I DRAG RUTIN ,
53 REM F\R PRINT FLAGGA
54 REM N0  SPARAR GAMMAL NOD I DRAG RUTIN. F\R ]TERV[NDSGATA
55 REM A0  SPARAR GAMMAL RIKTNING I DRAGRUTINEN
56 REM D   DEBUG FLAGGA ( EJ NOLL F\R PRINTNING)
57 REM I,J DIVERSE R[KNARE
58 REM W   F[RD R[KNARE. ANV[NDS I PO[NGS[TTNING. W(I)=1 OM HAN
59 REM VARIT TILL NOD I, 0 ANNARS.
60 REM S   PO[NG.
61 REM M9 MAXIMALA ANTAL NODER
80  D=0
100 REM ---------------------------------------------
105 PRINT CHR$(5)
110 REM GE DEM N]GOT ATT FUNDERA -] MEDANS JAG S[TTER UPP DATABASEN.
120 PRINT "             QUEST/V1"
130 PRINT
140 PRINT "DU PROMENERADE GENOM"
150 PRINT "SKOGEN OCH DU ST\TTE P] ING]NGEN"
160 PRINT "TILL EN GROTTA, T[CKT MED BUSKAR."
170 PRINT
180 PRINT "FOLK S[GER ATT F\R M]NGA ]R SEDAN"
190 PRINT "G\MDE EN PIRAT SIN SKATT I DESSA SKOGAR"
200 PRINT "MEN INGEN HAR N]GONSIN FUNNIT DEN."
210 PRINT "S]VITT JAG VET, KAN DEN [NNU VARA D[R"
400 READ M9,T1,T2
500 DIM W(42),M(6,42)
510 REM L[S KARTAN TILL M ARRAYEN
520 FOR I = 1 TO M9
530 READ N
540 IF I=N THEN 570
550 PRINT "DATABAS PROBLEM ",I,N
560 STOP
570 FOR J = 1 TO 6
580 READ M(J,I)
590 NEXT J
600 NEXT I
900 PRINT
905 PRINT "N[R DU SVARAR P] EN FR]GA S] TITTAR JAG"
906 PRINT "BARA P] DET  F\RSTA TECKNET. DU KAN DOCK"
907 PRINT "GE HELA ORDET OM DU VILL."
920 GOSUB 7500
1000 REM ---------------------------------------------
1010  N=5
1020  M0=0
1030  M6=0
1040  T=T1
1050  P=0
1060  P1=0
1070 FOR J=1 TO M9
1080  W(J)=0
1090 NEXT J
1100 PRINT
1110 REM BESKRIV
1120 GOSUB 8000
1400 REM ---------------------------------------------
1405 REM * * *        HUVUD LOOPEN B\RJAR H[R   * * *
1410 REM R[KNA DRAGEN
1420  M0=M0+1
1430 REM DRAG
1440 GOSUB 6000
1450 REM KOLLA F\R HITTANDE AV SKATTEN
1460 GOSUB 2000
1470 REM F\RS\K MED PIRATEN
1480 GOSUB 4000
1490 REM LOOPA TILLS DET [R KLART
1500 IF T>0 THEN 1400
1510 IF N<>5 THEN 1400
1700 REM BER[KNA PO[NGEN
1710 GOSUB 3000
1720 PRINT
1730 PRINT "GRATULATIONER! DU FANN SKATTEN"
1740 PRINT "I ";M0;
1750 PRINT "DRAG OCH DU F]R ";S+10;" PO[NG!!"
1760 PRINT "VILL DU JAGA IGEN ";
1770  A$="JN"
1771  A2=2
1780 GOSUB 5000
1790 ON A1 GOTO 1000,9999,1760
2000 REM ---------------------------------------------
2010 REM FUNNEN ?
2100 IF T<>N THEN RETURN
2110 IF T<0 THEN RETURN
2120 IF M6+5>M0 THEN RETURN
2200 PRINT "VILL DU TA DEN MED DIG (J/N) ";
2210  A$="JN"
2220  A2=2
2230 GOSUB 5000
2240 ON A1 GOTO 2300,2400,2250
2250 PRINT "..HUR SKA DU HA DET.."
2260 GOTO 2210
2300  T=-1
2310 PRINT
2320 PRINT "OK, L]T OSS TA OSS UT H[RIFR]N!"
2330 RETURN
2400 PRINT
2410 PRINT "VI L[MNAR DEN H[R OCH DU KAN UTFORSKA"
2420 PRINT "LITE TILL."
2430  M6=M0
2440 RETURN
3000 REM ---------------------------------------------
3010 REM - PO[NG -
3020  S=0
3030 IF T=-1 THEN S=S+5
3040 IF P=1 THEN S=S+10
3050 FOR J=2 TO M9
3060  S=S+W(J)
3070 NEXT J
3080 RETURN
4000 REM -------------------------------------------
4010 REM - PIRATEN -
4020 IF N=T2 THEN RETURN
4030 IF P=1 THEN RETURN
4040 IF T1=T2 THEN RETURN
4050 IF T<>-1 THEN RETURN
4060 REM HAN [R VID UTG]NGEN MED SKATTEN. STRAFFA HONOM.
4065 REM (ARRGH, HUR KOM HAN HIT EGENTLIGEN ??)
4070 IF N=16 THEN P=160
4080 REM R[KNA DRAG SEDAN TR[FFAT TR]NGA TUNNELN MED SKATTEN
4090 IF P1>0 THEN P1=P1+1
4100 IF N=3 THEN P1=P1+1
4110 REM GE HONOM N]GRA DRAG TILL. SEDAN STRAFFA HONOM
4120 IF P1<15 THEN RETURN
4130 PRINT
4140 PRINT "PL\TSLIGT ST\RTAR PIRATEN UT FR]N"
4150 PRINT "SKUGGAN OCH SLITER SKATTEN IFR]N DIG!"
4160 PRINT "- HAH! SKRIKER HAN - DU FANN MIN"
4170 PRINT "SKATT VA! N]JA - JAG SKALL G\MMA DEN"
4180 PRINT "B[TTRE N[STA G]NG!!"
4190 PRINT "OCH HAN F\RSVINNER UT I M\RKRET"
4200 PRINT "MED SKATTEN."
4210 P=1
4220  T=T2
4230 RETURN
5000 REM ---------------------------------------------
5010 REM - INPUT -
5020 REM F\RSTA TECKNEN I A1 INPUT STR[NGEN JMF\RS MED
5030 REM BOKST[VERNA I I A$.VID MATCH RETURNERAS INDEXET I A$
5040 REM I A1. OM EJ TR[FF, RETURNERAS STORLEKEN+1 AV A$.
5050 REM
5060 REM GET INPUT STRING
5070 INPUT Q$
5080 REM ANV[ND ENDAST F\RSTA TECKNET
5085  Q$=MID$(Q$,1,1)
5090 FOR A1= 1 TO A2
5100 IF Q$=MID$(A$,A1,1) THEN RETURN
5105 NEXT A1
5110  A1=A2+1
5120 RETURN
6000 REM ----------------------------------------------
6010 REM - DRAG -
6020 REM KOM IH]G VAR VI [R F\R STUDS
6030  N9=N
6040 REM SET N8 TO VADSOMHELST MEN DU KAN INTE G] DEN V[GEN
6050  N8=0
6060 REM FR]GA OM V[GEN
6070 GOSUB 7000
6080 REM KOM IH]G VAR VI [R F\R S]VITT EJ ]TERV[NDSGATA
6090 IF N=1 THEN 6120
6100  N0=N
6110  A0=A1
6120 PRINT
6130  I=M(A1,N)
6200 IF I=-2 THEN I=N9
6210 IF D<>0 THEN PRINT " * * DEBUG ";N;"TILL ";I
6220 IF I<500 THEN 6300
6230 REM F\RDR\JNINGSLOOP
6240  I=I-500
6250 FOR J=1 TO 100
6260 NEXT J
6270 GOTO 6200
6300 ON I/100+1 GOTO 6310,6340,6370
6310 REM NORMAL RUTT--MINDRE [N 100
6320  N=I
6330 GOTO 6400
6340 REM N+100 ADDERA 1 OM B[RANDE P] SKATTEN
6350  N=I-100
6355 IF T=-1 THEN N=N+1
6360 GOTO 6400
6370 REM N+200 ADDERA 1 OM B[RANDE P] SKATTEN ANDRA G]NGEN
6380  N=I-200
6390 IF T=-1 THEN N=N+P
6400 IF N<>1 THEN 6500
6410 REM ]TERV[NDSGATA. V[ND DEN S] ATT DU KAN KOMMA UT ANDRA V[GEN
6420 FOR J= 1 TO 6
6430  M(J,N)=2
6440 NEXT J
6450  M(7-A0,N)=N0
6500 REM PRINTA NOD BESKRIVNINGEN
6510 IF N8<>2 THEN GOSUB 8000
6520 REM KOM IH]G ATT VI VARIT   H[R
6530  W(N)=1
6540  N8=N
6600 IF M(1,N)<>-2 THEN 6800
6610 REM TV]NGSDRAG, MED SLUMP M]L.
6660  I=M(6,N)
6670  J=-1
6680 IF M(4,N)>100*RND(0) THEN I=M(5,N)
6690  J =-1
6700 IF M(2,N)>100*RND(0) THEN I=M(3,N)
6710 IF D<>0 THEN PRINT " * * DEBUG STUDS TILL ";I
6720 REM NU HAR VI EN NY DESTINATION. G] TILLBAKS OCH G\R OM DET
6730 GOTO 6200
6800 RETURN
7000 REM -------------------------------------------
7010 REM - VILKEN V[G -
7100 PRINT
7110 PRINT "               VILKEN V[G?";
7120  A$ = "NEUDWSP"
7130  A2 = 7
7140 GOSUB 5000
7150 IF A1<8 THEN 7300
7160 PRINT "VILKEN V[G V[LJER DU"
7170 REM GE INSTRUCTIONER
7180 GOSUB 7500
7190 REM BESKRIV POsITIONEN IGEN
7200 GOSUB 8000
7210 GOTO 7100
7300 IF A1<7 THEN 7400
7310 REM BER[KNA OCH SKRIV UT PO[NGEN
7320 GOSUB 3000
7330 PRINT "DU HAR JUST NU ";S;" PO[NG"
7340 REM B\RJA P]NYTT
7350 GOTO 7100
7400 RETURN
7500 REM ========================================
7510 REM SUBRUTINE F\R ATT GE INSTRUCTIONER
7520 PRINT
7530 PRINT "SKRIV N,S,E,W,U,D F\R NORTH,SOUTH"
7550 PRINT "EAST,WEST,UP,DOWN.SKRIV P F\R PO[NG"
7560 PRINT
7570 RETURN
8000 REM ======================================
8010 REM BESKRIV DEN NUVARANDE POSITIONEN
8050  I = INT(N/5)
8060  J = N - 5*I + 1
8070 REM H[R FINNS TILLR[CKLIGT MED SATSNUMMER F\R ATT TA HAND OM
8080 REM NODERNA 0,49.DU M]STE L[GGA TILL FLER OM DU ADDERAR
8090 REM NODERNA 50 OCH UPP]T.
8100 ON I+1 GOTO 8200,8210,8220,8230,8240,8250,8260,8270,8280,8290
8200 ON J GOTO 9000,9010,9020,9030,9040
8210 ON J GOTO 9050,9060,9070,9080,9090
8220 ON J GOTO 9100,9110,9120,9130,9140
8230 ON J GOTO 9150,9160,9170,9180,9190
8240 ON J GOTO 9200,9210,9220,9230,9240
8250 ON J GOTO 9250,9260,9270,9280,9290
8260 ON J GOTO 9300,9310,9320,9330,9340
8270 ON J GOTO 9350,9360,9370,9380,9390
8280 ON J GOTO 9400,9410,9420,9430,9440
8290 ON J GOTO 9450,9460,9470,9480,9490
8400 IF T<>N THEN 8500
8410 PRINT
8420 PRINT " SKATTEN [R H[R!"
8500 IF T<>T2 THEN 8600
8510 IF T1=T2  THEN 8600
8520 IF T1<>N  THEN 8600
8530 PRINT
8540 PRINT "P] V[GGEN ST]R ATT"
8550 PRINT "PIRATER ALDRIG L[MNAR SINA SKATTER"
8560 PRINT "TV] G]NGER P] SAMMA ST[LLE!"
8600 RETURN
9000 REM ================================================
9001 REM F\RSTA DATASATSEN [R ANTALET NODER OCH DE TV]
9002 REM G\MST[LLENA F\R SKATTEN
9003 DATA 42,23,12
9004 REM N E U D W S   < RIKTNINGARNA >
9010 DATA 1,0,0,0,0,0,0
9011 PRINT "DU HAR HAMNAT I EN ]TERV[NDSGR[ND"
9012 GOTO 8400
9020 DATA 2,-2,101,-2,0,0,0
9021 PRINT "DU KAN INTE G] I DEN RIKTNINGEN."
9022 PRINT
9023 GOTO 8400
9030 DATA 3,33,2,1,10,106,4
9031 PRINT "EN TUNNEL G]R I NORD-SYDLIG RIKTNING."
9032 PRINT "]T V[STER [R EN \PPNING."
9037 GOTO 8400
9040 DATA 4,3,30,2,11,2,1
9041 PRINT "DU [R P] KANTEN TILL ETT DJUPT H]L."
9047 GOTO 8400
9050 DATA 5,8,8,15,10,8,16
9051 PRINT "DU [R UTANF\R GROTTAN"
9052 PRINT "G] S\DER UT F\R ATT KOMMA IN IGEN"
9053 GOTO 8400
9060 DATA 6,16,3,2,10,2,2
9061 PRINT "DU [R I BERGAKUNGENS HEM."
9062 PRINT "SOM TUR [R HAR HAN G]TT F\R DAGEN"
9067 GOTO 8400
9070 DATA 7,-2,101,-2,0,0,0
9071 PRINT "BERGAKUNGEN [R H[R!"
9072 PRINT "B[ST DU G]R UT!"
9073 PRINT
9077 GOTO 8400
9080 DATA 8,18,18,15,10,18,9
9081 PRINT "DU [R F\RLORAD I SKOGEN."
9087 GOTO 8400
9090 DATA 9,-2,33,5,1,0,-2
9097 GOTO 8400
9100 DATA 10,-2,101,-2,0,0,0
9101 PRINT "DU KOMMER INTE ATT KOMMA L]NGT OM DU"
9102 PRINT "T[NKER GR[VA I BERG"
9103 PRINT
9107 GOTO 8400
9110 DATA 11,1,13,4,2,1,2
9111 PRINT "DU [R P] BOTTEN AV ETT H]L. EN LITEN"
9112 PRINT "STR\M FLYTER \VER STENARNA H[R."
9117 GOTO 8400
9120 DATA 12,36,2,1,2,1,2
9121 PRINT "DU HAR HAMNAT I EN ]TERV[NDSGR[ND!"
9127 GOTO 8400
9130 DATA 13,2,37,2,1,11,14
9131 PRINT "DU [R P] EN \PPEN PLATS.H[R [R EN SOTIG"
9132 PRINT "FL[CK D[R N]GON NYSS HAR VILAT"
9133 PRINT "EN FACKLA MOT V[GGEN.OSTADIGA STENAR"
9134 PRINT "VILAR OVANF\R DITT HUVUD"
9137 GOTO 8400
9140 DATA 14,13,1,19,2,31,31
9141 PRINT "DU [R I EN KLYFTA.P] V[GGEN H\GT OVANF\R"
9142 PRINT "DIG [R F\LJANDE MEDDELANDE RISTAT:"
9143 PRINT "         'BILBO WAS HERE'"
9147 GOTO 8400
9150 DATA 15,-2,101,-2,0,0,0
9151 PRINT "DU [R INGEN F]GEL. INSE ATT"
9152 PRINT "DU INTE KAN FLYGA."
9153 PRINT
9157 GOTO 8400
9160 DATA 16,5,33,2,10,1,106
9161 PRINT "DU [R I EN MYCKET L]G KAMMARE. EN TR]NG"
9162 PRINT "TUNNEL LEDER MOT \STER OCH DU KAN"
9163 PRINT "G] MOT SYD ELLER V[ST. I NORR KAN"
9164 PRINT "MAN SE LJUS."
9165 PRINT
9167 GOTO 8400
9170 DATA 17,-2,101,-2,0,0,0
9171 PRINT "TUNNELN SMALNAR AV S] ATT DU EJ KAN"
9172 PRINT "KOMMA F\RBI MED SKATTEN"
9173 PRINT
9177 GOTO 8400
9180 DATA 18,-2,101,8,0,0,0
9181 PRINT "JAG TROR INTE DU KAN FINNA GROTTAN"
9187 GOTO 8400
9190 DATA 19,224,2,2,14,1,42
9191 PRINT "DU [R H\GST UPP P] EN AVSATS."
9192 PRINT "UNDER DIG KAN DU L[SA ETT MEDDELANDE"
9193 PRINT "         'BILBO WAS HERE'"
9197 GOTO 8400
9200 DATA 20,226,1,2,2,25,2
9201 PRINT "DU [R P] NORRA SIDAN AV EN SPRICKA,"
9204 PRINT "RINGANDE EKON FR]N DJUPET [R"
9205 PRINT "DET ENDA S[TTET ATT M[TA SPRICKANS DJUP."
9207 GOTO 8400
9210 DATA 21,1,226,2,2,38,25
9211 PRINT "DU HAR KOMMIT TILL XANADU. UNDER DIG"
9212 PRINT "RINNER DEN HELIGA FLODEN ALPH GENOM"
9213 PRINT "GROTTVINDLINGAR OM[TBARA F\R"
9214 PRINT "M[NNISKAN, NED TILL ETT HAV UTAN SOL."
9217 GOTO 8400
9220 DATA 22,-2,33,13,50,29,30
9227 GOTO 8400
9230 DATA 23,2,1,2,31,2,2
9231 PRINT "DU [R P] HYLLAN \VER GILJOTINRUMMET"
9237 GOTO 8400
9240 DATA 24,-2,101,19,0,0,0
9241 PRINT "JAG H\R J[TTEN D[R!!!"
9242 PRINT "DET [R B[ST DU G]R TILLBAKA!"
9243 PRINT
9247 GOTO 8400
9250 DATA 25,21,20,2,2,1,19
9251 PRINT "DU [R I J[TTENS GROTTA.DET [R NOG B[ST"
9252 PRINT "ATT INTE VARA H[R N[R J[TTEN KOMMER!"
9257 GOTO 8400
9260 DATA 26,-2,65,-2,50,11,14
9261 PRINT "DU [R JUST NU I AREAN F\R FORSKNING OCH"
9262 PRINT "UTVECKLING AV QUEST"
9263 PRINT
9264 PRINT "JAG [R LEDSEN, MEN BES\KARE [R INTE"
9265 PRINT "TILL]TNA H[R. DU M]STE TYV[RR"
9266 PRINT "AVL[GSNA DIG."
9267 PRINT
9268 GOTO 8400
9270 DATA 27,2,40,2,2,21,20
9271 PRINT "DU [R NU I KRISTALLPALATSET. V[GGARNA"
9272 PRINT "H[R VIBRERAR FRAM EN S]NG AV [NGSLAN."
9277 GOTO 8400
9280 DATA 28,-2,60,221,50,14,19
9281 PRINT "- ARRRGHHHH....."
9282 PRINT
9287 GOTO 8400
9290 DATA 29,2,42,2,13,1,1
9291 PRINT "DU [R P] TOPPEN AV EN J[TTE-STALAGTIT."
9292 PRINT "DU KAN HASA NER MEN DET G]R INTE ATT"
9293 PRINT "BESTIGA DEN IGEN."
9297 GOTO 8400
9300 DATA 30,34,34,2,1,4,2
9301 PRINT "DU [R I EN LITEN GROTTA.H[R FINNS EN"
9302 PRINT "BOK TITULERAD JANE'S KRIGSFARTYG,"
9303 PRINT "DATERAD 1763."
9307 GOTO 8400
9310 DATA 31,14,14,23,2,1,2
9311 PRINT "DU [R I GILJOTIN-RUMMET.EN MYCKET SKARP"
9312 PRINT "OCH TUNG STEN BALANSERAR P] HYLLAN EXAKT"
9313 PRINT "OVANF\R DIG!!!"
9317 GOTO 8400
9320 DATA 32,-2,101,516,0,0,0
9321 PRINT "DU [R I ETT SCHAKT OCH FALLER NEDF\R"
9322 PRINT "KLIPPORNA ! DU HAR INGEN CHANS ATT"
9323 PRINT "STANNA! H]LL HUVUDET KALLT!"
9327 GOTO 8400
9330 DATA 33,2,1,2,1,116,3
9331 PRINT "DEN TR]NGA TUNNELN SV[NGER"
9332 PRINT "RUNT ETT H\RN"
9337 GOTO 8400
9340 DATA 34,1,35,2,1,30,30
9341 PRINT "DU [R I EN LITEN KR]NGLIG LABYRINT"
9347 GOTO 8400
9350 DATA 35,2,1,2,37,34,36
9351 PRINT "DU [R I EN LITEN KRINGELKROKANDE LABYRINT"
9357 GOTO 8400
9360 DATA 36,35,2,1,37,34,12
9361 PRINT "DU [R I EN LITEN KRINGLANDE LABYRINT"
9367 GOTO 8400
9370 DATA 37,2,1,35,2,13,2
9371 PRINT "DU [R I EN SN]RIG LITEN LABYRINT"
9377 GOTO 8400
9380 DATA 38,2,21,2,116,1,2
9381 PRINT "DU [R I EN F\RHISTORISK BOPLATS. P]"
9382 PRINT "V[GGARNA SER MAN TECKNINGAR AV MYSK-"
9383 PRINT "OXAR M]LADE I R\D LERA. P] GOLVET"
9384 PRINT "[R FULLT AV UTSTR\DDA BEN, "
9385 PRINT "L[MNINGAR AV F\RG]NGNA RITUALER."
9387 GOTO 8400
9390 DATA 39,2,40,2,32,21,26
9391 PRINT "DU [R I ETT SVART H]L."
9392 PRINT "GRAVITATIONSKRAFTEN [R \VERV[LDIGANDE."
9397 GOTO 8400
9400 DATA 40,40,40,2,2,40,41
9401 PRINT "DU [R I LABYRINTEN."
9407 GOTO 8400
9410 DATA 41,40,40,40,2,40,39
9411 PRINT "DU [R I LABYRINTEN."
9412 PRINT "DET [R MYCKET M\RKT H[R."
9417 GOTO 8400
9420 DATA 42,28,28,28,28,28,28
9421 PRINT "DU [R I N[RHETEN AV HELVETET!"
9422 PRINT "R\KELSE LIGGER TUNG I LUFTEN OCH"
9423 PRINT "DU TYCKER ATT ALLA RIKTNINGAR SER"
9424 PRINT "LIKADANA UT. DU K[NNER DIG VILLR]DIG."
9427 GOTO 8400
9430 REM DET FINNS INGA NODER F\R F\LJANDE RADNUMMER.OM DU HAMNAR
9440 REM H[R, HAR DU ETT FEL I EN DATA SATS.
9450 REM
9460 REM
9470 REM
9480 REM
9490 REM
9500 REM
9510 REM
9520 REM
9530 REM
9999 END
