PREFIX  ?= /usr/local
STAGING ?= 
EB      ?= ../ip_cores/etherbone-core/api/gl
#WB      ?= ../ip_cores/wr-cores/modules/wr_eca/lib/
TARGETS := pkg_gen_conf eb-flash eb-info eb-console eb-config-nv timestamp_latch_Butis ECA_to_TLU eca-snoop test
TLU      = /home/jbai/project/bel_project/ip_cores/wr-cores/modules/wr_tlu/lib

EXTRA_FLAGS ?=
CFLAGS      ?= $(EXTRA_FLAGS) -Wall -O2 -I $(EB)
LIBS        ?= -L $(EB)  -Wl,-rpath,$(PREFIX)/lib -letherbone -lpthread

all:	$(TARGETS)
clean:
	rm -f $(TARGETS) 
install:
	mkdir -p $(STAGING)$(PREFIX)/bin
	cp $(TARGETS) $(STAGING)$(PREFIX)/bin
%:	%.c
	gcc $(CFLAGS) -o $@ $< $(LIBS)

%:	%.cpp
	g++ $(CFLAGS) -I$(TLU) -o $@ $< $(LIBS) -leca -ltlu
