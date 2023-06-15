# Analog-digitalomvandlare
För att kunna ta hand om analoga signaler måste RT-datorn förses med ed A/D-omvandlare. Den omvandlare som här beskrivs arbetar enligt principen successiv approximation och har 16 ingångar. Mätvärdet får man som ett åttabitarsvärde och det blir alltså 256 steg mellan noll och fullt utslag.

Periferikortet innehåller en PIA-krets (IC1) som ansluter A/D-omvandlaren (IC2) till mikroprocessorn. IC3 är klockfrekvensoscillator och IC4 är en extra adressavkodning som normalt ej behövs.

De sexton ingångarna har försetts med  var sin trimpotentiometer för att individuellt kunna justera lämpligt värde och få anpassning till de olika inspänningarna.
