/*
 * HelperFunctions.c
 *
 * Created: 24/5/2013 23:25:55
 *  Author: Sam
 */ 

#include <stdio.h>
#include "HelperFunctions.h"

void lcd_putf(double val, unsigned int iPart, unsigned int fPart) {

	uint16_t y = 0;
	uint8_t i;
	double f = 0.0;
	char str[10];

	f = val;
	y = f;
	f -= y;
	for (i = 0; i < fPart; i++)
	f *= 10;

	sprintf(str, "%d", y);
	lcd_puts(str);
	lcd_puts(".");
	y = f;
	sprintf(str, "%d", y);
	lcd_puts(str);

}

void lcd_gotoxy(int x, int y) {
	
	
}