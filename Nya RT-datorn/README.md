# Nya RT-datorn
## En 6809-dator designad av Åke Holm (CÅ-Elektronik) på 80-talet. Den presenterades i tidningen Radio & Television, därav namnet RT-datorn.
### Med tillstånd av Åke Holm att publicera alla detaljer om RT-datorn

## Följande kort fanns att tillgå för den "nya" RT-datorn:

* CÅ-812A - CPU-kort
På processorkortet finns ett statiskt RAM som ligger på adress $C000 - DFFF.
Dessutom finns det två socklar där man kan plugga in EPROM som då kommer att ligga mellan $F000 och FFFF. På kortet sker även avkodning av periferikretsarna som finns på $E000 och $E0FF Ett extra RAM ligger mellan $E100 och $E3FF vilket med fördel kan användas av monitor och terminalprogram utan konflikt med operativsystemet Flex

* CÅ-813 - kommunikation
Det nya kortet för seriekommunikation heter CÅ-813 och det ersätter de äldre korten 8001, 8014 och 8015.
Här finns även en programmeringsbar seriekommunikationskrets med V24-snitt, en skrivarutgång av parallelltyp
(Centronics) och en realtidsklocka med batteriuppbackning.

* CÅ-814 - minneskort
Minneskortet 814 ersätter 6848. Det är helt identiskt med undantag av att "refreshen" för de dynamiska minneskretsarna sker kontinuerkigt i ställer för som tidigare med 32 kHz. Minneskorten är på 49 kb.

* CÅ-815 - Video-terminalkort
Videoterminalkortet med 24 rader om 80 tecken. Ingång för ASCII-tangentbord och utgång för 6 st status-LED. Bildminnet ligger mellan adresserna $E800 oc $EFFF.

* CÅ-816 - EPROM-kort
Kort för 16 st 2532 EPROM, detta ger 64 kb med permanent programminne.

* CÅ-817 - Diskett-interface
För anslutning av upp till 4 st 360 kb enkel eller dubbelsidiga diskettenheter.

* CÅ-831 - Terminalkort enkelt
Hexadecimalt terminalkort med PIA för labbfunktioner.
