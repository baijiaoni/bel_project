//#include <stdio.h>
//
//int main{
// printf("--------------------------test\n");
//}

#include <stdint.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#include "display.h"
#include "irq.h"
#include "scu_bus.h"
#include "aux.h"
#include "mini_sdb.h"
#include "board.h"
#include "uart.h"
#include "w1.h"
#include "fg.h"
#include "cb.h"

//#define DEBUG
//#define FGDEBUG
//#define CBDEBUG



int main(void) {

  uart_init_hw();
while(true)
{
  mprintf("Hello world!!!!");
}

 
  return(0);
}
