#define __STDC_LIMIT_MACROS 
#define __STDC_FORMAT_MACROS
//PRIX32: these macros are defined for C program. They are defined for C++ only when  __STDC_FORMAT_MACROS is defined before <inttypes.h> is included.
#define __STDC_CONSTANT_MACROS
//UINT32_C:  these macros are defined for C program. They are defined for C++ only when  __STDC_CONSTRANT_MACROS is defined before <stdint.h> is included.
#include <etherbone.h>
#include <tlu.h>
#include <eca.h>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <unistd.h> // sleep
#include <vector>
#include <iostream>
#include <math.h>

using namespace GSI_ECA;
using namespace GSI_TLU;

static double period;
static uint64_t estimate;

static void render_time(uint64_t time) {

    printf("time:0x%"PRIx64"\n", time);

    #define BILLION 1000000000ULL
    time_t now = time / BILLION;


    double fraction = time % BILLION;
    fraction /= BILLION;
    
    struct tm *tm = gmtime(&now);
    char buf[40];
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", tm);
    
    printf("%s.%.9f\n", buf, fraction);

}

static void estimate_time(uint64_t time0, uint64_t time1) {
   double scale = 1000000000; //ns
   double f0 = 1000000; //1MHz
   double rf = 100;//actural value 100Hz (10ms to realize synchronization)
   double df = 5*f0/1000000;//accuracy for function generator is 5 ppm * frequency
   double error_fre = 0;
   double f1 = (f0+rf);   //1MHz+1Hz
   double T0 = 1/f0*scale;
   double T1 = 1/f1*scale;
   double dt0 = 0.000000001*scale; //short term stability 
   double dt1 = 0.000000001*scale;
   int beating;
   period = f0/rf*T0;
   
   printf("==============================================================\n");fflush(stdout);
   if (time0 >= time1){
   beating = (time1+T1-time0)/(T0-T1);
   error_fre = df*df*(2*pow((1+f1*(time0-time1)/scale),2)/pow(rf,4)-2*(1+f1*(time0-time1)/scale)*(time0-time1)/scale/pow(rf,3)+pow((time0-time1)/scale,2)/pow((f1-f0),2))*1000000*1000000;
   // printf("Timestamp difference:0x%"PRIx64"ns\n",time0-time1);
   printf("------------------Error propogation for frequency accuracy:%3fns\n",error_fre);
   printf ("The time difference:0x%"PRIx64"\n",time0-time1);
   //printf("-------time0 >= time1--------\n");fflush(stdout); 
   }
   if (time0 < time1){
   beating = (time1-time0)/(T0-T1);
   error_fre = df*df*(2*pow((f1*(time1-time0)),2)/pow((f1-f0),4)-2*(f1*(time1-time0))*(time1-time0)/pow((f1-f0),3)+pow((time1-time0),2)/pow((f1-f0),2))/1000/1000;
   //printf("Timestamp difference:0x%"PRIx64"ns\n",time1-time0);
   printf("~~~~~~~~~~~~~~~~~~~Error propogation for frequency accuracy:%3fns\n",error_fre);
   printf ("The time difference:0x%"PRIx64"\n",time1-time0);
   //printf("-------time0 < time1--------\n");fflush(stdout); 
   }
   
   printf("Beating number:%d\n",beating);
   double syn = beating *T0/1000000;
   printf("Synchronization time:%3fms\n",syn);
   estimate = time0 +beating * T0; // estimate alignment time
   printf("Estimate time for alignment :0x%"PRIx64"(1ns)\n",estimate);

    time_t now = estimate / BILLION;
    double fraction = estimate % BILLION;
    fraction /= BILLION;
    
    struct tm *tm = gmtime(&now);
    char buf[40];
    strftime(buf, sizeof(buf), "%Y-%m-%d %H:%M:%S", tm);
    
    printf("%s.%.9f\n", buf, fraction);
    //printf("^^^^^^^^^^^^^channel 2 timestamp\n");
   printf("==============================================================\n");fflush(stdout);
   double error = sqrt((T1*T1*dt0*dt0+T0*T0*dt1*dt1)/(T0-T1)/(T0-T1))/1000;//transfer error uncertianty
   printf ("                  measurement ||frequency accuracy || total \n");
   printf ("Error propogation %.3fus      %.3fus          %.3fus\n\n",error,sqrt(error_fre),sqrt(error_fre+error*error));
   printf ("The number of 1MHz rf within uncertainty window = %f\n",2*sqrt(error_fre+error*error)*f0/scale);
   printf("==============================================================\n");fflush(stdout);
  }

