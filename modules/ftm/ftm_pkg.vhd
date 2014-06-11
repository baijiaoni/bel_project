library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.wishbone_pkg.all;
use work.wb_irq_pkg.all;

package ftm_pkg is

------------------------------------------------------------------------------
-- Components declaration
-------------------------------------------------------------------------------
  
   constant c_clu_slaves   : natural := 7; 
   
   constant c_clu_cluster_info  : natural := 0;
   constant c_clu_shared_mem    : natural := 1;
   constant c_clu_load_mgr      : natural := 2;
   constant c_clu_ebm_queue_c   : natural := 3;
   constant c_clu_ebm_queue_d   : natural := 4;
   constant c_clu_irq_bridge    : natural := 5;
   constant c_clu_ram_bridge    : natural := 6;

   -- generator functions for ftm crossbars. workaround for no-reverse-generic in VHDL,
   -- use this when placing the ftm bridges outside
   function f_multi_inst_sdb(times : natural; device : t_sdb_device)         return t_sdb_record_array;
   function f_cluster_main_sdb(irq_layout : t_sdb_record_array; ram_layout 
   : t_sdb_record_array; shared_ramsize : natural; is_ftm : boolean )   return t_sdb_record_array;
   function f_cluster_ram_sdb(cores : natural; ramsize : natural)       return t_sdb_record_array;
   function f_cluster_irq_sdb(cores : natural; msiPerCcore : natural)   return t_sdb_record_array;
   function f_lm32_irq_bridge_sdb( cores        : natural; 
                                   msiPerCore   : natural) return t_sdb_bridge;
   function f_lm32_main_bridge_sdb(cores        : natural; 
                                   msiPerCore   : natural;
                                   ramPerCore   : natural;
                                   shared_ram   : natural;
                                   is_ftm       : boolean) return t_sdb_bridge;
                                   
                                   
   constant c_dummy_bridge : t_sdb_bridge := (
   sdb_child     => (others => '0'),
   sdb_component => (
   addr_first    => (others => '0'),
   addr_last     => (others => '0'),
   product => (
   vendor_id     => (others => '0'), 
   device_id     => (others => '0'),
   version       => (others => '0'),
   date          => (others => '0'),
   name          => "DUMMYDUMMYDUMMYDUMM")));
   
   constant c_dummy_slave_in : t_wishbone_slave_in := ('0', '0', x"00000000", x"F", '0', x"00000000"); 
   constant c_dummy_slave_out : t_wishbone_slave_out := ('0', '0', '0', '0', '0', x"00000000");
   

   component ftm_lm32 is
   generic(g_cpu_id              : t_wishbone_data := x"CAFEBABE";
        g_size                : natural := 16384;                 -- size of the dpram
        g_is_in_cluster       : boolean := false; 
        g_cluster_bridge_sdb  : t_sdb_bridge := c_dummy_bridge;   --
        g_world_bridge_sdb    : t_sdb_bridge;                     -- record for the superior bridge
        g_profile             : string  := "medium_icache_debug"; -- lm32 profile
        g_init_file           : string  := "";                    -- memory init file - binary for lm32
        g_addr_ext_bits       : natural := 1;                     -- address extension bits (starting from MSB)
        g_msi_queues          : natural := 3);                    -- number of msi queues connected to the lm32 (added at prio 1 !!! 0 is always timer
   port(
   clk_sys_i      : in  std_logic;  -- system clock 
   rst_n_i        : in  std_logic;  -- reset, active low 
   rst_lm32_n_i   : in  std_logic;  -- reset, active low
   tm_tai8ns_i    : in std_logic_vector(63 downto 0);
   -- optional cluster periphery interface of the lm32
   clu_master_o  : out t_wishbone_master_out; 
   clu_master_i  : in  t_wishbone_master_in := ('0', '0', '0', '0', '0', x"00000000");
     
   -- wb world interface of the lm32
   world_master_o  : out t_wishbone_master_out; 
   world_master_i  : in  t_wishbone_master_in;  
   -- wb msi interfaces
   irq_slaves_o   : out t_wishbone_slave_out_array(g_msi_queues-1 downto 0);  
   irq_slaves_i   : in  t_wishbone_slave_in_array(g_msi_queues-1 downto 0);
   -- port B of the LM32s DPRAM 
   ram_slave_o    : out t_wishbone_slave_out;                           
   ram_slave_i    : in  t_wishbone_slave_in

   );
   end component;
   
   component ftm_lm32_cluster is
   generic(g_is_ftm        : boolean := false;
           g_cores         : natural := 1;
           g_ram_per_core  : natural := 32768/4;
           g_shared_mem    : natural := 0;
           g_msi_per_core  : natural := 2;
           g_profile       : string  := "medium_icache_debug";
           g_init_file     : string  := "msidemo.mif";   
           g_world_bridge_sdb    : t_sdb_bridge                      -- superior crossbar         
      );
   port(
   clk_sys_i      : in  std_logic;
   rst_n_i        : in  std_logic;
   rst_lm32_n_i   : in  std_logic;

   tm_tai8ns_i    : in std_logic_vector(63 downto 0);

   irq_slave_o    : out t_wishbone_slave_out; 
   irq_slave_i    : in  t_wishbone_slave_in;

   -- optional cluster ctrl slave interface
   cluster_slave_o  : out t_wishbone_slave_out; 
   cluster_slave_i  : in  t_wishbone_slave_in := ('0', '0', x"00000000", x"F", '0', x"00000000");

   -- optional FTM ebm queue master interface
   ftm_queue_master_o : out t_wishbone_master_out; 
   ftm_queue_master_i : in  t_wishbone_master_in := ('0', '0', '0', '0', '0', x"00000000"); 
            
   master_o   : out t_wishbone_master_out; 
   master_i   : in  t_wishbone_master_in  
   );
   end component;
   
   component time_clk_cross is
   generic (g_delay_comp      : natural := 16);
   port    (clk_ref_i            : in std_logic;
            rst_ref_n_i          : in std_logic;
            clk_sys_i            : in std_logic;           
            rst_sys_n_i          : in std_logic;             
              
            tm_time_valid_i      : in  std_logic;                       -- timestamp valid flag
            tm_tai_i             : in  std_logic_vector(39 downto 0);   -- TAI Timestamp
            tm_cycles_i          : in  std_logic_vector(27 downto 0);   -- refclock cycle count
         
            tm_ref_tai_cycles_o  : out std_logic_vector(63 downto 0);
            tm_sys_tai_cycles_o  : out std_logic_vector(63 downto 0)        
   );
   end component;
   
   component ftm_priority_queue is
   generic(
      g_is_ftm       : boolean := false;  
      g_idx_width    : natural := 8;
      g_key_width    : natural := 64;
      g_val_width    : natural := 192  
   );            
   port(
      clk_sys_i   : in  std_logic;
      rst_n_i     : in  std_logic;

      time_sys_i  : in  std_logic_vector(63 downto 0) := (others => '1');

      ctrl_i      : in  t_wishbone_slave_in;
      ctrl_o      : out t_wishbone_slave_out;
      
      snk_i       : in  t_wishbone_slave_in;
      snk_o       : out t_wishbone_slave_out;
      
      src_o       : out t_wishbone_master_out;
      src_i       : in  t_wishbone_master_in
     
   );
   end component;
   
   
   constant c_atomic_sdb : t_sdb_device := (
    abi_class     => x"0000", -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"7", -- 8/16/32-bit port granularity
    sdb_component => (
    addr_first    => x"0000000000000000",
    addr_last     => x"0000000000000003",
    product => (
    vendor_id     => x"0000000000000651", -- GSI
    device_id     => x"10040100",
    version       => x"00000001",
    date          => x"20131119",
    name          => "ATOMIC CYCLINE CTRL")));
  
   constant c_sys_time_sdb : t_sdb_device := (
    abi_class     => x"0000", -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"7", -- 8/16/32-bit port granularity
    sdb_component => (
    addr_first    => x"0000000000000000",
    addr_last     => x"0000000000000007",
    product => (
    vendor_id     => x"0000000000000651", -- GSI
    device_id     => x"10040084",
    version       => x"00000001",
    date          => x"20131009",
    name          => "TAI_TIME_8NS       ")));
  
   constant c_cpu_info_sdb : t_sdb_device := (
    abi_class     => x"0000", -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"7", -- 8/16/32-bit port granularity
    sdb_component => (
    addr_first    => x"0000000000000000",
    addr_last     => x"0000000000000007",
    product => (
    vendor_id     => x"0000000000000651", -- GSI
    device_id     => x"10040085",
    version       => x"00000001",
    date          => x"20131009",
    name          => "CPU_INFO_ROM       ")));

   constant c_ebm_queue_data_sdb : t_sdb_device := (
   abi_class     => x"0000", -- undocumented device
   abi_ver_major => x"01",
   abi_ver_minor => x"01",
   wbd_endian    => c_sdb_endian_big,
   wbd_width     => x"7", -- 8/16/32-bit port granularity
   sdb_component => (
   addr_first    => x"0000000000000000",
   addr_last     => x"0000000000000003",
   product => (
   vendor_id     => x"0000000000000651", -- GSI
   device_id     => x"10040201",
   version       => x"00000001",
   date          => x"20131009",
   name          => "EBM_MSG_QUEUE_DATA ")));
   
   constant c_ebm_queue_ctrl_sdb : t_sdb_device := (
   abi_class     => x"0000", -- undocumented device
   abi_ver_major => x"01",
   abi_ver_minor => x"01",
   wbd_endian    => c_sdb_endian_big,
   wbd_width     => x"7", -- 8/16/32-bit port granularity
   sdb_component => (
   addr_first    => x"0000000000000000",
   addr_last     => x"000000000000007f",
   product => (
   vendor_id     => x"0000000000000651", -- GSI
   device_id     => x"10040200",
   version       => x"00000001",
   date          => x"20131009",
   name          => "EBM_MSG_QUEUE_CTRL "))); 

   constant c_load_mgr_sdb : t_sdb_device := (
   abi_class     => x"0000", -- undocumented device
   abi_ver_major => x"01",
   abi_ver_minor => x"01",
   wbd_endian    => c_sdb_endian_big,
   wbd_width     => x"7", -- 8/16/32-bit port granularity
   sdb_component => (
   addr_first    => x"0000000000000000",
   addr_last     => x"00000000000000ff",
   product => (
   vendor_id     => x"0000000000000651", -- GSI
   device_id     => x"10040202",
   version       => x"00000001",
   date          => x"20131009",
   name          => "LOAD_MANAGER       ")));
                    

   constant c_cluster_info_sdb : t_sdb_device := (
   abi_class     => x"0000", -- undocumented device
   abi_ver_major => x"01",
   abi_ver_minor => x"01",
   wbd_endian    => c_sdb_endian_big,
   wbd_width     => x"7", -- 8/16/32-bit port granularity
   sdb_component => (
   addr_first    => x"0000000000000000",
   addr_last     => x"00000000000000FF",
   product => (
   vendor_id     => x"0000000000000651", -- GSI
   device_id     => x"10040086",
   version       => x"00000001",
   date          => x"20131009",
   name          => "CLUSTER_INFO_ROM   ")));
   
   constant c_cluster_cb_product : t_sdb_product := (
   vendor_id     => x"0000000000000651", -- GSI
   device_id     => x"10041000",
   version       => x"00000001",
   date          => x"20140515",
   name          => "CB_LM32_CLUSTER    ");  

end ftm_pkg;

   package body ftm_pkg is

   -- generator functions for ftm crossbars. workaround for no-reverse-generic in VHDL,
   -- use this when placing the ftm bridges outside
   function f_multi_inst_sdb(times : natural; device : t_sdb_device)
   return t_sdb_record_array is
   variable result :  t_sdb_record_array(times-1 downto 0);   
   begin
      result := f_sdb_create_array(device             => device,  
                                   instances          => times,
                                   g_enum_dev_name    => true,
                                   g_dev_name_offs    => times*10);
      return result;
   end f_multi_inst_sdb;
   
   function f_cluster_main_sdb(irq_layout : t_sdb_record_array; ram_layout : t_sdb_record_array; shared_ramsize : natural; is_ftm : boolean )
   return t_sdb_record_array is
      variable v_clu_layout :  t_sdb_record_array(c_clu_slaves-1 downto 0); 
   begin
      v_clu_layout :=   (  c_clu_cluster_info => f_sdb_auto_device(c_cluster_info_sdb,            true),
                           c_clu_load_mgr     => f_sdb_auto_device(c_load_mgr_sdb,                true), 
                           c_clu_ebm_queue_c  => f_sdb_auto_device(c_ebm_queue_ctrl_sdb,          is_ftm),
                           c_clu_ebm_queue_d  => f_sdb_auto_device(c_ebm_queue_data_sdb,          is_ftm),
                           c_clu_shared_mem   => f_sdb_auto_device(f_xwb_dpram(shared_ramsize),  (shared_ramsize > 0)),
                           c_clu_irq_bridge   => f_sdb_auto_bridge(f_xwb_bridge_layout_sdb(true, f_sdb_auto_layout(irq_layout), f_sdb_auto_sdb(irq_layout)), true), 
                           c_clu_ram_bridge   => f_sdb_auto_bridge(f_xwb_bridge_layout_sdb(true, f_sdb_auto_layout(ram_layout), f_sdb_auto_sdb(ram_layout)), true) 
                        );
      return v_clu_layout;
   end f_cluster_main_sdb;
   
   function f_cluster_irq_sdb(cores : natural; msiPerCcore : natural)
   return t_sdb_record_array is
      variable v_irq_layout : t_sdb_record_array(cores * msiPerCcore-1 downto 0);
   begin
      v_irq_layout := f_multi_inst_sdb(cores * msiPerCcore, c_irq_ep_sdb);
      return v_irq_layout;
   end f_cluster_irq_sdb;
   
   function f_cluster_ram_sdb(cores : natural; ramsize : natural)
   return t_sdb_record_array is
         variable v_ram_layout : t_sdb_record_array(cores-1 downto 0);
   begin
      v_ram_layout := f_multi_inst_sdb(cores, f_xwb_dpram(ramsize));
      return v_ram_layout;
   end f_cluster_ram_sdb;
   
   function f_lm32_irq_bridge_sdb(cores        : natural; 
                                  msiPerCore   : natural)
   return t_sdb_bridge is
   begin
      return f_xwb_bridge_layout_sdb(
               true,
	            f_sdb_auto_layout(f_cluster_irq_sdb(cores, msiPerCore)),
	            f_sdb_auto_sdb(f_cluster_irq_sdb(cores, msiPerCore)));
   end f_lm32_irq_bridge_sdb;
   
   function f_lm32_main_bridge_sdb(cores        : natural; 
                                   msiPerCore   : natural;
                                   ramPerCore   : natural;
                                   shared_ram   : natural;
                                   is_ftm       : boolean)
   return t_sdb_bridge is
      variable v_main : t_sdb_record_array(c_clu_slaves-1 downto 0);      
      variable v_ret :  t_sdb_bridge;
   begin
     
      
      v_main := f_cluster_main_sdb(f_cluster_irq_sdb(cores, msiPerCore), f_cluster_ram_sdb(cores, ramPerCore), shared_ram, is_ftm);
      v_ret  := f_xwb_bridge_layout_sdb(
                  true, 
                  f_sdb_auto_layout(v_main),  
                  f_sdb_auto_sdb(v_main)
               );
      v_ret.sdb_component.product := c_cluster_cb_product;
      return v_ret;         
   end f_lm32_main_bridge_sdb;
   
  
end ftm_pkg;
