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

#define _POSIX_C_SOURCE 200112L /* strtoull + getopt */

#include <unistd.h> /* getopt */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../etherbone.h"
#include "../glue/version.h"
#include "common.h"

static void help(void) {
  fprintf(stderr, "Usage: %s [OPTION] <proto/host/port> <address/size> <value>\n", program);
  fprintf(stderr, "\n");
  fprintf(stderr, "  -a <width>     acceptable address bus widths     (8/16/32/64)\n");
  fprintf(stderr, "  -d <width>     acceptable data bus widths        (8/16/32/64)\n");
  fprintf(stderr, "  -r <retries>   number of times to attempt autonegotiation (3)\n");
  fprintf(stderr, "  -n             do not recursively explore nested buses\n");
  fprintf(stderr, "  -v             verbose operation\n");
  fprintf(stderr, "  -q             quiet: do not display warnings\n");
  fprintf(stderr, "  -h             display this help and exit\n");
  fprintf(stderr, "\n");
  fprintf(stderr, "Report Etherbone bugs to <etherbone-core@ohwr.org>\n");
  fprintf(stderr, "Version %"PRIx32" (%s). Licensed under the LGPL v3.\n", EB_VERSION_SHORT, EB_DATE_FULL);
}

struct bus_record {
  int i;
  int stop;
  eb_address_t begin, end;
  struct bus_record* parent;
};

static int print_id(struct bus_record* br) {
  if (br->i == -1) {
    return fprintf(stdout, "root");
  } else if (br->parent->i == -1) {
    return fprintf(stdout, "%d", br->i + 1);
  } else {
    int more = print_id(br->parent);
    return more + fprintf(stdout, ".%d", br->i + 1);
  }
}

static void verbose_product(struct sdb_product* product) {
  fprintf(stdout, "  product.vendor_id: %016"PRIx64"\n", product->vendor_id);
  fprintf(stdout, "  product.device_id: %08"PRIx32"\n",  product->device_id);
  fprintf(stdout, "  product.version:   %08"PRIx32"\n",  product->version);
  fprintf(stdout, "  product.date:      %08"PRIx32"\n",  product->date);
  fprintf(stdout, "  product.name:      "); fwrite(&product->name[0], 1, sizeof(product->name), stdout); fprintf(stdout, "\n");
  fprintf(stdout, "\n");
}

static void verbose_component(struct sdb_component* component, struct bus_record* br) {
  fprintf(stdout, "  component.begin:   %016"PRIx64, component->begin);
  if (component->begin < br->parent->begin || component->begin > br->parent->end) {
    fprintf(stdout, " !!! out of range\n");
  } else {
    fprintf(stdout, "\n");
  }
  
  fprintf(stdout, "  component.end:     %016"PRIx64, component->end);
  if (component->end < br->parent->begin || component->end > br->parent->end) {
    fprintf(stdout, " !!! out of range\n");
  } else if (component->end < component->begin) {
    fprintf(stdout, " !!! precedes begin\n");
  } else {
    fprintf(stdout, "\n");
  }
  
  verbose_product(&component->product);
}

