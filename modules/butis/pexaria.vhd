LIBRARY ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wr_altera_pkg.all;
use work.ez_usb_pkg.all;
use work.wishbone_pkg.all;

ENTITY pexaria_e IS 
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
END pexaria_e ; 

ARCHITECTURE LogicFunction OF pexaria_e IS 
   signal r_10m        : std_logic; -- 10MHz
	signal r_pps        : std_logic; --  1Hz
   signal r_count_10m  : unsigned(6 DOWNTO 0);
	signal r_count_pps  : unsigned(23 downto 0);
	signal s_100k_rising: boolean;
	signal s_10m_rising : boolean;
	signal s_10m_falling: boolean;
   signal counterror   : unsigned(6 DOWNTO 0); -- count for the mis synchronization 
   signal r_last_100k  : std_LOGIC;
   signal r_ack        : std_LOGIC := '0';
   signal r_err        : std_LOGIC := '0';	
   signal r_stall      : std_LOGIC := '0';
   signal r_dato       : t_wishbone_data;
   signal r_echo       : t_wishbone_data;
   signal r_clr        : std_logic_vector(0 downto 0);   

   constant c_CNT    : natural   := 0;         -- Read Counterror, ro  0x00 
   constant c_CLR    : natural   := c_CNT +4;  -- Clear counter, wo 0x04 if set to '1', turn light off and make counterror = 0
   constant c_ECHO   : natural   := c_CLR +4;  -- Echo register, rw 0x08

BEGIN
	
	slave_o.ack    <= r_ack;
	slave_o.err    <= r_err;
	slave_o.rty    <= '0';
	slave_o.stall  <= r_stall;
	slave_o.int    <= '0';
	slave_o.dat    <= r_dato;

   wb_if : process(clk_sys_i, rstn_sys_i) is
      variable v_en  :std_logic;
      variable v_adr :natural ;
      variable v_we  :std_logic;
   begin
      if rstn_sys_i = '0' then
			r_echo   <= x"deadbeef";
			r_stall  <= '0';
			r_ack    <= '0';
			r_err    <= '0';
      elsif rising_edge(clk_sys_i) then
			v_en  := slave_i.cyc and slave_i.stb and not r_stall;
			v_adr := to_integer(unsigned(slave_i.adr(7 downto 2))) * 4;
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
      end if;
   end process;
		
	s_100k_rising <= r_last_100k = '0' and clk_100k_i = '1';
	s_10m_rising  <= s_100k_rising or r_count_10m = 19;
   s_10m_falling <= r_count_10m = 9;

	counter : process(clk_200m_i) is 
	BEGIN
		if rising_edge(clk_200m_i) then  -- 200MHz
			-- Divide 200MHz to 10MHz (aligned to 100KHz)
			if (s_10m_rising) then
				r_10m <= '1';
				r_count_10m <= (others => '0');
			elsif (s_10m_falling) then
				r_10m <= '0';
				r_count_10m <= r_count_10m + 1;
			else
				r_10m <= r_10m;
			   r_count_10m <= r_count_10m + 1;
			end if;
		   r_last_100k <= clk_100k_i;
			
			-- Divide 10MHz to 1Hz
			if (s_10m_falling) then
				if (r_count_pps = 5_000_000 - 1) then
					r_count_pps <= (others => '0');
					r_pps <= not r_pps;
				else
					r_count_pps <= r_count_pps + 1;
					r_pps <= r_pps;
				end if;
			end if;

			-- Count the synchronization errors
			if (button_i = '0' or r_clr = "1") then
				counterror <= "0000000";
			elsif (s_100k_rising and r_count_10m /= 19) then
				counterror <= counterror + 1;
			end if;
	
		end if;
	end process;
	
   clk_10m_o <= r_10m;
	fake_pps_o <= r_pps;
	aligned_o <= 'Z' when counterror= x"00000000" else '0';
	
END LogicFunction ;
