library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.wishbone_pkg.all;

package pexaria_pkg is

	constant c_butis_conv_sdb : t_sdb_device := (
		abi_class     => x"0000", -- undocumented device
		abi_ver_major => x"01",
		abi_ver_minor => x"00",
		wbd_endian    => c_sdb_endian_big,
		wbd_width     => x"7", -- 8/16/32-bit port granularity
		sdb_component => (
		addr_first    => x"0000000000000000",
		addr_last     => x"00000000000000ff",
		product => (
		vendor_id     => x"0000000000000111",
		device_id     => x"2d39fa8b",
		version       => x"00000002",
		date          => x"20140228",
		name          => "GSI:Butis converter")));

	component pexaria_e IS 
		PORT(
			clk_200m_i  : IN  STD_LOGIC; -- BuTis 200MHz input through extension port 9 pin
			clk_sys_i   : IN  STD_LOGIC; -- 62.5MHz
			rstn_sys_i  : in  std_logic;
			clk_100k_i  : in  std_logic;
			clk_10m_o   : out std_logic;
			fake_pps_o  : out std_logic;
			button_i    : in  std_logic;
			aligned_o   : out std_logic;
			-- Wishbone interface
			slave_o     : out t_wishbone_slave_out;
			slave_i     : in  t_wishbone_slave_in);				 
	end component;
			 		 
END package;