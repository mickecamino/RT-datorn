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
