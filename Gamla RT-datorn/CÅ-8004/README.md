# CÅ-8004
Detta periferikort består av en timer, MC6840 från Motorola och två små förstärkare för ljudutgång.
Utgångarna 1-3 används för att generera toner.
Ett kodexempel finns som spelar en Mozart-vals är skapat av Åke Holm, filen heter univkort-6809.asm (univkort-6808.asm för 6808). 
Tidkretsen innehåller tre 16-bitars räknare som kan programmeras på ett flertal sätt.
I RT-datorn används det för "printer spooling" i FLEX 2.0 eller FLEX 9.0.
Det fungerar genom en rutin i FLEX kallad PRINT. rutinen initierar tidkretsen så att den ger ett periodiskt avbrott under vilken skrivarens utskriftsprogram tas om hand.
Förutsättningen för funktionen är att det program som man själv kör inte använder IRQ-vektorn, samt att ingen åverkan får göras på de textfiler vilka ska skrivas ut på skrivaren. Det förutsätts också att skrivaren är ansluten till en egen ACIA på kortet CÅ-8001.

## Funktionsbeskrivning
Vi skall i detta avsnitt först beskriva hur tidkretsen 6840 kan användas för att skapa elektronisk musik. Ett programexempel för detta återfinns i univkort-6809.asm.  
Eftersom det finns tre räknare i kretsen kan man alltså spela trestämmigt (polyfont), vilket naturligtvis förhöjer värdet av det hela. Då man använder mikrodatorns klockfrekvens som utgångsfrekvens för tonalstringen kommer man ej att få exakta toner inom varje oktav. Skillnaden är dock väldigt liten, och då en oktav alltid motsvarar en faktor 2 i frekvens, blir det svårt att höra om datorn spelar falskt. Den som vill ha en större noggrannhet på frekvenserna kan använda en yttre kristalloscillator på 1,00012 MHz.  
För att göra det lättare för utövaren att skriva musiken eller att omvandla vanlig notskrift till datorspråk har varje databyte byggts upp på ett speciellt sätt. En byte som anger en ton kan anta värden mellan $11 och $7C. Den vänstra siffran (msb) anger i vilken oktav tonen ligger och siffran kan variera mellan 1 och 7. Den högra siffran anger vilken ton inom oktaven som avses. Detta värde måste vara mellan 1 och $C, eftersom vi har en tolvtonsskala.  
Förutom toner måste vi kunna ange takten. För detta används en byte vars högra halva alltid är $D. 

Den vänstra halvan anger varaktigheten för varje ton och kan anta alla värden mellan 1 och $F. Om paus önskas, används koden $60. Som avslutning på noterna kommer stoppkoden 00. Programmet hämtar in noterna en och en och testar om det är stoppkod, taktkod eller en tonkod. Om högsta biten i en tonkod är satt till "1", kommer utgången att aktiveras och tonen att få den längd som angavs av någon föregående taktkod. Detta är gjort för att man skall kunna lägga in tre toner på en gång och få fram dessa vid givna ögonblick.  
För att försöka förklara detta lite lättare skall vi gå igenom noterna på rad 115 i univkort-6809.asm. Tonerna anger vi som hexadecimala tal, men det är lätt att räkna om dessa till motsvarande steg i tonskalan. Ettstrukna A har värdet $5A.  
Först kommer taktkoden $2D, därefter kommer tonen $72, som läggs in i tidkretsens första register, sedan kommer tonen $4A som läggs in i andra registret och den följs av tonen $E0, som inte är någon ton utan pauskoden $60 med högsta biten satt till 1. Den läggs in i det tredje registret och samtidigt släpps de andra två tonerna ut. Det har nu blivit två stämmor.  
För den som kan läsa noter kan detta jämföras med noterna här:   
![Vals-noter](/noter.jpg)  
Vi har alltså presterat den första tonen i varje rad. Nu finns toner inlagda i alla tre registren. När spelprogrammet kommer till en byte med högsta biten satt till "1", kommer följande ton att placeras i register 1.  
Nästa byte är $EA, vilket är tonen $6A till register 1. Följande ton är $65 och även det förs till register 1. Den därpå följande tonen är tystkoden $60, och vi har nu avverkat de tre första noterna på översta raden. Datanoterna på rad 116 i univkort-6809.asm har samma ordning, eftersom samma noter återkommer på notraden. På detta sätt kan man gå igenom noterna och översätta varje ton och varje takt till kod för datamusik.  
Om programmet kan vidare sägas att det programavsnitt som innehåller tonskalan måste ligga i ram-minnet inom adressområdet $00-FF, eftersom divisorn räknas ut som en offset till innehållet i A-ackumulatorn. De värden för divisorn som är angivna på raderna 108-120 avser en klockfrekvens av 1 MHz, vilket är det normala i RT-datorn. Om man har 614,4 kHz klockfrekvens (D2-kitet), får man byta ut dessa mot de värden som står inom parentes. Detta är lätt gjort om man har tillgång till en assembler/editor. 


Kodexempeln är kompilerade med [A09](https://github.com/Arakula/A09) 