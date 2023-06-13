# CÅ-8004
Detta periferikort består av en timer, MC6840 från Motorola och två små förstärkare för ljudutgång.
Utgångarna 1-3 används för att generera toner.
Ett kodexempel finns som spelar en Mozart-vals är skapat av Åke Holm, filen heter univkort.asm. 
Tidkretsen innehåller tre 16-bitars räknare som kan programmeras på ett flertal sätt.
I RT-datorn används det för "printer spooling" i FLEX 2.0 eller FLEX 9.0.
Det fungerar genom en rutin i FLEX kallad PRINT. rutinen initierar tidkretsen så att den ger ett periodiskt avbrott under vilken skrivarens utskriftsprogram tas om hand.
Förutsättningen för funktionen är att det program som man själv kör inte använder IRQ-vektorn, samt att ingen åverkan får göras på de textfiler vilka ska skrivas ut på skrivaren. Det förutsätts också att skrivaren är ansluten till en egen ACIA på kortet CÅ-8001.
