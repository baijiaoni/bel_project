#include <stdint.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#include "mini_sdb.h"
#include "hw-tlu.h"

volatile unsigned int* BASE_TLU;
volatile unsigned int* BASE_ONEWIRE;

int main() {

  discoverPeriphery();
  BASE_TLU      = (unsigned short*)find_device_adr(GSI, TLU);
  BASE_ONEWIRE  = (unsigned int*)find_device_adr(CERN, WR_1Wire);
  mprintf("TLU base address is: 0x%x\n", BASE_TLU); 
 
}
