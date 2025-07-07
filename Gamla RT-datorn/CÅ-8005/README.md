# CÅ-8005 Realtidsklocka
Realtidsklocka till RT-datorn. Med transistordrivna utgångar för styrning av upp till 6 reläer.

Filen CÅ-8005-schema-RT.jpg innehåller schemat saxat ur tidningen Radio & Television nr 10-1980  
Då jag gjorde schemat i KiCad upptäckte jag att databladet på kretsen MM 5318 inte har samma pin-definitioner  
som originalschemat.
Enligt schemat i tidningen RT är pin-definitionen för 2-5 följande  
* 2 = BCD-1
* 3 = BCD-2
* 4 = BCD-4
* 5 = BCD-8

Men enligt databladet är pinnarna detta:  
* 2 = BCD-8
* 3 = BCD-4
* 4 = BCD-2
* 5 = BCD-1

Filen MM5318-pins.jpg är från databladet för MM5318.

# Funktionsbeskrivning
En realtidklocka i mikrodatorn är ett ur som håller reda på den verkliga tiden uttryckt i timmar, minuter och sekunder. Den digitalklocka som här beskrivs kan matas med yttre spänning från en ackumulator. På så sätt behöver man inte ställa in rätt tid varje gång datorn startas. I fig 1 visas principschemat för digitalklockan med tillhörande oscillator och PIA-krets.  
Transistorerna används för nivåanpassning eftersom klockkretsen IC2 matas med 12 volt och PIA-kretsen ICl med 5 volt. Klockkretsen matas med 50 Hz signal från kristalloscillatorn IC3. Kristallen Xl är på 3,579545 MHz (= NTSC-systemets färgbärvågfrekvens) och dess frekvens delas i IC3 ned till 50 Hz. Kristallfrekvensen är vanlig och kristallen lätt att anskaffa. IC2 har tre ingångar för val av siffra i tidangivelsen. 

Ingångarna (DX, DY och DZ) styrs från ICl:s utgångar PA4-6. På utgångarna BCD 1-8 finns i binär form siffervärdet, som sedan avläses vid ingångarna PAO-3. De tre utgångarna PB0-2 aktiveras då klockan skall ställas på rätt tid. PB3-7 samt CB2 driver var sin transistor, som i sin tur kan driva reläer för alarm- eller styrfunktioner av olika slag.  

## Programexempel  
I fig 5 finns ett exempel på några programrutiner för att ställa klockan och att lägga ut tidangivelsen på lysdiodindikatorerna eller som en textsträng. I det senare fallet anropas en subrutin TIDSTR , varefter tiden skrivs ut på den anslutna terminalen. Programmet förutsätter att digitalklockan är placerad i kontakt J6 på datorns moderkort.  
Med kompletta byggsatser följer en kassett med programmet i fig 5 i både källkod (programlistan) och objektkod (maskinkod i SI-format). Kretskortet monteras enligt komponentförteckningen . Transistorerna Tll-T16 kan utelämnas om utgångarna ej skall användas. Skall yttre reläer anslutas, inkopplas de enligt komponentuttrycket på kortet. Reläerna skall vara avsedda för 12 volt och  bör förses med var sin skyddsdiod över reläspolen för att skydda drivtransistorerna. Kortet provar man enklast genom att mata in det visade programmet. Beroende på vilken tillämpning klockan skall få, kan programmet kompletteras med fler rutiner.