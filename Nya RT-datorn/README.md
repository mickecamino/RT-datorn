# Nya RT-datorn
## En 6809-dator designad av Åke Holm (CÅ-Elektronik) på 80-talet. Den presenterades i tidningen Radio & Television, därav namnet RT-datorn.
### Med tillstånd av Åke Holm att publicera alla detaljer om RT-datorn

## Följande kort fanns till den "nya" RT-datorn:

* CÅ-812 - CPU-kort  
På processorkortet finns ett statiskt RAM som ligger på adress $C000 - DFFF.  
Dessutom finns det två socklar där man kan plugga in EPROM som då kommer att ligga mellan $F000 och FFFF. På kortet sker även avkodning av periferikretsarna som finns på $E000 och $E0FF Ett extra RAM ligger mellan $E100 och $E3FF vilket med fördel kan användas av monitor och terminalprogram utan konflikt med operativsystemet Flex.
På kortet sker även avkodning av perifierikretsarna som finns på $E000 - $E0FF.

* CÅ-813 - kommunikation  
Det nya kortet för seriekommunikation heter CÅ-813 och det ersätter de äldre korten 8001, 8014 och 8015.  
Här finns en programmeringsbar seriekommunikationskrets med V24-snitt, en skrivarutgång av parallelltyp (Centronics) och en realtidsklocka med batteriuppbackning.
Anslutningen av skrivare sker med en 60-polig flatkabelkontakt. Av dessa ledare går 36 till skrivaren och 24 till V24-kontakten.

* CÅ-814 - minneskort  
Minneskortet 814 ersätter CÅ-6848. Det är helt identiskt med undantag av att "refreshen" för de dynamiska minneskretsarna sker kontinuerligt i stället för som tidigare med 32 kHz. Minneskortet är på 48 kB.

* CÅ-815 - Video-terminalkort  
Terminalkortet är en helt ny konstruktion. Det är en sk. minnesmappad terminal med 24 rader om vardera 80 tecken. På kortet finns en CRT-kontrollkrets (Motorola MC 6845), bildminne samt en PIA för anslutning av tangentbord över en 26-polig kontakt. Den har samma koppling som den i byggboken beskrivna terminalen.
Bildminnet ligger mellan $E800 och $EFFF och processorn på kort 812 tar hand om terminalfunktionerna. All teckenhantering mellan "dator"- och "terminaldel" sker utan inblandning av seriekommunikationskretsar. Förloppet är därför mycket snabbare än tidigare. Terminalens teckenuppsättning är svensk. 

* CÅ-816 - EPROM-kort  
Kort för 16 st 2532 EPROM, detta ger 64 kB med permanent programminne.

* CÅ-817 - Flexskivekort  
För anslutning av upp till 4 st 360 kB enkel eller dubbelsidiga diskettenheter.

* CÅ-831 - Terminalkort enkelt  
Hexadecimalt terminalkort med PIA för labbfunktioner.

* CÅ-833 - kommunikation  
Ett nyare kort I/O som ersätter CÅ-813.  
Här finns en programmeringsbar seriekommunikationskrets med V24-snitt, en skrivarutgång av parallelltyp (Centronics) och en realtidsklocka med batteriuppbackning.

* CÅ-834 - minneskort  
Nytt kort med plats för 24 st 2k minnes-kretsar, 6116 och/eller 2716 EPROM. Ersätter CÅ-814.

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
      1k reserv
$E400 ----------------------------
      768 bytes RAM        CRT 812
$E100 ----------------------------
      CRTC + PIA           CRT 815
$E0F0 ----------------------------
      reserv
$E0BF ----------------------------
      EPROM-kort               816
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