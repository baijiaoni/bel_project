#define __STDC_FORMAT_MACROS
#define __STDC_LIMIT_MACROS
#define __STDC_CONSTANT_MACROS

#include <etherbone.h>
#include <eca.h>
#include <cassert>
#include <cstdio>
#include <tlu.h>
#include <pthread.h>
#include <semaphore.h>
#include "hw-tlu.h"

using namespace GSI_ECA;
using namespace GSI_TLU;

Device device;
std::vector<TLU> tlus;
sem_t s_tlu_ready;
pthread_t send_pkg;
address_t EM_base_address;

//etherbone master transfer package to DM or RN
void *EM_pkg (void * arg)
  {
    uint64_t time0 = 0;
    uint64_t time1 = 0;
    //get timestamp from TLU
    if(device.read(tlus[0].address + TLU_CH_TIME1, EB_BIG_ENDIAN|EB_DATA32, &time0)!= EB_OK)
      printf("1 IO configuration failed.\n");
    if(device.read(tlus[0].address + TLU_CH_TIME0, EB_BIG_ENDIAN|EB_DATA32, &time1)!= EB_OK)
      printf("1 IO configuration failed.\n");
    printf("EM thread: get timestamp of zero-crossing point from TLU:0x%08x%08x\n",time0,time1);
    //Etherbone master send timesatmp to another RN
    if(device.write(EM_base_address + 0xCe0000, EB_BIG_ENDIAN|EB_DATA32, time0)!= EB_OK)
      printf("3 IO configuration failed.\n");
   // if(device.write(EM_base_address + 0xC00014, EB_BIG_ENDIAN|EB_DATA32, 0x0)!= EB_OK)
    if(device.write(EM_base_address + 0xCe0004, EB_BIG_ENDIAN|EB_DATA32, time1)!= EB_OK)
      printf("7 IO configuration failed.\n");
    if(device.write(EM_base_address+0x04, EB_BIG_ENDIAN|EB_DATA32, 0x0001)!= EB_OK)
      printf("8 IO configuration failed.\n");
    return ((void *)0);

  }

//Trigger TLU get timestamp of zero-crossing point of rf signal
struct MyHandler : public Handler {
  ActionQueue* aq;
  ECA* eca;
  int tmp;

  status_t write(address_t address, width_t width, data_t data) {
    ActionEntry entry;
    aq->refresh();
    aq->pop(entry);
   if(entry.tag == 0x1){
    printf("ECA Action: 0x%"PRIx64" 0x%"PRIx64" 0x%"PRIx32" 0x%"PRIx32" %s\n",
      entry.event, entry.param, entry.tag, entry.tef,
      eca->date(entry.time).c_str());
    tlus[0].listen(1, true, true, 8); /* Listen channel 1 =>1MHz+1Hz*/
    fflush(stdout);
  if((tmp = pthread_create(&send_pkg, NULL, &EM_pkg, NULL))!= 0)
  {
    printf("the Etherbone master produce pkg thread is error\n");
  }

    }
    return EB_OK;
  }
  status_t read(address_t address, width_t width, data_t* data) {
    return EB_OK;
  }
};


struct sdb_device mydevice = {
  0, 0, 0, SDB_WISHBONE_WIDTH,
  { 0, 0,
  { 0x651, 0xdeadbeef, 1, 0x20140516, "Debug device      ", sdb_record_device
}}};

