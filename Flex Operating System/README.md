# Flex Operating System
## Hur man läser FLEX-skivor med hjälp av GreaseWeazly
Följande verktyg hämtas och installeras/packas upp:  
  
SWTPC 6808/6809 Emulator: http://www.evenson-consulting.com/swtpc/default.htm  
Gå till Download / Upgrades och hämta hem ZIP-filen eller EXE-filen Complete Setup  
  
HxC Floppy Emulator: https://hxc2001.com/download/floppy_drive_emulator  
Bläddra ner till Software och ladda hem filen HxCFloppyEmulator_soft.zip  
  
GreaseWeazle: https://github.com/keirf/greaseweazle/wiki  
Ladda hem Host Tools och installera  
OBS! Du behöver någon av hårdvaruenheterna för att använda GreaseWeazle 

flex.cfg: konfigurationsfilen finns i denna mapp.  

För att läsa disketten anslut en diskettstationupp till GreaseWeazly, stoppa i skivan du vill kopiera, glöm inte skrivskyddet på skivan.  
Börja med att läsa skivan som en enkelsidig, enkel densitet, 35 spår:  
gw read --diskdefs flex.cfg --format flex.sssd.35 flex.img  
  
Öppna sedan imagen med HcXFloppyEmulator, klicka på Load Raw Image, Load Raw File, bläddra efter filen du precis skapade, klicka sen på Track Analyzer.  
Håll musen över tredje gröna fältet och skriv av värdena för position $26 och $27, omvandla från HEX till decimalt och ni ser max antal spår och sektorer.  

| Pos 26  | Pos 27  |     Typ av diskett      | Konfig för GW |
| ------- | ------- | ----------------------- | ------------- |
|   $22   |   $0A   | 35 spår, enkelsidig     | flex.sssd.35  |
|   $27   |   $0A   | 40 spår, enkelsidig     | flex.sssd.40  |
|   $27   |   $14   | 40 spår, dubbelsidig    | flex.dssd.40  |
  
Tabellen kommer att utökas och flex.cfg kommer att få fler definitioner.

Tredje sektorn innehåller System Information Record (SIR) och den har följande layout:

| offset(hex) | size(hex) | contents
| ----------- | --------- | ------------------------- |
|    $10      |    $0B    |  Volume Label             |
|    $1B      |    $01    |  Volume Number High byte  |
|    $1C      |    $01    |  Volume Number Low byte   |
|    $1D      |    $01    |  First User Track         |
|    $1E      |    $01    |  First User Sector        |
|    $1F      |    $01    |  Last User Track          |
|    $20      |    $01    |  Last User Sector         |
|    $21      |    $01    |  Total Sectors High byte  |
|    $22      |    $01    |  Total Sectors Low byte   |
|    $23      |    $01    |  Creation Month           |
|    $24      |    $01    |  Creation Day             |
|    $25      |    $01    |  Creation Year            |
|    $26      |    $01    |  Max Track                |
|    $27      |    $01    |  Max Sector               |

Position $26 och $27 innehåller värde för antalet spår och sektorer, baserat på det kan man få fram vilken typ av diskett det är.