--*************************************----
LIBRARY ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wr_altera_pkg.all;
use work.ez_usb_pkg.all;
use work.wishbone_pkg.all;
use work.pexaria_pkg.all;
use work.build_id_pkg.all;

ENTITY pexaria IS 
	PORT (
	-----------------------------------------------------------------------
    -- my count error
	-----------------------------------------------------------------------
			 clk      : IN STD_LOGIC; -- BuTis 200MHz input through extension port 9 pin
--	       osc      : IN  STD_LOGIC; -- local 125MHz quartz
			 io1      : OUT STD_LOGIC; --output 10MHz
			 io2      : IN  STD_LOGIC; --input 100KHz
			 io3      : OUT STD_LOGIC; --output 100KHz
			 TTLEN1   : OUT STD_LOGIC;                                                   
			 TTLEN2   : OUT STD_LOGIC;
			 TTLEN3   : OUT STD_LOGIC;
			 TTLTERM1 : OUT STD_LOGIC;
			 TTLTERM2 : OUT STD_LOGIC;
			 TTLTERM3 : OUT STD_LOGIC;
			 LED1     : OUT STD_LOGIC; --conrol LED1
			 LED2     : OUT STD_LOGIC; --conrol LED2
			 LED3     : OUT STD_LOGIC; --conrol LED3
			 LED4     : OUT STD_LOGIC; --conrol LED4
			 LED5     : OUT STD_LOGIC; --conrol LED4
			 LED6     : OUT STD_LOGIC; --conrol LED4
			 LED7     : OUT STD_LOGIC; --conrol LED4
			 
			 button   : IN STD_LOGIC; --reset the count1 to zero and turn off the LED1\

	 -----------------------------------------------------------------------
    -- usb
    -----------------------------------------------------------------------
    usb_rstn_o             : out   std_logic := 'Z';
    usb_ebcyc_i            : in    std_logic;
    usb_speed_i            : in    std_logic;
    usb_shift_i            : in    std_logic;
    usb_readyn_io          : inout std_logic;
    usb_fifoadr_o          : out   std_logic_vector(1 downto 0) := (others => 'Z');
    usb_sloen_o            : out   std_logic := 'Z';
    usb_fulln_i            : in    std_logic;
    usb_emptyn_i           : in    std_logic;
    usb_slrdn_o            : out   std_logic := 'Z';
    usb_slwrn_o            : out   std_logic := 'Z';
    usb_pktendn_o          : out   std_logic := 'Z';
    usb_fd_io              : inout std_logic_vector(7 downto 0);
	 
	 -----------------------------------------------------------------------
    -- clock
    -----------------------------------------------------------------------
	 core_clk_125m_local_i  : in    std_logic);
 
			 		 
END pexaria ; 

ARCHITECTURE LogicFunction OF pexaria IS

   signal clk_200_local : std_logic;
	signal countpps :unsigned (32 DOWNTO 0);
	signal pps : std_logic;

	
	signal uart_usb : std_logic; -- from usb
   signal uart_wrc : std_logic; -- from wrc
	
   signal s_usb_fd_o   : std_logic_vector(7 downto 0);
   signal s_usb_fd_oen : std_logic;
	
	signal sys_locked       : std_logic;
	signal clk_sys0         : std_logic;
	signal clk_sys1         : std_logic;
	signal clk_sys2         : std_logic;
	signal clk_sys3         : std_logic;
	signal pll_rst          : std_logic;
  
	signal clk_sys          : std_logic;
	signal rstn_sys         : std_logic;
	
	signal s_io1_n 			: std_logic;
	signal s_io2_n				: std_logic;
	signal s_io3_n				: std_logic;
	
	constant c_top_masters    : natural := 1;
	constant c_top_slaves     : natural := 2; --required slave
	signal top_cbar_slave_i  : t_wishbone_slave_in_array (c_top_masters-1 downto 0);
	signal top_cbar_slave_o  : t_wishbone_slave_out_array(c_top_masters-1 downto 0);
	signal top_cbar_master_i : t_wishbone_master_in_array(c_top_slaves-1 downto 0);
   signal top_cbar_master_o : t_wishbone_master_out_array(c_top_slaves-1 downto 0);  
	----------------------------------------------------------------------------------
   -- GSI Top Crossbar --------------------------------------------------------------
   ----------------------------------------------------------------------------------
	constant c_topm_usb       : natural := 0;
	constant c_tops_build_id  : natural := 0;
	constant c_tops_butis_conv: natural := 1;
	
	constant c_top_layout_req : t_sdb_record_array(c_top_slaves-1 downto 0) :=
   (c_tops_build_id  => f_sdb_auto_device(c_build_id_sdb, true),
	c_tops_butis_conv  => f_sdb_auto_device(c_butis_conv_sdb, true));
	constant c_top_layout     : t_sdb_record_array(c_top_slaves-1 downto 0) 
                                                  := f_sdb_auto_layout(c_top_layout_req);
	constant c_top_sdb_address: t_wishbone_address := f_sdb_auto_sdb(c_top_layout_req);
	
