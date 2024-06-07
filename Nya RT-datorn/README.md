# Nya RT-datorn
## En 6809-dator designad av Åke Holm (CÅ-Elektronik) på 80-talet. Den presenterades i tidningen Radio & Television, därav namnet RT-datorn.
### Med tillstånd av Åke Holm att publicera alla detaljer om RT-datorn

## Följande kort fanns till den "nya" RT-datorn:

* CÅ-812 - CPU-kort  
På processorkortet finns ett statiskt RAM som ligger på adress $C000 - DFFF.  
Dessutom finns det två socklar där man kan plugga in EPROM som då kommer att ligga mellan $F000 och FFFF. På kortet sker även avkodning av perifierikretsarna som finns på $E000 - $E0FF. Ett extra RAM ligger mellan $E100 och $E3FF vilket med fördel kan användas av monitor och terminalprogram utan konflikt med operativsystemet Flex.


* CÅ-813 - kommunikation  
Det nya kortet för seriekommunikation heter CÅ-813 och det ersätter de äldre korten 8001, 8014 och 8015.  
Här finns en programmeringsbar seriekommunikationskrets med V24-snitt, en skrivarutgång av parallelltyp (Centronics) och en realtidsklocka med batteriuppbackning.
Anslutningen av skrivare sker med en 60-polig flatkabelkontakt. Av dessa ledare går 36 till skrivaren och 24 till V24-kontakten.  
Se även CÅ-833

* CÅ-814 - minneskort  
Minneskortet 814 ersätter CÅ-6848. Det är helt identiskt med undantag av att "refreshen" för de dynamiska minneskretsarna sker kontinuerligt i stället för som tidigare med 32 kHz. Minneskortet är på 48 kB.  
Se även CÅ-834

* CÅ-815 - Video-terminalkort  
Terminalkortet är en helt ny konstruktion. Det är en sk. minnesmappad terminal med 24 rader om vardera 80 tecken. På kortet finns en CRT-kontrollkrets (Motorola MC 6845), bildminne samt en PIA för anslutning av tangentbord över en 26-polig kontakt. Den har samma koppling som den i byggboken beskrivna terminalen.
Bildminnet ligger mellan $E800 och $EFFF och processorn på kort 812 tar hand om terminalfunktionerna. All teckenhantering mellan "dator"- och "terminaldel" sker utan inblandning av seriekommunikationskretsar. Förloppet är därför mycket snabbare än tidigare. Terminalens teckenuppsättning är svensk. 

* CÅ-816 - EPROM-kort  
Det nya EPROM-kortet heter 816 och har plats för 16 EPROM-kretsar av typ 2532 som vardera rymmer 4 kbit. Man kan alltså ha upp till 64 kbit fast (resident) programminne i datorn. 
Där kan man lagra t.ex. operativsystem eller Basic-tolk. Hela minnet når man genom att gå till en adress. Med en programrutin flyttar man så ned data från EPROM-minnet till datorns arbetsminne.  
Kortet ersätter 8025-kortet.  
Se även CÅ-836  

* CÅ-817 - Flexskivekort  
Drivkretsarna för flexskiveminnet finns på kortet 817 som helt motsvarar det i byggboken beskriva kortet 8017. Det är avsett för anslutning av upp till fyra enkel- eller dubbelsidiga drivenheter (5 1/4") med enkel (ej dubbel) packningstäthet.

* CÅ-831 - Terminalkort enkelt  
Den enkla hexadecimala terminalen 8006 har fått en efterföljare 831 som förutom lysdiodsindikatorer och tangentbord även har en PIA-krets för labuppkopplingar.

* CÅ-833 - kommunikation  
Ett nyare kort I/O som ersätter CÅ-813.  
Här finns en programmeringsbar seriekommunikationskrets med V24-snitt, en skrivarutgång av parallelltyp (Centronics) och en realtidsklocka med batteriuppbackning.

* CÅ-834 - minneskort  
Nytt kort med plats för 24 st 2k minnes-kretsar, 6116 och/eller 2716 EPROM. Ersätter CÅ-814.  

* CÅ-836 - 192 kb EPROM-kort med 1 kb RAM.  
Ett nytt kort till RT-datorn, designat av mig. Tre 27512 EPROM ger 192 kb fast (resident) programminne i datorn, 1 kb RAM adresserat på $E400-E7FF ger plats för kommandotabell.  
Med ett omskrivet program från MPU-laren 1983-2 skapar man en kommandotabell till FLEX för snabbare åtkomst till program utan access till diskett.  
FLEX kan också lagras på detta kort och snabbt laddas med CBUG-kommandot X. OBS, kräver den uppdaterade CBUG'en CBUG4.4.  

* CÅ-837 - Flexskivekort med stöd för Double Density  
Ersätter CÅ-817


### Minnesmappning
```
Adres Funktion             kort
$FFFF ----------------------------
      2k EPROM             CPU 812
$F800 ----------------------------
      2k EPROM             CPU 812
$F000 ----------------------------
      2k bildskärms-RAM    CRT 815
$E800 ----------------------------
      1k RAM                   836
$E400 ----------------------------
      768 bytes RAM        CRT 812
$E100 ----------------------------
      CRTC + PIA           CRT 815
$E0F0 ----------------------------
      reserv
$E0DF ----------------------------
      EPROM #3             816/836
$E0D0 ----------------------------
      EPROM #2             816/836
$E0C0 ----------------------------
      EPROM-kort #1        816/836
$E0B0 ----------------------------
      reserv
$E01F ----------------------------
      flexkontrollkort FDC 817/837
$E010 ---------------------------
      in/ut-kort           813/833
$E000 ----------------------------
      8k statiskt RAM      CPU 812
$C000 ----------------------------
      48k dynamiskt RAM    814/834
$0000 ----------------------------
```