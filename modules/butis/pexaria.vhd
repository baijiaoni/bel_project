LIBRARY ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wr_altera_pkg.all;
use work.ez_usb_pkg.all;
use work.wishbone_pkg.all;

ENTITY pexaria_e IS 
	PORT (   clk_i       : IN  STD_LOGIC; -- BuTis 200MHz input through extension port 9 pin
		      clk_sys_i   : IN  STD_LOGIC; -- 62.5MHz
			   rst_n_i     : in  std_logic;
--	         osc      : IN  STD_LOGIC; -- local 125MHz quartz
			   io1_o       : OUT STD_LOGIC; --output 10MHz
			   io2_i       : IN  STD_LOGIC; --input 100KHz 
			   button_i    : IN  STD_LOGIC ; --reset the count1 to zero and turn off the LED1
			   LED2_o      : out std_LOGIC;
            -- Wishbone interface
            slave_o     : out t_wishbone_slave_out;
            slave_i     : in  t_wishbone_slave_in
);
			 		 
END pexaria_e ; 

ARCHITECTURE LogicFunction OF pexaria_e IS 
   signal foo        : std_logic;--10MHz
   signal count      : unsigned(6 DOWNTO 0);
   signal counterror : unsigned(6 DOWNTO 0); -- count for the mis synchronization 
   signal last       : std_LOGIC;
   signal lastb      : std_LOGIC;
   signal r_ack      : std_LOGIC := '0';
   signal r_err      : std_LOGIC := '0';	
   signal r_stall    : std_LOGIC := '0';
   signal r_dato     : t_wishbone_data;
   signal r_echo     : t_wishbone_data;
   signal r_clr      : std_logic_vector(0 downto 0);   

   constant c_CNT    : natural   := 0;         -- Read Counter, ro  0x00 
   constant c_CLR    : natural   := c_CNT +4;  -- Clear counter, wo 0x04
   constant c_ECHO   : natural   := c_CLR +4;  -- Echo register, rw 0x08
 



BEGIN
	
	slave_o.ack    <= r_ack;
	slave_o.err    <= r_err;
	slave_o.rty    <= '0';
	slave_o.stall  <= r_stall;
	slave_o.int    <= '0';
	slave_o.dat    <= r_dato;

   wb_if : process(clk_sys_i) is
      variable v_en  :std_logic;
      variable v_adr :natural ;
      variable v_we  :std_logic;

   begin
      if rising_edge(clk_sys_i) then
         if rst_n_i = '0' then
            r_echo   <= x"deadbeef";
            r_stall  <= '0';
            r_ack    <= '0';
            r_err    <= '0';
         else
            v_en  := slave_i.cyc and slave_i.stb and not r_stall;
            v_adr := to_integer(unsigned(slave_i.adr(7 downto 0)));
            v_we  := slave_i.we;
				r_echo   <= x"deadbeef";
            r_dato <= (others => '0');
            r_clr  <= "0";
				r_ack  <= '0';
				r_err  <= '0';

            if v_en = '1' then
               r_ack <= '1';
               if v_we ='1' then
                  case v_adr is
                     when c_CLR  => r_clr    <= f_wb_wr(r_clr,  slave_i.dat, slave_i.sel, "set");
                     when c_ECHO => r_echo   <= f_wb_wr(r_echo, slave_i.dat, slave_i.sel, "owr");
                     when others => r_ack    <= '0'; r_err <= '1';
                  end case;
               else                
                  case v_adr is
                     when c_CNT  => r_dato(counterror'range) <= std_logic_vector(counterror);
                     when c_ECHO => r_dato(r_echo'range)     <= r_echo;
                     when others => r_ack    <= '0'; r_err <= '1';
                  end case;
               end if; -- we
            end if; -- en
         end if; -- rst
      end if; -- rising edg
   end process;
		
		counter : process(clk_i) is 
		BEGIN
		if rising_edge(clk_i) then 
			if ((lastb = '1' and button_i = '0') or r_clr = "1") then
				counterror <= "0000000";
			end if;	
			if (last = '1' and io2_i = '0') then
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
		   last <= io2_i;
			lastb <= button_i;
		end if;

	end process;
   io1_o <= foo;
	LED2_o <= 'Z' when counterror= x"00000000" else '0';
	--LED1_o <= 'Z' when counterror = 0 else '0';
	

END LogicFunction ;
