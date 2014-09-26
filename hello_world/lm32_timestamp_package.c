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

volatile unsigned int* BASE_TLU;
volatile unsigned int* BASE_ONEWIRE;
volatile uint64_t time0 = 0x67d44d3df;
volatile uint64_t time1 = 0x67d44d424;//0x%08x%08x\n  output
volatile uint64_t time2 = 0;
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
  BASE_TLU      = (unsigned int*)find_device_adr(GSI, TLU_DEVICE_ID);
  BASE_ONEWIRE  = (unsigned int*)find_device_adr(CERN, WR_1Wire);

 *(BASE_TLU+TLU_CLEAR/4)=0x1; 

  while(1)
  {
  *(BASE_TLU+TLU_CH_SELECT/4)= 0x1;//pointer +1 to address+4
  mprintf("-------3--------:0x%08x------------%08x\n",*(BASE_TLU+TLU_CH_SELECT/4),BASE_TLU+TLU_CH_SELECT/4); 
  count = *(BASE_TLU+TLU_CH_FILL_COUNT/4);  
  mprintf("--~~~~~~2~~~~~~~~~--:0x%x----------------%x\n",count,BASE_TLU+TLU_CH_FILL_COUNT/4); 
  //if (count == 1)
  {
  mprintf("--~~~~~~~~~~~~~~~-4--\n");
 //*(BASE_TLU+TLU_CH_POP/4) = 0x1;
  time3 = *(BASE_TLU+TLU_CH_TIME1/4);//0x50
  //time2 = *(BASE_TLU+TLU_CH_TIME0/4);//0x12345678
  time4 = *(BASE_TLU+TLU_CH_TIME0/4)+(time3<<32);
  mprintf("-------5--------:0x%08x%08x\n",time4,time4<<32); 
  }
  }
   //while(1)
  //{
   // mprintf("--~~~~~~5~~~~~~~~~---:0x%x\n",count); 
   // mprintf("-------3--------:0x%08x\n",*(BASE_TLU+TLU_CH_SELECT/4)); 
 // } 


   period = f0/rf*T0;//correct %d or %u
   if (time0 >= time1){
   beating = (time1+T1-time0)/(T0-T1); //correct
   error_fre = df*df*(2*pow((1+f1*(time0-time1)/scale),2)/pow(rf,4)-2*(1+f1*(time0-time1)/scale)*(time0-time1)/scale/pow(rf,3)+pow((time0-time1)/scale,2)/pow((f1-f0),2))*scale*scale;
   error_tra = sqrt((T1*T1*dt0*dt0+T0*T0*dt1*dt1)/(T0-T1)/(T0-T1));
   }
   if (time0 < time1){
   beating = (time1-time0)/(T0-T1);
   error_fre = df*df*(2*pow((f1*(time1-time0)/scale),2)/pow((f1-f0),4)-2*(f1*(time1-time0)/scale)*(time1-time0)/scale/pow((f1-f0),3)+pow((time1-time0)/scale,2)/pow((f1-f0),2))*scale*scale; 
   error_tra = sqrt((T1*T1*dt0*dt0+T0*T0*dt1*dt1)/(T0-T1)/(T0-T1));
   }

   long int syn = beating *T0; //corrct %d or %u  (ns)
   estimate = time0 +beating * T0; 

   error = sqrt(error_tra*error_tra+ error_fre);//%u output
  // while(1)
   {
	//mprintf("================================================\n");
  	//mprintf("TLU base address is: 0x%x\n", BASE_TLU);// 0x80000100
  	//mprintf("WR-Periph-1Wire base address is: 0x%x\n", BASE_ONEWIRE);// 0x80060600
  	//mprintf("TLU time0 <=channel 0 :0x%08x%08x\n",time0,time0>>32);
        //mprintf("-------3--------:0x%08x%08x\n",time4,time4<<32); 
        //mprintf("TLU time1 <=channel 1 :0x%08x%08x\n",time1,time1>>32);
        //mprintf("Synchronization needed time: %u(ns)\n",syn);
   	//mprintf("Estimate time for alignment:0x%08x%08x\n",estimate,estimate>>32);    
      	//mprintf("Frequency error uncertainty: %u(ns)\nTransport error uncertainty:%u(ns)\nTotal error uncertainty:%u(ns)\n",   error_fre,error_tra,error);
	}
}

