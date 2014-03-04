--*************************************----
LIBRARY ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wr_altera_pkg.all;
use work.ez_usb_pkg.all;
use work.wishbone_pkg.all;
use work.pexaria_PKG.all;

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
	 
	 --clokc
	 core_clk_125m_local_i  : in    std_logic);
 
			 		 
END pexaria ; 

ARCHITECTURE LogicFunction OF pexaria IS
--   signal foo : std_logic;--10MHz
--	signal count : unsigned(6 DOWNTO 0);
--	signal counterror : unsigned(6 DOWNTO 0); -- count for the mis synchronization 
--	signal last :std_LOGIC;
--	signal lastb :std_LOGIC;
   signal clk_200_local : std_logic;
	
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
	
	signal wb_master_i		: t_wishbone_master_in;
	signal wb_master_o 		: t_wishbone_master_out;
	
BEGIN
	
	TTLEN1 <= '0'; -- enable output
	TTLEN2 <= '1'; -- disable output (input)
	TTLEN3 <= '0'; -- enable output
	
	TTLTERM1 <= '0'; -- disconnect 50Ohm termination
	TTLTERM2 <= '1'; -- terminate input with 50Ohm
	TTLTERM3 <= '0'; -- disconnect 50Ohm termination
	
	wb_master_i.ack <= wb_master_o.stb and wb_master_o.cyc;
	wb_master_i.err <= '0';
	wb_master_i.rty <= '0';
	wb_master_i.stall <= '0';
	wb_master_i.int <= '0';
	wb_master_i.dat (31 downto 7) <= (others => '0');
	wb_master_i.dat (6 downto 0) <= std_logic_vector(counterror(6 downto 0));
	
	   pexaria_e :pexaria port map(
			 clk_i      => clk;
			 io1_o      => io1;
			 io2_i      => io2;
			 io3_o      => io3;
			 TTLEN1_o   => TTLEN1;                                                 
			 TTLEN2_o   => TTLEN2; 
			 TTLEN3_o   => TTLEN3; 
			 TTLTERM1_o => TTLTERM1;
			 TTLTERM2_o => TTLTERM2;
			 TTLTERM3_o => TTLTERM3;
			 LED1_o     => LED1;
			 LED2_o     => LED2;
			 LED3_o     => LED3;
			 LED4_o     => LED4;
			 LED5_o     => LED5;
			 LED6_o     => LED6;
			 LED7_o     => LED7;
			 button_o   => button;
			 
			 -- Wishbone interface
	   	slave_o     => wb_master_i;
		   slave_i     => wb_master_o);		
			
	 usb_readyn_io <= 'Z';
    usb_fd_io <= s_usb_fd_o when s_usb_fd_oen='1' else (others => 'Z');
    usb : ez_usb
      generic map(
        g_sdb_address => x"00000000")
      port map(
        clk_sys_i => clk_sys,
        rstn_i    => rstn_sys,
        master_i  => wb_master_i,
        master_o  => wb_master_o,
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
		  
		sys_inst : sys_pll5 port map(
      rst      => pll_rst,
      refclk   => core_clk_125m_local_i, -- 125  Mhz 
      outclk_0 => clk_sys0,           --  62.5MHz
      outclk_1 => clk_sys1,           -- 100  MHz
      outclk_2 => clk_sys2,           --  20  MHz
      outclk_3 => clk_sys3,           --  10  MHz
      locked   => sys_locked);
		
		clk_sys <= clk_sys0;
		rstn_sys <= '1';
		
	
	process(clk) is 
		BEGIN
		if rising_edge(clk) then 
			if (lastb = '1' and button = '0') then
				counterror <= "0000000";
			end if;	
			if (last = '1' and io2 = '0') then
				foo <= '0'; 
				if (count /= 19) then --detect the dis synchronization
					counterror <= counterror + 1;
				end if;
				count <= (others => '0');
			else
				if (count = 9) then --foo 100KHz positive pulse
					count <= count + 1;
					foo <= '1';
				else
					if (count = 19) then --foo 100KHz negative pulse
					count <= (others => '0');
					foo <= '0'; 
					else 
					count <= count + 1;
					end if;
				end if;
			end if;
		   last <= io2;
			lastb <= button;
		end if;

	end process;
   io1 <= foo;
	io3 <= io2;
	
	LED2 <= 'Z';
	LED3 <= 'Z';
	LED4 <= 'Z';
	LED5 <= 'Z';
	LED6 <= 'Z';
	LED7 <= 'Z';

	LED1 <= 'Z' when counterror = 0 else '0';
	
--	LED2 <= '0' when counterror(1)='1' else 'Z';
--	LED3 <= '0' when counterror(2)='1' else 'Z';
--	LED4 <= '0' when counterror(3)='1' else 'Z';
--	LED5 <= '0' when counterror(4)='1' else 'Z';
--	LED6 <= '0' when counterror(5)='1' else 'Z';
--	LED7 <= '0' when counterror(6)='1' else 'Z';
	

END LogicFunction ;