static int norecurse;
static void list_devices(eb_user_data_t user, eb_device_t dev, sdb_t sdb, eb_status_t status) {
  struct bus_record br;
  int devices;
  
  br.parent = (struct bus_record*)user;
  br.parent->stop = 1;
  
  if (status != EB_OK) {
    fprintf(stderr, "%s: failed to retrieve SDB: %s\n", program, eb_status(status));
    exit(1);
  } 
  
  if (verbose) {
    fprintf(stdout, "SDB Bus "); print_id(br.parent); fprintf(stdout, "\n");
    fprintf(stdout, "  sdb_magic:         %08"PRIx32"\n", sdb->interconnect.sdb_magic);
    fprintf(stdout, "  sdb_records:       %d\n",   sdb->interconnect.sdb_records);
    fprintf(stdout, "  sdb_version:       %d\n",   sdb->interconnect.sdb_version);
    verbose_component(&sdb->interconnect.component, &br);
    
    if (sdb->interconnect.component.begin > br.parent->begin)
      br.parent->begin = sdb->interconnect.component.begin;
    if (sdb->interconnect.component.end < br.parent->end)
      br.parent->end   = sdb->interconnect.component.end;
  }
  
  devices = sdb->interconnect.sdb_records - 1;
  for (br.i = 0; br.i < devices; ++br.i) {
    int bad, wide;
    sdb_record_t des;
    
    des = &sdb->record[br.i];
    bad = 0;
    
    if (verbose) {
      fprintf(stdout, "Device ");
      print_id(&br);
      
      switch (des->empty.record_type) {
      case sdb_device:
        fprintf(stdout, "\n");
        
        fprintf(stdout, "  abi_class:         %04"PRIx16"\n",  des->device.abi_class);
        fprintf(stdout, "  abi_ver_major:     %d\n",           des->device.abi_ver_major);
        fprintf(stdout, "  abi_ver_minor:     %d\n",           des->device.abi_ver_minor);
        fprintf(stdout, "  wbd_endian:        %s\n",           (des->device.bus_specific & SDB_WISHBONE_LITTLE_ENDIAN) ? "little" : "big");
        fprintf(stdout, "  wbd_width:         %"PRIx8"\n",   des->device.bus_specific & SDB_WISHBONE_WIDTH);
        
        verbose_component(&des->device.component, &br);
        bad = 0;
        break;
      
      case sdb_bridge:
        fprintf(stdout, "\n");
        
        fprintf(stdout, "  sdb_child:       %016"PRIx64, des->bridge.sdb_child);
        if (des->bridge.sdb_child < des->bridge.component.begin || des->bridge.sdb_child > des->bridge.component.end-64) {
          fprintf(stdout, " !!! not contained in wbd_{begin,end}\n");
        } else {
          fprintf(stdout, "\n");
        }
        
        verbose_component(&des->bridge.component, &br);
        bad = des->bridge.component.begin < br.parent->begin ||
              des->bridge.component.end   > br.parent->end   ||
              des->bridge.component.begin > des->bridge.component.end ||
              des->bridge.sdb_child       < des->bridge.component.begin ||
              des->bridge.sdb_child       > des->bridge.component.end-64;
        
        break;
        
      case sdb_integration: /* !!! fixme */
      case sdb_empty:
      default:
        fprintf(stdout, " not present (%x)\n", des->empty.record_type);
        break;
      }
      
    } else {
      wide = print_id(&br);
      if (wide < 15)
        fwrite("                     ", 1, 15-wide, stdout); /* align the text */
      
      switch (des->empty.record_type) {
      case sdb_bridge:
        fprintf(stdout, "%016"PRIx64":%08"PRIx32"  %16"EB_ADDR_FMT"  ",
                des->device.component.product.vendor_id, 
                des->device.component.product.device_id, 
                (eb_address_t)des->device.component.begin);
        fwrite(des->device.component.product.name, 1, sizeof(des->device.component.product.name), stdout);
        fprintf(stdout, "\n");
        break;
      
      case sdb_device:
        fprintf(stdout, "%016"PRIx64":%08"PRIx32"  %16"EB_ADDR_FMT"  ",
                des->device.component.product.vendor_id, 
                des->device.component.product.device_id, 
                (eb_address_t)des->device.component.begin);
        fwrite(des->device.component.product.name, 1, sizeof(des->device.component.product.name), stdout);
        fprintf(stdout, "\n");
        break;
        
      case sdb_integration: /* !!! fixme */
      case sdb_empty:
      default:
        fprintf(stdout, "---\n");
        break;
      }
    }
    
    if (!norecurse && !bad && des->empty.record_type == sdb_bridge) {
      br.stop = 0;
      br.begin = des->bridge.component.begin;
      br.end = des->bridge.component.end;
      
      eb_sdb_scan_bus(dev, &des->bridge, &br, &list_devices);
      while (!br.stop) eb_socket_run(eb_device_socket(dev), -1);
    }
  }
}

