/*
 * SimpleVoltmeter.h
 *
 * Created: 25/5/2013 12:54:48
 *  Author: Sam
 *
 *  Description:
 *  This is a simple voltmeter using AVR ATmega8.
 *  The DC voltage is sampled with the ADC and sent to the PC via the serial
 *  port where a MATLAB GUI plots the acquired values
 */ 


#ifndef SIMPLEVOLTMETER_H_
#define SIMPLEVOLTMETER_H_

#ifndef F_CPU
#define F_CPU 8000000
#endif

// Function Prototypes

// Read acquired value from __channel
uint16_t ReadADC(uint8_t __channel);

// ADC initialization
void adc_init();

// USART initialization
void usart_init();

// Read from serial
char USARTReadChar();

// Write to serial
void USARTWriteChar(char data);



#endif /* SIMPLEVOLTMETER_H_ */