int main(int argc, const char** argv) {
  Socket socket;
  MyHandler handler;
  status_t status;

  /* Setup connection to FPGA via PCIe */
  socket.open();
  socket.passive("dev/wbs0");
  device.open(socket, "dev/wbm0");

  /* Find the IO reconfig */
  std::vector<sdb_device> dev2;
  device.sdb_find_by_identity(0x651, 0x4d78adfdU, dev2);
  assert (dev2.size() == 1);
  address_t ioconf = dev2[0].sdb_component.addr_first + 4;
  //IO configuration address:0x14 1-output(red) 0-input(blue): 100 channel 2-0
  eb_data_t data = 0x0;
  if(status = device.write(ioconf, EB_BIG_ENDIAN|EB_DATA32, data)!= EB_OK)
  printf("IO configuration failed.\n");

  /* Find the Etherbone master */
  std::vector<sdb_device> Etherbone_master;
  device.sdb_find_by_identity(0x651, 0x00000815, Etherbone_master);
  assert (Etherbone_master.size() == 1);
  EM_base_address = Etherbone_master[0].sdb_component.addr_first;
  printf("etherbone master base address = %x;\n",EM_base_address);
  //Etherbone master configuration
  //configure source mac address  dev/wbm0
  if(status = device.write(EM_base_address+0x00, EB_BIG_ENDIAN|EB_DATA32, 0x00267b00)!= EB_OK)
  printf("1 IO configuration failed.\n");
  if(status = device.write(EM_base_address+0x10, EB_BIG_ENDIAN|EB_DATA32, 0x0407)!= EB_OK)
  printf("2 IO configuration failed.\n");
  //configure source ip address
  if(status = device.write(EM_base_address+0x14, EB_BIG_ENDIAN|EB_DATA32, 0xC0A80107)!= EB_OK)
  printf("3 IO configuration failed.\n");
  //configure source port
  if(status = device.write(EM_base_address+0x18, EB_BIG_ENDIAN|EB_DATA32, 0x0000EBD1)!= EB_OK)
  printf("4 IO configuration failed.\n");
  //configure target mac address dev/ttyUSB0
  if(status = device.write(EM_base_address+0x1C, EB_BIG_ENDIAN|EB_DATA32, 0x00267b00)!= EB_OK)
  printf("IO configuration failed.\n");
  if(status = device.write(EM_base_address+0x20, EB_BIG_ENDIAN|EB_DATA32, 0x0418)!= EB_OK)
  printf("6 IO configuration failed.\n");
  //configure target ip address
  if(status = device.write(EM_base_address+0x24, EB_BIG_ENDIAN|EB_DATA32, 0xC0A80118)!= EB_OK)
  printf("7 IO configuration failed.\n");
  //configure target port
  if(status = device.write(EM_base_address+0x28, EB_BIG_ENDIAN|EB_DATA32, 0x0000EBD0)!= EB_OK)
  printf("8 IO configuration failed.\n");
  //configure packet length
  if(status = device.write(EM_base_address+0x2C, EB_BIG_ENDIAN|EB_DATA32, 0x50)!= EB_OK)
  printf("9 IO configuration failed.\n");
  //configure target module
  if(status = device.write(EM_base_address+0x30, EB_BIG_ENDIAN|EB_DATA32, 0xe0000)!= EB_OK)
  printf("10 IO configuration failed.\n");




 /* Find the TLU */

  TLU::probe(device, tlus);
  assert (tlus.size() == 1);
  TLU& tlu = tlus[0];

  /* Configure the TLU to record rising edge timestamps */
  tlu.hook(-1, false);
  tlu.set_enable(false); // no interrupts, please
  //tlu.clear(-1);
  //status_t listen(int channel, bool enable, bool pos_edge, uint32_t stable = 8);
  if ((status = tlu.clear(-1)) != EB_OK) //make two channels begin at same time point
  printf("---------error0------------\n");fflush(stdout);

  /* Find the ECA */
  std::vector<ECA> ecas;
  ECA::probe(device, ecas);
  assert (ecas.size() == 1);
  ECA& eca = ecas[0];

  assert (eca.channels.size() >= 2);
  assert (!eca.channels[1].queue.empty());
  handler.eca = &eca;
  handler.aq = &eca.channels[1].queue.front();

  /* Stop the ECA for now */
  eca.disable(true);
  eca.channels[1].drain(true);



  /* Program a catch all to channel 1 rule */
  Table table;
  //TableEntry: event time tag channel event_bits
  table.add(TableEntry(0x1111111100000000, 25000000, 0x01, 1, 64));
  eca.store(table);
  eca.flipTables();




  /* Flush any crap pending in the AQ */
  ActionEntry ae;
  while (1) {
    handler.aq->refresh();
    if (!handler.aq->queued_actions) break;
    handler.aq->pop(ae);
  }

  /* Hook arrival interrupts via PCIe */
  std::vector<struct sdb_device> devs;
  device.sdb_find_by_identity(0x651, 0x8a670e73, devs);
  assert (devs.size() == 1);
  mydevice.sdb_component.addr_first = devs[0].sdb_component.addr_first;
  mydevice.sdb_component.addr_last  = devs[0].sdb_component.addr_last;
  socket.attach(&mydevice, &handler);

  /* Enable interrupt delivery to us */
  handler.aq->hook_arrival(true, mydevice.sdb_component.addr_first);
  eca.channels[1].freeze(false);
  eca.channels[1].drain(false);
  eca.interrupt(true);
  eca.disable(false);

  uint64_t start = eca.time + 250000000;
  //simulate a timing event to trigger TLU work
  //EventEntry: event param tef time
  eca.streams[0].send(EventEntry(0x1111111100000000, 0, 0, start));

  /* Wait forever, pumping out the actions as they arrive */
  while (true) socket.run();

  return 0;
}
