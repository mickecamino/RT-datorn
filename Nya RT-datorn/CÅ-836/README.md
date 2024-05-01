# CÅ-836 - EPROM-kort med RAM
Ett nytt designat kort för 3 st 27512 EPROM, detta ger 192 kb med permanent programminne. Detta kort kan lagra t.ex. operativsystemet Flex och Basic-tolk. Med en programrutin flyttar man så ned data från EPROM-minnet till datorns arbetsminne. Kortet ersätter CÅ-816.  
  
  
Programmen i EPROM'en skall ha följande utformning: (observera att detta inte refererar till t.ex. byte 0 och 1 i prommet utan till byte 0 och 1 för varje program)  
Byte 1 och 2 = Sista prom-adress  
Byte 3 och 4 = Första RAM-adress  
Byte 5 och 6 = Transferadress  

Exempel:  
För att lagra kommandot ASN i EPROM tar man reda på hur många bytes det programmet har, för FLEX 9.1 är ASN på 251 bytes (F5 i HEX).  
ASN ska lagras i minnet på adress $C100 och startas på adress $C100.  

Om detta är första programmet som skall lagras i EPROM börjar man på adress $0000 i prommet.  
$F5 + $6 (6 bytes för tabellen) = $FB, Byte 1 blir då $00 och byte 2 blir $FB = sista positionen i EPPROM för programmet ASN.  
Byte 3 blir $C1 och byte 4 blir $00, sama sak med byte 5 och 6.  
  
Från position 0000 i EPROM ser det då ut så här:  
|    tabell     | programmet ASN |          FB = sista positionen för ASN
00 FB C1 00 C1 00 02 C1 00 ...   | 04 16 C1 00  
  
Ett FLEX-program börjar med HEX 02 och adressen till var i minnet programmet skall lagras.  
För ASN står det 02 C1 00.  
De sista två bytes i programmet innehåller startadressen för programmet (Transferadress). För ASN står det C1 00.  
  
Nästa program som skall lagras i EPROM startar då med 6 bytes från adress $00FC.  
  