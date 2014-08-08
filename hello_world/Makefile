CC      := ~/project/bel_project/toolchain/bin/lm32-elf-gcc

PREFIX    =/usr/local
LM32INC   = /home/jbai/project/bel_project/modules/lm32-include/
EB       ?= ../ip_cores/etherbone-core/api
W1        = /home/jbai/project/bel_project/ip_cores/wrpc-sw/include
W2        = /home/jbai/project/bel_project/top/gsi_scu/
TLU      = /home/jbai/project/bel_project/ip_cores/wr-cores/modules/wr_tlu/lib
CFLAGS    = -I$(W1) -I$(W2) -I$(EB)-I$(PREFIX)/include
LIBS     ?= -L $(EB) -Wl,-rpath,$(PREFIX)/lib -letherbone


blink.elf:  
	$(CC) $(CFLAGS) -I$(LM32INC) main.c $(LM32INC)/mprintf.c $(W1)/../dev/uart.c $(LM32INC)/mini_sdb.c -o $@ -T ram.ld -Wl,--defsym,_fstack=131072-4 $^ -lgcc -lc
#these Wl parameters are belong to lm32-elf-gcc

timestamp.elf:
	$(CC) $(CFLAGS) -I$(LM32INC) -I$(TLU) lm32_timestamp_package.c $(LM32INC)/mprintf.c $(W1)/../dev/uart.c \
        $(LM32INC)/mini_sdb.c -lm -o $@ -T ram.ld -Wl,--defsym,_fstack=131072-4 $^ -lgcc -lc
clean:
	@echo "clean project"
	rm -rf *.o *.elf *.bin
	@echo "clean complete"