BEGIN

	TTLEN1 <= '0'; -- enable output
	TTLEN2 <= '1'; -- disable output (input)
	TTLEN3 <= '0'; -- enable output
	
	TTLTERM1 <= '0'; -- disconnect 50hm termination
	TTLTERM2 <= '1'; -- terminate input with 50hm
	TTLTERM3 <= '0'; -- disconnect 50hm termination
	---------------------------------------------------
	--my program component
	---------------------------------------------------
	
	pexaria1 : pexaria_e 
		port map(
			clk_200m_i => clk,
			clk_sys_i  => clk_sys,
			rstn_sys_i => rstn_sys,
			clk_100k_i => s_io2_n,
			clk_10m_o  => s_io1_n,
			fake_pps_o => s_io3_n,
			button_i   => button,
			aligned_o  => LED2,
			-- Wishbone interface
			slave_o    => top_cbar_master_i(c_tops_butis_conv),
			slave_i    => top_cbar_master_o(c_tops_butis_conv));		
	
	-- 
	io1 <= not s_io1_n; --io as output don't need change
	io3 <= not s_io3_n;
	s_io2_n <= not io2; --io as input need change
	
	---------------------------------------------------
	--USB component
	---------------------------------------------------
	
	usb_readyn_io <= 'Z';
	usb_fd_io <= s_usb_fd_o when s_usb_fd_oen='1' else (others => 'Z');
	usb : ez_usb
		generic map(
		  g_sdb_address => c_top_sdb_address)
		port map(
		  clk_sys_i => clk_sys,
		  rstn_i    => rstn_sys,
		  master_i  => top_cbar_slave_o(c_topm_usb),
		  master_o  => top_cbar_slave_i(c_topm_usb),
		  uart_o    => uart_usb,
		  uart_i    => uart_wrc,
		  rstn_o    => usb_rstn_o,
		  ebcyc_i   => usb_ebcyc_i,
		  speed_i   => usb_speed_i,
		  shift_i   => usb_shift_i,
		  readyn_i  => usb_readyn_io,
		  fifoadr_o => usb_fifoadr_o,
		  fulln_i   => usb_fulln_i,
		  sloen_o   => usb_sloen_o,
		  emptyn_i  => usb_emptyn_i,
		  slrdn_o   => usb_slrdn_o,
		  slwrn_o   => usb_slwrn_o,
		  pktendn_o => usb_pktendn_o,
		  fd_i      => usb_fd_io,
		  fd_o      => s_usb_fd_o,
		  fd_oen_o  => s_usb_fd_oen);
		  
	sys_inst : sys_pll5 
		port map(
			rst      => pll_rst,
			refclk   => core_clk_125m_local_i, -- 125  Mhz 
			outclk_0 => clk_sys0,           --  62.5MHz
			outclk_1 => clk_sys1,           -- 100  MHz
			outclk_2 => clk_sys2,           --  20  MHz
			outclk_3 => clk_sys3,           --  10  MHz
			locked   => sys_locked);
		
	clk_sys <= clk_sys0;
	
	reset : altera_reset
	  generic map(
	    g_plls   => 1,
	    g_clocks => 1)
	  port map(
	    clk_free_i    => core_clk_125m_local_i,
		 rstn_i        => '1',
		 pll_lock_i(0) => sys_locked,
		 pll_arst_o    => pll_rst,
		 clocks_i(0)   => clk_sys,
		 rstn_o(0)     => rstn_sys);
		
	----------------------------------------------------------------------------------
	-- Wishbone crossbars ------------------------------------------------------------
	----------------------------------------------------------------------------------
  
	top_bar : xwb_sdb_crossbar
		generic map(
			g_num_masters => c_top_masters,
			g_num_slaves  => c_top_slaves,
			g_registered  => true,
			g_wraparound  => true,
			g_layout      => c_top_layout,
			g_sdb_addr    => c_top_sdb_address)
		port map(
			clk_sys_i     => clk_sys,
			rst_n_i       => rstn_sys,
			slave_i       => top_cbar_slave_i,
			slave_o       => top_cbar_slave_o,
			master_i      => top_cbar_master_i,
			master_o      => top_cbar_master_o);
		
	------------------------------------------------------------------------------------------
	-- Wishbone slaves build id---------------------------------------------------------------
	------------------------------------------------------------------------------------------
	
	id : build_id
		port map(
			clk_i   => clk_sys,
			rst_n_i => rstn_sys,
			slave_i => top_cbar_master_o(c_tops_build_id),
			slave_o => top_cbar_master_i(c_tops_build_id));

	LED7 <= 'Z';
	LED3 <= 'Z';
	LED4 <= 'Z';
	LED5 <= '0';
	LED6 <= 'Z';
	LED1 <= 'Z';

END LogicFunction ;
