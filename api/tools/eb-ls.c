/** @file eb-ls.c
 *  @brief A tool which lists all devices attached to a remote Wishbone bus.
 *
 *  Copyright (C) 2011-2012 GSI Helmholtz Centre for Heavy Ion Research GmbH 
 *
 *  A complete skeleton of an application using the Etherbone library.
 *
 *  @author Wesley W. Terpstra <w.terpstra@gsi.de>
 *
 *  @bug None!
 *
 *******************************************************************************
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 3 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *  
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library. If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************
 */

#define _POSIX_C_SOURCE 200112L /* strtoull */

#include <stdio.h>
#include <stdlib.h>
#include "../etherbone.h"

static void list_devices(eb_user_data_t user, sdwb_t sdwb, eb_status_t status) {
  int i, devices;
  int* stop = (int*)user;
  *stop = 1;
  
  if (status != EB_OK) {
    fprintf(stderr, "Failed to retrieve SDWB: %s\n", eb_status(status));
    return;
  } 
  
  fprintf(stdout, "SDWB Bus\n");
  fprintf(stdout, "  magic:           %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n" 
                  "                   %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n", 
                  sdwb->bus.magic[ 0], sdwb->bus.magic[ 1],
                  sdwb->bus.magic[ 2], sdwb->bus.magic[ 3],
                  sdwb->bus.magic[ 4], sdwb->bus.magic[ 5],
                  sdwb->bus.magic[ 6], sdwb->bus.magic[ 7],
                  sdwb->bus.magic[ 8], sdwb->bus.magic[ 9],
                  sdwb->bus.magic[10], sdwb->bus.magic[11],
                  sdwb->bus.magic[12], sdwb->bus.magic[13],
                  sdwb->bus.magic[14], sdwb->bus.magic[15]);
  fprintf(stdout, "  bus_end:         %016"PRIx64"\n", sdwb->bus.bus_end);
  fprintf(stdout, "  sdwb_records:    %d\n",           sdwb->bus.sdwb_records);
  fprintf(stdout, "  sdwb_ver_major:  %d\n",           sdwb->bus.sdwb_ver_major);
  fprintf(stdout, "  sdwb_ver_minor:  %d\n",           sdwb->bus.sdwb_ver_minor);
  fprintf(stdout, "  bus_vendor:      %08"PRIx32"\n",  sdwb->bus.bus_vendor);
  fprintf(stdout, "  bus_device:      %08"PRIx32"\n",  sdwb->bus.bus_device);
  fprintf(stdout, "  bus_version:     %08"PRIx32"\n",  sdwb->bus.bus_version);
  fprintf(stdout, "  bus_date:        %08"PRIx32"\n",  sdwb->bus.bus_date);
  fprintf(stdout, "  bus_flags:       %08"PRIx32"\n",  sdwb->bus.bus_flags);
  fprintf(stdout, "  description:     "); fwrite(sdwb->bus.description, 1, 16, stdout); fprintf(stdout, "\n");
  fprintf(stdout, "\n");
  
  devices = sdwb->bus.sdwb_records - 1;
  for (i = 0; i < devices; ++i) {
    sdwb_device_t des = &sdwb->device[i];
    
/*
    if ((des->wbd_flags & WBD_FLAG_PRESENT) == 0) {
      fprintf(stdout, "Device %d: not present\n", i);
      continue;
    }
*/    
    fprintf(stdout, "Device %d\n", i);
    fprintf(stdout, "  wbd_begin:       %016"PRIx64"\n", des->wbd_begin);
    fprintf(stdout, "  wbd_end:         %016"PRIx64"\n", des->wbd_end);
    fprintf(stdout, "  sdwb_child:      %016"PRIx64"\n", des->sdwb_child);
    fprintf(stdout, "  wbd_flags:       %02"PRIx8"\n",   des->wbd_flags);
    fprintf(stdout, "  wbd_width:       %02"PRIx8"\n",   des->wbd_width);
    fprintf(stdout, "  abi_ver_major:   %d\n",           des->abi_ver_major);
    fprintf(stdout, "  abi_ver_minor:   %d\n",           des->abi_ver_minor);
    fprintf(stdout, "  abi_class:       %08"PRIx32"\n",  des->abi_class);
    fprintf(stdout, "  dev_vendor:      %08"PRIx32"\n",  des->dev_vendor);
    fprintf(stdout, "  dev_device:      %08"PRIx32"\n",  des->dev_device);
    fprintf(stdout, "  dev_version:     %08"PRIx32"\n",  des->dev_version);
    fprintf(stdout, "  dev_date:        %08"PRIx32"\n",  des->dev_date);
    fprintf(stdout, "  description:     "); fwrite(des->description, 1, 16, stdout); fprintf(stdout, "\n");
  }
}

int main(int argc, const char** argv) {
  eb_socket_t socket;
  eb_status_t status;
  eb_device_t device;
  int stop;
  
  if (argc != 2) {
    fprintf(stderr, "Syntax: %s <protocol/host/port>\n", argv[0]);
    return 1;
  }
  
  if ((status = eb_socket_open(EB_ABI_CODE, 0, EB_DATAX|EB_ADDRX, &socket)) != EB_OK) {
    fprintf(stderr, "Failed to open Etherbone socket: %s\n", eb_status(status));
    return 1;
  }
  
  if ((status = eb_device_open(socket, argv[1], EB_ADDRX|EB_DATAX, 3, &device)) != EB_OK) {
    fprintf(stderr, "Failed to open Etherbone device: %s\n", eb_status(status));
    return 1;
  }
  
  if ((status = eb_sdwb_scan_root(device, &stop, &list_devices)) != EB_OK) {
    fprintf(stderr, "Failed to scan remote device: %s\n", eb_status(status));
    return 1;
  }
  
  stop = 0;
  while (!stop) {
    eb_socket_block(socket, -1);
    eb_socket_poll(socket);
  }
  
  if ((status = eb_device_close(device)) != EB_OK) {
    fprintf(stderr, "Failed to close Etherbone device: %s\n", eb_status(status));
    return 1;
  }
  
  if ((status = eb_socket_close(socket)) != EB_OK) {
    fprintf(stderr, "Failed to close Etherbone socket: %s\n", eb_status(status));
    return 1;
  }
  
  return 0;
}
