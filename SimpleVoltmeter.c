/*
 * SimpleVoltmeter.c
 *
 * Created: 25/5/2013 12:54:26
 *  Author: Sam
 */ 

#include <stdio.h>
#include "SimpleVoltmeter.h"

#include <avr/io.h>
#include <util/delay.h>

#include "hd44780.h"


int main(void) {

	// Initializations
	lcd_init();
	adc_init();
	usart_init();

	//Set Baud rate
	UBRRL = 51;
	UBRRH = (51>>8);

	// Variables
	uint16_t adcLevel;
	char fromSerial, str[64];
	char h, l;

    while(1) {

        //TODO:: Please write your application code
		fromSerial = USARTReadChar();

		if (fromSerial == 'a') {

			adcLevel = ReadADC(0);
			sprintf(str, "INT VAL= %4d", adcLevel);
			lcd_goto(0x00);
			lcd_puts(str);
			h = adcLevel/256;
			l = adcLevel;
			USARTWriteChar(h);
			USARTWriteChar(l);
			
		}
		
    }
}

uint16_t ReadADC(uint8_t __channel) {
	ADMUX |= __channel; // Channel selection
	ADCSRA |= _BV(ADSC); // Start conversion
	while (!bit_is_set(ADCSRA,ADIF))
	; // Loop until conversion is complete
	ADCSRA |= _BV(ADIF); // Clear ADIF by writing a 1 (this sets the value to 0)

	return (ADC);
}

void adc_init() {
	ADCSRA = _BV(ADEN) | _BV(ADPS2) | _BV(ADPS1) | _BV(ADPS0); //Enable ADC and set 128 prescale
}

void usart_init() {

	/* Set Frame Format
	>> Asynchronous mode
	>> No Parity
	>> 1 StopBit
	>> char size 8
	*/
	UCSRC = (1<<URSEL)|(3<<UCSZ0);

	//Enable The receiver and transmitter
	UCSRB = (1<<RXEN)|(1<<TXEN);
}

char USARTReadChar() {

	while(!(UCSRA & (1<<RXC)));

	return UDR;
}

void USARTWriteChar(char data) {

	while(!(UCSRA & (1<<UDRE)));

	UDR=data;
}