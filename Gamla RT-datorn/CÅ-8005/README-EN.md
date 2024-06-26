# CA-8005 Real Time Clock
Real time Clock for the RT-computer. With tranistor driven outputs for controlling up to 6 relays.  

the file CÅ-8005-schema-RT.jpg contains the schematic for the magazine Radio & Television no 10-1980.  
When I created the schematic in KiCad I discovered that the data sheet for the IC MM 5318 differs against the schematic in the magazine.  
According to the schematic in the magazine the pin definitition for pins 2-5 are as follows:  
* 2 = BCD-1
* 3 = BCD-2
* 4 = BCD-4
* 5 = BCD-8

Accoring to the data sheet the pin definitions are as follows:  
* 2 = BCD-8
* 3 = BCD-4
* 4 = BCD-2
* 5 = BCD-1

The file MM5318-pins.jpg are a cpy form the data sheet for MM5318.
