#define __STDC_FORMAT_MACROS
#define __STDC_LIMIT_MACROS
#define __STDC_CONSTANT_MACROS

#include <etherbone.h>
#include <eca.h>
#include <cassert>
#include <cstdio>
#include <tlu.h>

using namespace GSI_ECA;
using namespace GSI_TLU;
std::vector<TLU> tlus;


struct MyHandler : public Handler {
  ActionQueue* aq;
  ECA* eca;
  
  status_t write(address_t address, width_t width, data_t data) {
    ActionEntry entry;
    aq->refresh();
    aq->pop(entry);
   if(entry.tag == 0x1){  
    printf("------1---------Action: 0x%"PRIx64" 0x%"PRIx64" 0x%"PRIx32" 0x%"PRIx32" %s\n",
      entry.event, entry.param, entry.tag, entry.tef,
      eca->date(entry.time).c_str());
    printf("***************2*************8\n");
    tlus[0].listen(1, true, true, 8); /* Listen channel 1 =>1MHz+1Hz*/ 
    printf("***************3*************8\n");
    fflush(stdout);

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
  Device device;
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
  //IO configuration address:0x14 0-output 1-input: 100 channel 2-0
  eb_data_t data = 0x4;
  if(status = device.write(ioconf, EB_BIG_ENDIAN|EB_DATA32, data)!= EB_OK)
  printf("IO configuration failed.\n");

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
  
  /* Wait forever, pumping out the actions as they arrive */
  while (true) socket.run();
  
  return 0;
}
