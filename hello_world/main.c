#include <stdio.h>
#include <board.h>
#include "uart.h"
#include "display.h"

volatile unsigned int* leds = (unsigned int*)0x80000014;
//volatile int i = 0;
volatile int a=0xdeadbeef;

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
 mprintf("-----------------a=0x%x; *a=%x\n",a,&a);
 //mprintf("Hello world! i= %d\n",i);
}

}


