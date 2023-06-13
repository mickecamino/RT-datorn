# RT-datorn
## En 6809-dator designad av Åke Holm (CÅ-Elektronik) på 80-talet. Den presenterades i tidningen Radio & Television, därav namnet RT-datorn.
### Med tillstånd av Åke Holm att publicera alla detaljer om RT-datorn
Två versioner finns av denna dator:

Den "gamla" som publicerades i ett antal artiklar i tidningen Radio & Television

Den "nya" som fanns i en artikel i tidningen Elektronikvärlden nr 4 1983.

## Följande kort fanns till den "gamla" RT-datorn:
* CÅ-800 - moderkort
* CÅ-6819 - CPU-kort
* CÅ-6864 - Videoterminal
* CÅ-8001 - ACIA, 2 st serieportar
* CÅ-8002 - PIA, 2 parallella portar
* CÅ-8003 - KCS-modem 300/1200 baud
* CÅ-8004 - Programmerbar timer med 6840
* CÅ-8005 - Digitalklocka med MM5318
* CÅ-8006 - HEX-display & tangenter
* CÅ-8008 - 16 ingångars 8-bitars A/D-omvandlare
* CÅ-8010 - EPROM-programmerare
* CÅ-8013 - Korthållsmodem 300 baud
* CÅ-8016 - Ljudeffektskrets med SN76477
* CÅ-8017 - Flexskivekort
* CÅ-8018 - IEEE-488-bus anpassning
* CÅ-8020 - DEBUG-kort
* CÅ-8025 - EPROM-kort
* CÅ-8027 - Flyttalsprocessor AM9511
* CÅ-8043 - Färg-tv som dataskärm
* CÅ-8091 - Lab-kort med PIA
* CÅ-8092 - Lab-kort för ACIA/SSDA/ADLC
* CÅ-8095 - Förlängningskort för 22-polig buss
* CÅ-9000 - Förlängningskort för CPU-kort


## Följande kort fanns till den "nya" RT-datorn:

* CÅ-812A - CPU-kort
På processorkortet finns ett statiskt RAM som ligger på adress $C000 - DFFF.
Dessutom finns det två socklar där man kan plugga in EPROM som då kommer att ligga mellan $F000 och FFFF. På kortet sker även avkodning av periferikretsarna som finns på $E000 och $E0FF Ett extra RAM ligger mellan $E100 och $E3FF vilket med fördel kan användas av monitor och terminalprogram utan konflikt med operativsystemet Flex

* CÅ-813 - kommunikation
Det nya kortet för seriekommunikation heter CÅ-813 och det ersätter de äldre korten 8001, 8014 och 8015.
Här finns även en programmeringsbar seriekommunikationskrets med V24-snitt, en skrivarutgång av parallelltyp
(Centronics) och en realtidsklocka med batteriuppbackning.

* CÅ-814 - minneskort
Minneskortet 814 ersätter 6848. Det är helt identiskt med undantag av att "refreshen" för de dynamiska minneskretsarna sker kontinuerkigt i ställer för som tidigare med 32 kHz. Minneskorten är på 48 kb.

* CÅ-815 - Video-terminalkort
Videoterminalkortet med 24 rader om 80 tecken. Ingång för ASCII-tangentbord och utgång för 6 st status-LED. Bildminnet ligger mellan adresserna $E800 oc $EFFF.

* CÅ-816 - EPROM-kort
Kort för 16 st 2532 EPROM, detta ger 64 kb med permanent programminne.

* CÅ-817 - Diskett-interface
För anslutning av upp till 4 st 360 kb enkel eller dubbelsidiga diskettenheter.

* CÅ-831 - Terminalkort enkelt
Hexadecimalt terminalkort med PIA för labbfunktioner.
