4 PRINT CHR$(12)
6 PRINT"***F|delsedag***"
7 PRINT
10 DIM Z$(12),L(12),Y$(7)
20 FOR I=1 TO 12
30 READ Z$(I)
35 NEXT I
40 FOR I=1 TO 12
42 READ L(I)
44 NEXT I
45 FOR I=1 TO 7
46 READ Y$(I)
48 NEXT I
50 DATA JANUARI,FEBRUARI,MARS,APRIL,MAJ,JUNI,JULI,AUGUSTI
52 DATA SEPTEMBER,OKTOBER,NOVEMBER,DECEMBER
54 DATA 31,28,31,30,31,30,31,31,30,31,30,31
56 DATA TORS,FRE,L0R,S0N,MAN,TIS,ONS
100 PRINT"Ange dagens datum numeriskt;"
102 PRINT"]r,m}nad,datum ex:1979,03,23"
110 INPUT Z1,X1,Y1
120 X9=X1
122 Y9=Y1
124 Z9=Z1
126 GOSUB 900
128 U=X8
140 PRINT"I dag {r det ";Y$(U-7*INT(U/7)+1);"Dag"
142 PRINT"(hoppas jag....)"
205 PRINT
220 PRINT"Hej jag {r M6800 datorn."
225 PRINT"Vad heter du";     
230 INPUT N$
400 PRINT"Hur gammal {r du,";N$;
405 INPUT A
406 REM Acceptera 5-95 }r
407 A=INT(A)
410 IF INT((A-5)/95)=0 GOTO 425
415 PRINT"Sk{rpning,";N$;","
417 PRINT"Du driver med mig,"
420 GOTO 400
425 PRINT"Jaha du {r";A;"}r gammal."
430 PRINT"Vet du p} rak arm hur"
432 PRINT"M}nga dagar gammal du {r(ja/nej)"
435 GOSUB 800
440 ON X7 GOTO 500,445,435
445 PRINT"OK,smarting,hur m}nga?"
465 PRINT"Taskigt ";N$;",du f}r"
467 PRINT"allt vara snabbare {n s}.."
470 GOTO 9999
500 PRINT"OK,jag skall ber{tta"
505 PRINT"I vilken m}nad {r du f|dd"
506 PRINT"(Januari,Februari etc.)";
510 INPUT M$
515 FOR X=1 TO 12
520 IF M$=Z$(X) GOTO 540
525 NEXT X
530 PRINT N$;"Du kanske {r trevlig,"
532 PRINT"men Du stavar taskigt.."
535 GOTO 505
540 PRINT"P} vilken dag(1-31";
545 INPUT Y
546 PRINT
547 PRINT CHR$(12)
548 Z=Z1-A
550 IF INT((Y-1)/L(X))=0 GOTO 600
555 IF (X-1)*(Y-28)*(Z-4*INT(Z/4)+1)=1 GOTO 600
560 PRINT"Sk{rpning,";N$;","
562 PRINT"annars }ker du ut."
565 GOTO 540
600 REM INHOPPS RAD
601 X9=X1
602 Y9=Y1
603 Z9=Z
605 GOSUB 900
606 W=X8
607 X9=X
608 Y9=Y
609 Z9=Z
610 GOSUB 900
611 V=X8
612 IF W>=V GOTO 615
613 Z=Z-1
615 IF ABS(W-V)>30 GOTO 700
620 ON SGN(W-V)+2 GOTO 630,650,640
630 PRINT"Du fyller }r om"
632 PRINT"endast";V-W;"dagar."
635 GOTO 700
640 PRINT"Din f|delsedag var f|r bara"
642 PRINT W-V;"DAGAR SEDAN.GRATTIS..."
645 GOTO 700
650 PRINT"Grattis,k{ra ";N$
652 PRINT"Grattis p} f|delsedagen.."
700 X9=X
702 Y9=Y
704 Z9=Z
706 GOSUB 900
708 V=X8
710 PRINT"Du f|ddes p} ";Y$(V-7*INT(V/7)+1);"dagen,"
712 PRINT"den ";Y;" ";Z$(X);" }r ";Z
715 PRINT"vilket g|r dig";U-V;"dagar gammal"
720 PRINT"Du f|ddes";V;"dagar efter Kristus,"
722 PRINT"och den 1/1 }r 2000"
725 PRINT"kommer Du att vara"
727 PRINT 730511-V;"dagar gammal."
730 PRINT"vad s{gs om det va...."
735 PRINT
740 PRINT"Tja....";N$
755 PRINT"Det var kul att snacka med dig"
756 PRINT"}terkom g{rna n}gon dag"
760 PRINT"Aj|ken"
770 GOTO 9999
800 INPUT A$
805 X7=1
810 IF A$="NEJ"GOTO 850
820 X7=2
825 IF A$="JA" GOTO 850
830 X7=3
835 PRINT"ett enkelt JA eller NEJ duger bra."
850 RETURN
900 REM
902 X8=Y9-1
905 FOR I1=1 TO X9-1
910 X8=X8+L(I1)
915 NEXT I1
918 I1=INT(Z9/100)
920 IF Z9/100=I1 GOTO 935
925 IF X8>59 GOTO 935
928 IF X9=3 GOTO 935
930 X8=X8-1
935 X8=X8+36524*I1+INT(365.25*(Z9-100*I1))
950 RETURN
9999 END
