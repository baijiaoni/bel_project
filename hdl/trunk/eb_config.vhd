--! @file EB_config.vhd
--! @brief EtherBone config space memory
--!
--! Copyright (C) 2011-2012 GSI Helmholtz Centre for Heavy Ion Research GmbH 
--!
--! Important details about its implementation
--! should go in these comments.
--!
--! @author Mathias Kreider <m.kreider@gsi.de>
--!
--! @bug No know bugs.
--!
--------------------------------------------------------------------------------
--! This library is free software; you can redistribute it and/or
--! modify it under the terms of the GNU Lesser General Public
--! License as published by the Free Software Foundation; either
--! version 3 of the License, or (at your option) any later version.
--!
--! This library is distributed in the hope that it will be useful,
--! but WITHOUT ANY WARRANTY; without even the implied warranty of
--! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--! Lesser General Public License for more details.
--!  
--! You should have received a copy of the GNU Lesser General Public
--! License along with this library. If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.wb32_package.all;

entity eb_config is 
generic(g_cnt_width : natural := 32);	-- MAX WIDTH 32
 port(
		clk_i    		: in    std_logic;                                        --clock
        nRST_i   		: in   	std_logic;
		status_i		: in 	std_logic;
		status_en		: in	std_logic;
		status_clr		: in	std_logic;
		
		wb_master_i     : in    wb32_master_in;
		wb_master_o     : out   wb32_master_out;	--! local Wishbone master lines
				
		wb_slave_o     : out   wb32_slave_out;	--! EB Wishbone slave lines
		wb_slave_i     : in    wb32_slave_in
    );
end eb_config;


architecture behavioral of eb_config is

subtype dword is std_logic_vector(31 downto 0);
type mem is array (0 to 7) of dword ; 
signal my_mem : mem;

signal wb_adr : natural;
signal status_reg : std_logic_vector(31 downto 0);

begin
 
wb_adr <= to_integer(unsigned(wb_slave_i.ADR(8 downto 0)));
	
wb32_if	:	process (clk_i)
  begin
      if (clk_i'event and clk_i = '1') then
        if(nRSt_i = '0') then
--			for i in 0 to 512 loop
--				my_mem(i) <= x"11DEAD99";
--			end loop;
			
			status_reg <= (others => '1');
			
			wb_slave_o	<=   (
												ACK   => '0',
												ERR   => '0',
												RTY   => '0',
												STALL => '0',
												DAT   => (others => '0'));
												
		else
            if(status_clr = '1') then
				status_reg <= (others => '1');
			elsif(status_en = '1') then
				status_reg <= status_reg(status_reg'left-1 downto 0) & status_i;
			end if;
			
			wb_slave_o.ACK <= wb_slave_i.CYC AND wb_slave_i.STB;
			wb_slave_o.DAT <= (others => '0');
			if(wb_slave_i.STB = '1' AND wb_slave_i.CYC = '1') then 
		
				if(wb_slave_i.WE ='1') then
					case wb_adr is
						when 0	=> null;
						when others => 	my_mem(wb_adr) <= wb_slave_i.DAT;
					end case;	
				else
					case wb_adr is
						when 0		=> wb_slave_o.DAT <= status_reg;
						when others => 	wb_slave_o.DAT <= my_mem(wb_adr);
					end case;	
					
				end if;	
			
			end if;
			
        end if;    
    end if;
end process;
  
end behavioral;
