# CA-8008 - Analog to digital converter
To be able to process analogue signals the RT-computer needs an AD-converter. The AD-converter chosen here is working with the successive approximation and has 16 inputs.  
The measurement retrieved is an 8-bit value, with 256 steps between zero and full reading.  
The peripheral card contains a PIA (IC1) that connects the AD-converter (IC2) to the processor. IC3 is a clock oscillator, IC4 (not used here) is an extra address decoder.  
The 16 inputs has each a trim potentiometer for individual adjustments of the input values.  

Code examples are compiled with [A09](https://github.com/Arakula/A09) 