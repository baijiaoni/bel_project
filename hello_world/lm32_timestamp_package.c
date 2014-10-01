#define __STDC_LIMIT_MACROS
#define __STDC_FORMAT_MACROS
//PRIX32: these macros are defined for C program. They are defined for C++ only when  __STDC_FORMAT_MACROS is defined before <inttypes.h> is included.
#define __STDC_CONSTANT_MACROS
//UINT32_C:  these macros are defined for C program. They are defined for C++ only when  __STDC_CONSTRANT_MACROS is defined before <stdint.h> is included.

#include <stdint.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mini_sdb.h"
#include "hw-tlu.h"

//using linker script ram.ld to creat share division
#define SHARED __attribute__((section(".shared")))
uint32_t SHARED time0 =  0xdeadbeef;
uint32_t SHARED time1 =  0xbabe;
uint32_t SHARED sub =  0x0;

volatile unsigned int* BASE_TLU;
volatile unsigned int* BASE_ONEWIRE;
volatile uint64_t time_SIS18 = 0;
volatile uint64_t time3 = 0;
volatile uint64_t time4 = 0;
static uint64_t estimate;

int main() {
   double scale = 1000000000; //ns
   double f0 = 1000000; //1MHz
   double rf = 100;//actural value 100Hz (10ms to realize synchronization)
   double df = 5*f0/1000000;//accuracy for function generator is 5 ppm * frequency
   unsigned long int error_fre = 0;
   unsigned long int error_tra;
   unsigned long int error;
   double f1 = (f0+rf);   //1MHz+1Hz
   double T0 = 1/f0*scale;
   double T1 = 1/f1*scale;
   double dt0 = 0.000000001*scale; //short term stability
   double dt1 = 0.000000001*scale;
   int beating;
   long int period;
   int count;
   int a=0;

  /* Get uart unit address */
  discoverPeriphery();
  /* Initialize uart unit */
  uart_init_hw();
  //BASE_TLU      = (unsigned int*)find_device_adr(GSI, TLU_DEVICE_ID);
  //*(BASE_TLU+TLU_CLEAR/4)=0x1;


  while(1)
  {
  time_SIS18 = time1;
  time_SIS18 <<= 32;
  time_SIS18 |= time0;
  time_SIS18 <<= 3;
  time_SIS18 |= sub;
  mprintf("-------9--------:0x%x------%x------%x\n",&time0,&time1,&sub);
  mprintf("-------9--------:0x%x------%x------%x\n",time0,time1,sub);
  mprintf("-------5--------:0x%08x%08x\n",time_SIS18,time_SIS18<<32); 
  mprintf("-------9--------:0x%x\n",&time_SIS18);
  }

 
}

