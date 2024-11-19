# CÅ-8018 - IEEE-488-bus anpassning
Specialkort för IEEE-488 buss gör RT-datorn till mätdator.  
Här visar vi hur man bygger ett kretskort för anpassning av RT-datorn till instrumentbussen lEEE-488.  
Bussen, som även kallas HP-lP och GPlB, finns idag i en rad instrument.  
Datorn, med 6800 och 6809 mikroprocessorer, är tidigare beskriven i RT liksom i boken Bygg själv datorer.  

Alltfler mätinstrument bestyckas med mikroprocessorer och får därmed en viss form av inbyggd intelligens. Nya instrumenttyper kan också styras av en dator, vilket blir allt vanligare i system för automatisk provning av komponenter och färdiga produkter. Det vanligaste gränssnittet för sammankoppling av mätinstrument och datorer kallas IEEE-488-buss.
Gränssnittet har utvecklats av bland andra den stora amerikanska instrumenttillverkaren Hewlett-Packard, som kallar den för HP-bus eller HP-IB . 
En annan vanlig benämning är GPIB , vilket betyder General Purpose Interface Bus. Ytterligare en är IEC-buss. Två typer av kontakter förekommer. För IEEE-488-bussen
används 24-poliga kontakter enl fig I. Tack vare att kontakterna går att stapla på varandra kan ett stort antal instrument kopplas ihop i en lång rad . I fig 2 visas kopplingen av de olika signalerna i kontakten. Data överförs på åtta ledare i parallellform. Tre ledare (RFD , DAV och DAC) styr överföringen och fem ledare (ATN, SRQ. IFE, REN och EOI) är kontrollsignaler.
Med en dator kan de anslutna instrumenten styras enligt ett uppgjort program för att underlätta mätningar och för ökad noggrannhet vid upprepade mätningar av samma slag.
Här visar vi hur man bygger ett anpassningskort för anslutning av IEEE-488-bussen till den i RT tidigare beskrivna datorn, uppbyggd kring Motorolas 6800/6809-processorer. Datorprojektet redovisas även i "Bygg själv Datorer" från specialtidningsförlaget.  
Elektrisk funktion  
Principschemat återges i fig 3.  
Längst till vänster ser vi de signaler som finns på RT-datorns periferikontakter. IC1 är en speciell krets från Motorola med beteckningen MC 68488. Kretsen tar hand om all kommunikation mellan mikroprocessorn och IEEE-488-bussen. IC2 är en åttabitars datadrivkrets som kopplar in SI då programmet skall läsa in den adress som anpassningskortet skall ha i IEE-488 bussystemet. De fem lägsta bitarna D0-D4 anger den adress som är unik för varje instrument och de tre högsta bitarna är lediga för egna parametrar som t ex "talk only" eller " listen only" funktion . De fyra kretsarna IC4-7 anpassar IC1 till de för IEEE-488-bussen gällande nivåer och impedans.  
I fig 4 återges kretskortet sett från foliesidan i skala 1:1. Komponentplaceringen framgår av fig 5. Vid J1 skall man ansluta en 24-polig kontakt. Den kan monteras i datorlådan och förbindas med kortet över en flatkabel eller likn.  