int main(int argc, const char** argv) {
  Socket socket;
  Device device;
  status_t status;

  if (argc != 2) {
    fprintf(stderr, "%s: expecting argument <device>\n", argv[0]);
    return 1;
  }

  socket.open();
  if ((status = device.open(socket, argv[1])) != EB_OK) {
    fprintf(stderr, "%s: failed to open %s: %s\n", argv[0], argv[1], eb_status(status));
    return 1;
  }
  /* Find the ECA */
  std::vector<ECA> ecas;
  ECA::probe(device, ecas);
  assert (ecas.size() == 1);
  ECA& eca = ecas[0]; 

  /* Configure ECA to create IO pulses on GPIO and LVDS */
  eca.channels[0].drain(false); // GPIO
  eca.channels[1].drain(false);  // PCIe
  eca.channels[2].drain(false); // LVDS
  eca.channels[0].freeze(false);
  //eca.channels[1].freeze(false);
  eca.channels[2].freeze(false);
  eca.disable(true);
  eca.interrupt(false);

  /* Find the TLU */
  std::vector<TLU> tlus;
  TLU::probe(device, tlus);
  assert (tlus.size() == 1);
  TLU& tlu = tlus[0];
  
  /* Configure the TLU to record rising edge timestamps */
  tlu.hook(-1, false);
  tlu.set_enable(false); // no interrupts, please
  //tlu.clear(-1);
  //status_t listen(int channel, bool enable, bool pos_edge, uint32_t stable = 8);
  tlu.listen(0, true, true, 8); /* Listen channel 0 =>1MHz*/
  tlu.listen(1, true, true, 8); /* Listen channel 1 =>1MHz+1Hz*/ 
  if ((status = tlu.clear(-1)) != EB_OK) //make two channels begin at same time point
  printf("---------error0------------\n");fflush(stdout);

  /* Find the IO reconfig */
  std::vector<sdb_device> devs;
  device.sdb_find_by_identity(0x651, 0x4d78adfdU, devs);
  assert (devs.size() == 1);
  address_t ioconf = devs[0].sdb_component.addr_first + 4;
  //IO configuration address:0x14 0-output 1-input: 100 channel 2-0
  eb_data_t data = 0x4;
  if(status = device.write(ioconf, EB_BIG_ENDIAN|EB_DATA32, data)!= EB_OK)
  printf("IO configuration failed.\n");
         
  /* Read-out result */     
    printf("==============================================================\n");fflush(stdout);
    uint64_t time0;
    uint64_t time1;
    if ((status = tlu.pop(0, time0)) != EB_OK)
    {
    printf("---------error1------------\n");fflush(stdout); 
    }
    render_time(time0); 
    printf("-------------channel 0 timestamp\n");

    if ((status = tlu.pop(1, time1)) != EB_OK)
    {
    printf("---------error2------------\n");fflush(stdout); 
    }
    render_time(time1); 
    printf("**************channel 1 timestamp\n");

    estimate_time(time0, time1);

  Table table;
  printf ("Period of synchronization is :%.3fns\n",period); 
  for (int i = 0; i < 16; ++i) {
    /* synchronization event */
  table.add(TableEntry(0xdeadbeef, i*period/8,             0x00fff000U, 2, 64));//ECA 8ns step
  table.add(TableEntry(0xdeadbeef, i*period/8 + period/16, 0x00000fffU, 2, 64));//channel 2 high: 0x00 fff000 low:0x00 000fff other:0xffff0000

  }
  eca.store(table);
  eca.flipTables();

   eca.disable(false);
   /* Generate pulse  */
    eca.refresh();
    printf("ECA current time :0x%"PRIx64"(8ns)\n",eca.time);
    render_time(eca.time*8);
   // printf("Estimate time for alignment :0x%"PRIx64"(8ns)\n",estimate/8);//TLU in 1ns step; ECA in 8ns step

    eca.streams[0].send(EventEntry(0xdeadbeef, 0, 0, estimate/8));//send <event> <param> <tef> <time>  write to an event stream


  return 0;
}
