#include <stdio.h>
#include <board.h>
#include "uart.h"
#include "display.h"

volatile unsigned int* leds = (unsigned int*)0x80000014;
//volatile int i = 0;

int main() {
  /* Get uart unit address */
  discoverPeriphery();

  /* Initialize uart unit */
  uart_init_hw();
 
 //uart_init_hw();
 *leds = 0x7;

  while(1)
{
 mprintf("Hello world!\n");
 //mprintf("Hello world! i= %d\n",i);
} 

}