int main(int argc, char** argv) {
  long value;
  char* value_end;
  int opt, error;
  
  struct bus_record br;
  eb_socket_t socket;
  eb_status_t status;
  eb_device_t device;
  
  /* Specific command-line options */
  const char* netaddress;
  int attempts;
  
  br.parent = 0;
  br.i = -1;
  br.stop = 0;
  br.begin = 0;
  br.end = ~(eb_address_t)0;
  
  /* Default command-line arguments */
  program = argv[0];
  address_width = EB_ADDRX;
  data_width = EB_DATAX;
  attempts = 3;
  quiet = 0;
  verbose = 0;
  norecurse = 0;
  error = 0;
  
  /* Process the command-line arguments */
  while ((opt = getopt(argc, argv, "a:d:r:nvqh")) != -1) {
    switch (opt) {
    case 'a':
      value = parse_width(optarg);
      if (value < 0) {
        fprintf(stderr, "%s: invalid address width -- '%s'\n", program, optarg);
        return 1;
      }
      address_width = value << 4;
      break;
    case 'd':
      value = parse_width(optarg);
      if (value < 0) {
        fprintf(stderr, "%s: invalid data width -- '%s'\n", program, optarg);
        return 1;
      }
      data_width = value;
      break;
    case 'r':
      value = strtol(optarg, &value_end, 0);
      if (*value_end || value < 0 || value > 100) {
        fprintf(stderr, "%s: invalid number of retries -- '%s'\n", program, optarg);
        return 1;
      }
      attempts = value;
      break;
    case 'n':
      norecurse = 1;
      break;
    case 'v':
      verbose = 1;
      break;
    case 'q':
      quiet = 1;
      break;
    case 'h':
      help();
      return 1;
    case ':':
    case '?':
      error = 1;
      break;
    default:
      fprintf(stderr, "%s: bad getopt result\n", program);
      return 1;
    }
  }
  
  if (error) return 1;
  
  if (optind + 1 != argc) {
    fprintf(stderr, "%s: expecting non-optional argument: <protocol/host/port>\n", program);
    return 1;
  }
  
  netaddress = argv[optind];
  
  if ((status = eb_socket_open(EB_ABI_CODE, 0, address_width|data_width, &socket)) != EB_OK) {
    fprintf(stderr, "%s: failed to open Etherbone socket: %s\n", program, eb_status(status));
    return 1;
  }
  
  if ((status = eb_device_open(socket, netaddress, EB_ADDRX|EB_DATAX, attempts, &device)) != EB_OK) {
    fprintf(stderr, "%s: failed to open Etherbone device: %s\n", program, eb_status(status));
    return 1;
  }
  
  /* Find the limit of the bus space based on the address width */
  br.end >>= (sizeof(eb_address_t) - (eb_device_width(device) >> 4))*8;
  
  if ((status = eb_sdb_scan_root(device, &br, &list_devices)) != EB_OK) {
    fprintf(stderr, "%s: failed to scan remote device: %s\n", program, eb_status(status));
    return 1;
  }
  
  if (!verbose)
    fprintf(stdout, "BusPath        VendorID         Product   BaseAddress(Hex)  Description\n");
  
  while (!br.stop) 
    eb_socket_run(socket, -1);
  
  if ((status = eb_device_close(device)) != EB_OK) {
    fprintf(stderr, "%s: failed to close Etherbone device: %s\n", program, eb_status(status));
    return 1;
  }
  
  if ((status = eb_socket_close(socket)) != EB_OK) {
    fprintf(stderr, "%s: failed to close Etherbone socket: %s\n", program, eb_status(status));
    return 1;
  }
  
  return 0;
}
