# CÅ-836 - EPROM-kort med RAM
Ett nydesignat kort för 3 st 27512 EPROM, detta ger 192 kb med permanent programminne. Detta kort kan lagra t.ex. operativsystemet Flex, de flesta utilities som används i FLEX och större program som BASIC, XBASIC, ASMB etc. Med en programrutin flyttar man ned data från EPROM-minnet till datorns arbetsminne. Kortet ersätter CÅ-816.  
  
Programmet för att hämta programmen från EPROM kallas PROM.BIN, källkoden för detta finns här med namnet PROM.ASM.  
  
Programmen som ska lagras på kortet är vanliga standard .CMD-filer, laddprogrammet läser .CMD-filen på samma sätt som FLEX gör.    
Ett FLEX-program har fyra startbytes:  
Byte 0 - Start of record indicator $02  
Byte 1 - Most significant byte of the load address  
Byte 2 - Least significant byte of the load address  
Byte 3 - Number of bytes in the record  
Byte 4-n - The binary data of the record.  
Då det är en byte som innehåller antalet bytes i recordet (posten) är det max 255 bytes som får plats i ett record..  
Ett stort program innehåller många records (poster) och programmet slutar alltid med 0x16 som markerar slutet, följst av två bytes som innehåller startadressen till programmet.  
  
RAM-minnet på 1kb används av programmet PROM som laddas via STARTUP.TXT med kommandot GET PROM, programmet laddas i minnet på adresserna $E400, $E500 och $E700.  
 
