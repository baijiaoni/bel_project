-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Full Version"

-- DATE "02/20/2014 15:19:08"

-- 
-- Device: Altera 5AGXMA3D4F27C5 Package FBGA672
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY ARRIAV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE ARRIAV.ARRIAV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	pexaria IS
    PORT (
	\io1(n)\ : OUT std_logic;
	\io3(n)\ : OUT std_logic;
	\io2(n)\ : IN std_logic := '0';
	clk : IN std_logic;
	io1 : OUT std_logic;
	io2 : IN std_logic;
	io3 : OUT std_logic;
	TTLEN1 : OUT std_logic;
	TTLEN2 : OUT std_logic;
	TTLEN3 : OUT std_logic;
	TTLTERM1 : OUT std_logic;
	TTLTERM2 : OUT std_logic;
	TTLTERM3 : OUT std_logic;
	LED1 : OUT std_logic;
	LED2 : OUT std_logic;
	LED3 : OUT std_logic;
	LED4 : OUT std_logic;
	LED5 : OUT std_logic;
	LED6 : OUT std_logic;
	LED7 : OUT std_logic;
	button : IN std_logic;
	slrd : OUT std_logic;
	slwr : OUT std_logic;
	fd : INOUT std_logic_vector(7 DOWNTO 0);
	pa : INOUT std_logic_vector(7 DOWNTO 0);
	ctl : IN std_logic_vector(2 DOWNTO 0);
	uclk : IN std_logic;
	ures : OUT std_logic
	);
END pexaria;

-- Design Ports Information
-- io1	=>  Location: PIN_J10,	 I/O Standard: LVDS,	 Current Strength: Default
-- io3	=>  Location: PIN_A8,	 I/O Standard: LVDS,	 Current Strength: Default
-- TTLEN1	=>  Location: PIN_T3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- TTLEN2	=>  Location: PIN_P3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- TTLEN3	=>  Location: PIN_N6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- TTLTERM1	=>  Location: PIN_U1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- TTLTERM2	=>  Location: PIN_T7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- TTLTERM3	=>  Location: PIN_T6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- LED1	=>  Location: PIN_AD22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED2	=>  Location: PIN_AC22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED3	=>  Location: PIN_AF22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED4	=>  Location: PIN_AF23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED5	=>  Location: PIN_AF20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED6	=>  Location: PIN_AE19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED7	=>  Location: PIN_AF19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- slrd	=>  Location: PIN_AF5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- slwr	=>  Location: PIN_AE4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- ctl[0]	=>  Location: PIN_AA7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- ctl[1]	=>  Location: PIN_AC3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- ctl[2]	=>  Location: PIN_AD3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- uclk	=>  Location: PIN_AB6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- ures	=>  Location: PIN_AC6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[0]	=>  Location: PIN_AB3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[1]	=>  Location: PIN_AB4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[2]	=>  Location: PIN_AD5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[3]	=>  Location: PIN_AB2,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[4]	=>  Location: PIN_AE3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[5]	=>  Location: PIN_AD4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[6]	=>  Location: PIN_AF3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- fd[7]	=>  Location: PIN_AC1,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[0]	=>  Location: PIN_V9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[1]	=>  Location: PIN_W9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[2]	=>  Location: PIN_Y9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[3]	=>  Location: PIN_AA9,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[4]	=>  Location: PIN_AE6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[5]	=>  Location: PIN_AF6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[6]	=>  Location: PIN_AD6,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- pa[7]	=>  Location: PIN_AC5,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- io2	=>  Location: PIN_D9,	 I/O Standard: LVDS,	 Current Strength: Default
-- clk	=>  Location: PIN_AF21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- button	=>  Location: PIN_AA18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- io1(n)	=>  Location: PIN_K10,	 I/O Standard: LVDS,	 Current Strength: Default
-- io3(n)	=>  Location: PIN_A9,	 I/O Standard: LVDS,	 Current Strength: Default
-- io2(n)	=>  Location: PIN_E9,	 I/O Standard: LVDS,	 Current Strength: Default


ARCHITECTURE structure OF pexaria IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \ww_io1(n)\ : std_logic;
SIGNAL \ww_io3(n)\ : std_logic;
SIGNAL \ww_io2(n)\ : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_io1 : std_logic;
SIGNAL ww_io2 : std_logic;
SIGNAL ww_io3 : std_logic;
SIGNAL ww_TTLEN1 : std_logic;
SIGNAL ww_TTLEN2 : std_logic;
SIGNAL ww_TTLEN3 : std_logic;
SIGNAL ww_TTLTERM1 : std_logic;
SIGNAL ww_TTLTERM2 : std_logic;
SIGNAL ww_TTLTERM3 : std_logic;
SIGNAL ww_LED1 : std_logic;
SIGNAL ww_LED2 : std_logic;
SIGNAL ww_LED3 : std_logic;
SIGNAL ww_LED4 : std_logic;
SIGNAL ww_LED5 : std_logic;
SIGNAL ww_LED6 : std_logic;
SIGNAL ww_LED7 : std_logic;
SIGNAL ww_button : std_logic;
SIGNAL ww_slrd : std_logic;
SIGNAL ww_slwr : std_logic;
SIGNAL ww_ctl : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_uclk : std_logic;
SIGNAL ww_ures : std_logic;
SIGNAL \ctl[0]~input_o\ : std_logic;
SIGNAL \ctl[1]~input_o\ : std_logic;
SIGNAL \ctl[2]~input_o\ : std_logic;
SIGNAL \uclk~input_o\ : std_logic;
SIGNAL \fd[0]~input_o\ : std_logic;
SIGNAL \fd[1]~input_o\ : std_logic;
SIGNAL \fd[2]~input_o\ : std_logic;
SIGNAL \fd[3]~input_o\ : std_logic;
SIGNAL \fd[4]~input_o\ : std_logic;
SIGNAL \fd[5]~input_o\ : std_logic;
SIGNAL \fd[6]~input_o\ : std_logic;
SIGNAL \fd[7]~input_o\ : std_logic;
SIGNAL \pa[0]~input_o\ : std_logic;
SIGNAL \pa[1]~input_o\ : std_logic;
SIGNAL \pa[2]~input_o\ : std_logic;
SIGNAL \pa[3]~input_o\ : std_logic;
SIGNAL \pa[4]~input_o\ : std_logic;
SIGNAL \pa[5]~input_o\ : std_logic;
SIGNAL \pa[6]~input_o\ : std_logic;
SIGNAL \pa[7]~input_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputCLKENA0_outclk\ : std_logic;
SIGNAL \~GND~combout\ : std_logic;
SIGNAL \counterror[0]~feeder_combout\ : std_logic;
SIGNAL \Add0~13_sumout\ : std_logic;
SIGNAL \Add1~13_sumout\ : std_logic;
SIGNAL \io2~input_o\ : std_logic;
SIGNAL \last~q\ : std_logic;
SIGNAL \process_0~0_combout\ : std_logic;
SIGNAL \Add1~14\ : std_logic;
SIGNAL \Add1~1_sumout\ : std_logic;
SIGNAL \Add1~2\ : std_logic;
SIGNAL \Add1~17_sumout\ : std_logic;
SIGNAL \Add1~18\ : std_logic;
SIGNAL \Add1~5_sumout\ : std_logic;
SIGNAL \Add1~6\ : std_logic;
SIGNAL \Add1~9_sumout\ : std_logic;
SIGNAL \Equal1~1_combout\ : std_logic;
SIGNAL \Add1~10\ : std_logic;
SIGNAL \Add1~21_sumout\ : std_logic;
SIGNAL \Add1~22\ : std_logic;
SIGNAL \Add1~25_sumout\ : std_logic;
SIGNAL \Equal1~0_combout\ : std_logic;
SIGNAL \Equal1~2_combout\ : std_logic;
SIGNAL \button~input_o\ : std_logic;
SIGNAL \lastb~q\ : std_logic;
SIGNAL \counterror[0]~0_combout\ : std_logic;
SIGNAL \counterror[3]~feeder_combout\ : std_logic;
SIGNAL \counterror[2]~feeder_combout\ : std_logic;
SIGNAL \counterror[1]~feeder_combout\ : std_logic;
SIGNAL \Add0~14\ : std_logic;
SIGNAL \Add0~17_sumout\ : std_logic;
SIGNAL \Add0~18\ : std_logic;
SIGNAL \Add0~21_sumout\ : std_logic;
SIGNAL \Add0~22\ : std_logic;
SIGNAL \Add0~25_sumout\ : std_logic;
SIGNAL \Equal2~0_combout\ : std_logic;
SIGNAL \counterror[5]~feeder_combout\ : std_logic;
SIGNAL \counterror[4]~feeder_combout\ : std_logic;
SIGNAL \Add0~26\ : std_logic;
SIGNAL \Add0~1_sumout\ : std_logic;
SIGNAL \Add0~2\ : std_logic;
SIGNAL \Add0~5_sumout\ : std_logic;
SIGNAL \counterror[6]~feeder_combout\ : std_logic;
SIGNAL \Add0~6\ : std_logic;
SIGNAL \Add0~9_sumout\ : std_logic;
SIGNAL \Equal2~1_combout\ : std_logic;
SIGNAL \foo~0_combout\ : std_logic;
SIGNAL \foo~q\ : std_logic;
SIGNAL count : std_logic_vector(6 DOWNTO 0);
SIGNAL counterror : std_logic_vector(6 DOWNTO 0);
SIGNAL \ALT_INV_button~input_o\ : std_logic;
SIGNAL \ALT_INV_io2~input_o\ : std_logic;
SIGNAL \ALT_INV_~GND~combout\ : std_logic;
SIGNAL \ALT_INV_lastb~q\ : std_logic;
SIGNAL \ALT_INV_Equal1~1_combout\ : std_logic;
SIGNAL \ALT_INV_Equal2~0_combout\ : std_logic;
SIGNAL \ALT_INV_process_0~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal1~0_combout\ : std_logic;
SIGNAL \ALT_INV_last~q\ : std_logic;
SIGNAL \ALT_INV_foo~q\ : std_logic;
SIGNAL ALT_INV_counterror : std_logic_vector(6 DOWNTO 0);
SIGNAL ALT_INV_count : std_logic_vector(6 DOWNTO 0);

BEGIN

\io1(n)\ <= \ww_io1(n)\;
\io3(n)\ <= \ww_io3(n)\;
\ww_io2(n)\ <= \io2(n)\;
ww_clk <= clk;
io1 <= ww_io1;
ww_io2 <= io2;
io3 <= ww_io3;
TTLEN1 <= ww_TTLEN1;
TTLEN2 <= ww_TTLEN2;
TTLEN3 <= ww_TTLEN3;
TTLTERM1 <= ww_TTLTERM1;
TTLTERM2 <= ww_TTLTERM2;
TTLTERM3 <= ww_TTLTERM3;
LED1 <= ww_LED1;
LED2 <= ww_LED2;
LED3 <= ww_LED3;
LED4 <= ww_LED4;
LED5 <= ww_LED5;
LED6 <= ww_LED6;
LED7 <= ww_LED7;
ww_button <= button;
slrd <= ww_slrd;
slwr <= ww_slwr;
ww_ctl <= ctl;
ww_uclk <= uclk;
ures <= ww_ures;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_button~input_o\ <= NOT \button~input_o\;
\ALT_INV_io2~input_o\ <= NOT \io2~input_o\;
\ALT_INV_~GND~combout\ <= NOT \~GND~combout\;
\ALT_INV_lastb~q\ <= NOT \lastb~q\;
\ALT_INV_Equal1~1_combout\ <= NOT \Equal1~1_combout\;
\ALT_INV_Equal2~0_combout\ <= NOT \Equal2~0_combout\;
\ALT_INV_process_0~0_combout\ <= NOT \process_0~0_combout\;
\ALT_INV_Equal1~0_combout\ <= NOT \Equal1~0_combout\;
\ALT_INV_last~q\ <= NOT \last~q\;
\ALT_INV_foo~q\ <= NOT \foo~q\;
ALT_INV_counterror(3) <= NOT counterror(3);
ALT_INV_counterror(2) <= NOT counterror(2);
ALT_INV_counterror(1) <= NOT counterror(1);
ALT_INV_counterror(0) <= NOT counterror(0);
ALT_INV_counterror(6) <= NOT counterror(6);
ALT_INV_counterror(5) <= NOT counterror(5);
ALT_INV_counterror(4) <= NOT counterror(4);
ALT_INV_count(6) <= NOT count(6);
ALT_INV_count(5) <= NOT count(5);
ALT_INV_count(2) <= NOT count(2);
ALT_INV_count(0) <= NOT count(0);
ALT_INV_count(4) <= NOT count(4);
ALT_INV_count(3) <= NOT count(3);
ALT_INV_count(1) <= NOT count(1);

-- Location: IOOBUF_X5_Y0_N2
\LED1~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \Equal2~1_combout\,
	devoe => ww_devoe,
	o => ww_LED1);

-- Location: IOOBUF_X5_Y0_N19
\LED2~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_LED2);

-- Location: IOOBUF_X6_Y0_N19
\LED3~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_LED3);

-- Location: IOOBUF_X6_Y0_N2
\LED4~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_LED4);

-- Location: IOOBUF_X11_Y0_N42
\LED5~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_LED5);

-- Location: IOOBUF_X13_Y0_N19
\LED6~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_LED6);

-- Location: IOOBUF_X11_Y0_N59
\LED7~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_LED7);

-- Location: IOOBUF_X69_Y90_N36
\io1~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \foo~q\,
	devoe => ww_devoe,
	o => ww_io1,
	obar => \ww_io1(n)\);

-- Location: IOOBUF_X71_Y90_N36
\io3~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \io2~input_o\,
	devoe => ww_devoe,
	o => ww_io3,
	obar => \ww_io3(n)\);

-- Location: IOOBUF_X97_Y22_N39
\TTLEN1~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_TTLEN1);

-- Location: IOOBUF_X97_Y25_N39
\TTLEN2~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_TTLEN2);

-- Location: IOOBUF_X97_Y29_N56
\TTLEN3~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_TTLEN3);

-- Location: IOOBUF_X97_Y22_N22
\TTLTERM1~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_TTLTERM1);

-- Location: IOOBUF_X97_Y16_N79
\TTLTERM2~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => ww_TTLTERM2);

-- Location: IOOBUF_X97_Y23_N79
\TTLTERM3~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_TTLTERM3);

-- Location: IOOBUF_X73_Y0_N19
\slrd~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_slrd);

-- Location: IOOBUF_X73_Y0_N2
\slwr~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_slwr);

-- Location: IOOBUF_X80_Y0_N36
\ures~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_ures);

-- Location: IOOBUF_X80_Y0_N2
\fd[0]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(0));

-- Location: IOOBUF_X80_Y0_N19
\fd[1]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(1));

-- Location: IOOBUF_X76_Y0_N19
\fd[2]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(2));

-- Location: IOOBUF_X78_Y0_N19
\fd[3]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(3));

-- Location: IOOBUF_X75_Y0_N59
\fd[4]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(4));

-- Location: IOOBUF_X76_Y0_N2
\fd[5]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(5));

-- Location: IOOBUF_X75_Y0_N42
\fd[6]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(6));

-- Location: IOOBUF_X78_Y0_N2
\fd[7]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => fd(7));

-- Location: IOOBUF_X67_Y0_N93
\pa[0]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(0));

-- Location: IOOBUF_X67_Y0_N76
\pa[1]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(1));

-- Location: IOOBUF_X69_Y0_N53
\pa[2]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(2));

-- Location: IOOBUF_X69_Y0_N36
\pa[3]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(3));

-- Location: IOOBUF_X71_Y0_N53
\pa[4]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(4));

-- Location: IOOBUF_X71_Y0_N36
\pa[5]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(5));

-- Location: IOOBUF_X75_Y0_N93
\pa[6]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(6));

-- Location: IOOBUF_X75_Y0_N76
\pa[7]~output\ : arriav_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => pa(7));

-- Location: IOIBUF_X7_Y0_N1
\clk~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G2
\clk~inputCLKENA0\ : arriav_clkena
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	disable_mode => "low",
	ena_register_mode => "always enabled",
	ena_register_power_up => "high",
	test_syn => "high")
-- pragma translate_on
PORT MAP (
	inclk => \clk~input_o\,
	outclk => \clk~inputCLKENA0_outclk\);

-- Location: LABCELL_X68_Y89_N24
\~GND\ : arriav_lcell_comb
-- Equation(s):
-- \~GND~combout\ = GND

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	combout => \~GND~combout\);

-- Location: LABCELL_X68_Y89_N12
\counterror[0]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[0]~feeder_combout\ = \~GND~combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_~GND~combout\,
	combout => \counterror[0]~feeder_combout\);

-- Location: LABCELL_X68_Y89_N30
\Add0~13\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~13_sumout\ = SUM(( counterror(0) ) + ( VCC ) + ( !VCC ))
-- \Add0~14\ = CARRY(( counterror(0) ) + ( VCC ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => ALT_INV_counterror(0),
	cin => GND,
	sumout => \Add0~13_sumout\,
	cout => \Add0~14\);

-- Location: LABCELL_X69_Y89_N0
\Add1~13\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~13_sumout\ = SUM(( count(0) ) + ( VCC ) + ( !VCC ))
-- \Add1~14\ = CARRY(( count(0) ) + ( VCC ) + ( !VCC ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(0),
	cin => GND,
	sumout => \Add1~13_sumout\,
	cout => \Add1~14\);

-- Location: IOIBUF_X69_Y90_N1
\io2~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_io2,
	ibar => \ww_io2(n)\,
	o => \io2~input_o\);

-- Location: FF_X69_Y89_N38
last : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \io2~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \last~q\);

-- Location: LABCELL_X69_Y89_N36
\process_0~0\ : arriav_lcell_comb
-- Equation(s):
-- \process_0~0_combout\ = ( !\io2~input_o\ & ( \last~q\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000000000000000000001111000011110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_last~q\,
	datae => \ALT_INV_io2~input_o\,
	combout => \process_0~0_combout\);

-- Location: FF_X69_Y89_N1
\count[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~13_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(0));

-- Location: LABCELL_X69_Y89_N3
\Add1~1\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~1_sumout\ = SUM(( count(1) ) + ( GND ) + ( \Add1~14\ ))
-- \Add1~2\ = CARRY(( count(1) ) + ( GND ) + ( \Add1~14\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(1),
	cin => \Add1~14\,
	sumout => \Add1~1_sumout\,
	cout => \Add1~2\);

-- Location: FF_X69_Y89_N5
\count[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~1_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(1));

-- Location: LABCELL_X69_Y89_N6
\Add1~17\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~17_sumout\ = SUM(( count(2) ) + ( GND ) + ( \Add1~2\ ))
-- \Add1~18\ = CARRY(( count(2) ) + ( GND ) + ( \Add1~2\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(2),
	cin => \Add1~2\,
	sumout => \Add1~17_sumout\,
	cout => \Add1~18\);

-- Location: FF_X69_Y89_N7
\count[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~17_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(2));

-- Location: LABCELL_X69_Y89_N9
\Add1~5\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~5_sumout\ = SUM(( count(3) ) + ( GND ) + ( \Add1~18\ ))
-- \Add1~6\ = CARRY(( count(3) ) + ( GND ) + ( \Add1~18\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(3),
	cin => \Add1~18\,
	sumout => \Add1~5_sumout\,
	cout => \Add1~6\);

-- Location: FF_X69_Y89_N11
\count[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~5_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(3));

-- Location: LABCELL_X69_Y89_N12
\Add1~9\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~9_sumout\ = SUM(( count(4) ) + ( GND ) + ( \Add1~6\ ))
-- \Add1~10\ = CARRY(( count(4) ) + ( GND ) + ( \Add1~6\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(4),
	cin => \Add1~6\,
	sumout => \Add1~9_sumout\,
	cout => \Add1~10\);

-- Location: FF_X69_Y89_N14
\count[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~9_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(4));

-- Location: LABCELL_X69_Y89_N45
\Equal1~1\ : arriav_lcell_comb
-- Equation(s):
-- \Equal1~1_combout\ = ( !count(3) & ( (count(1) & count(4)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000010100000101000001010000010100000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_count(1),
	datac => ALT_INV_count(4),
	dataf => ALT_INV_count(3),
	combout => \Equal1~1_combout\);

-- Location: LABCELL_X69_Y89_N15
\Add1~21\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~21_sumout\ = SUM(( count(5) ) + ( GND ) + ( \Add1~10\ ))
-- \Add1~22\ = CARRY(( count(5) ) + ( GND ) + ( \Add1~10\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(5),
	cin => \Add1~10\,
	sumout => \Add1~21_sumout\,
	cout => \Add1~22\);

-- Location: FF_X69_Y89_N16
\count[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~21_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(5));

-- Location: LABCELL_X69_Y89_N18
\Add1~25\ : arriav_lcell_comb
-- Equation(s):
-- \Add1~25_sumout\ = SUM(( count(6) ) + ( GND ) + ( \Add1~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_count(6),
	cin => \Add1~22\,
	sumout => \Add1~25_sumout\);

-- Location: FF_X69_Y89_N19
\count[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Add1~25_sumout\,
	asdata => \~GND~combout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => count(6));

-- Location: LABCELL_X69_Y89_N42
\Equal1~0\ : arriav_lcell_comb
-- Equation(s):
-- \Equal1~0_combout\ = ( !count(5) & ( (!count(6) & (count(0) & !count(2))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000110000000000000011000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => ALT_INV_count(6),
	datac => ALT_INV_count(0),
	datad => ALT_INV_count(2),
	dataf => ALT_INV_count(5),
	combout => \Equal1~0_combout\);

-- Location: LABCELL_X69_Y89_N48
\Equal1~2\ : arriav_lcell_comb
-- Equation(s):
-- \Equal1~2_combout\ = ( \Equal1~1_combout\ & ( \Equal1~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_Equal1~1_combout\,
	dataf => \ALT_INV_Equal1~0_combout\,
	combout => \Equal1~2_combout\);

-- Location: IOIBUF_X30_Y0_N92
\button~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_button,
	o => \button~input_o\);

-- Location: FF_X69_Y89_N55
lastb : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \button~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \lastb~q\);

-- Location: LABCELL_X69_Y89_N54
\counterror[0]~0\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[0]~0_combout\ = ( \button~input_o\ & ( \Equal1~0_combout\ & ( (!\Equal1~1_combout\ & (\last~q\ & !\io2~input_o\)) ) ) ) # ( !\button~input_o\ & ( \Equal1~0_combout\ & ( ((!\Equal1~1_combout\ & (\last~q\ & !\io2~input_o\))) # (\lastb~q\) ) ) ) 
-- # ( \button~input_o\ & ( !\Equal1~0_combout\ & ( (\last~q\ & !\io2~input_o\) ) ) ) # ( !\button~input_o\ & ( !\Equal1~0_combout\ & ( ((\last~q\ & !\io2~input_o\)) # (\lastb~q\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101111101010101000011110000000001011101010101010000110000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_lastb~q\,
	datab => \ALT_INV_Equal1~1_combout\,
	datac => \ALT_INV_last~q\,
	datad => \ALT_INV_io2~input_o\,
	datae => \ALT_INV_button~input_o\,
	dataf => \ALT_INV_Equal1~0_combout\,
	combout => \counterror[0]~0_combout\);

-- Location: FF_X68_Y89_N14
\counterror[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[0]~feeder_combout\,
	asdata => \Add0~13_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(0));

-- Location: LABCELL_X69_Y89_N27
\counterror[3]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[3]~feeder_combout\ = \~GND~combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001100110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_~GND~combout\,
	combout => \counterror[3]~feeder_combout\);

-- Location: LABCELL_X69_Y89_N24
\counterror[2]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[2]~feeder_combout\ = \~GND~combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100110011001100110011001100110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_~GND~combout\,
	combout => \counterror[2]~feeder_combout\);

-- Location: LABCELL_X68_Y89_N15
\counterror[1]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[1]~feeder_combout\ = \~GND~combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_~GND~combout\,
	combout => \counterror[1]~feeder_combout\);

-- Location: LABCELL_X68_Y89_N33
\Add0~17\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~17_sumout\ = SUM(( counterror(1) ) + ( GND ) + ( \Add0~14\ ))
-- \Add0~18\ = CARRY(( counterror(1) ) + ( GND ) + ( \Add0~14\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => ALT_INV_counterror(1),
	cin => \Add0~14\,
	sumout => \Add0~17_sumout\,
	cout => \Add0~18\);

-- Location: FF_X68_Y89_N17
\counterror[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[1]~feeder_combout\,
	asdata => \Add0~17_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(1));

-- Location: LABCELL_X68_Y89_N36
\Add0~21\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~21_sumout\ = SUM(( counterror(2) ) + ( GND ) + ( \Add0~18\ ))
-- \Add0~22\ = CARRY(( counterror(2) ) + ( GND ) + ( \Add0~18\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => ALT_INV_counterror(2),
	cin => \Add0~18\,
	sumout => \Add0~21_sumout\,
	cout => \Add0~22\);

-- Location: FF_X69_Y89_N26
\counterror[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[2]~feeder_combout\,
	asdata => \Add0~21_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(2));

-- Location: LABCELL_X68_Y89_N39
\Add0~25\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~25_sumout\ = SUM(( counterror(3) ) + ( GND ) + ( \Add0~22\ ))
-- \Add0~26\ = CARRY(( counterror(3) ) + ( GND ) + ( \Add0~22\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000000011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datad => ALT_INV_counterror(3),
	cin => \Add0~22\,
	sumout => \Add0~25_sumout\,
	cout => \Add0~26\);

-- Location: FF_X69_Y89_N29
\counterror[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[3]~feeder_combout\,
	asdata => \Add0~25_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(3));

-- Location: LABCELL_X68_Y89_N18
\Equal2~0\ : arriav_lcell_comb
-- Equation(s):
-- \Equal2~0_combout\ = ( !counterror(2) & ( (!counterror(0) & (!counterror(3) & !counterror(1))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1100000000000000110000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => ALT_INV_counterror(0),
	datac => ALT_INV_counterror(3),
	datad => ALT_INV_counterror(1),
	dataf => ALT_INV_counterror(2),
	combout => \Equal2~0_combout\);

-- Location: LABCELL_X68_Y89_N6
\counterror[5]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[5]~feeder_combout\ = \~GND~combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_~GND~combout\,
	combout => \counterror[5]~feeder_combout\);

-- Location: LABCELL_X68_Y89_N3
\counterror[4]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[4]~feeder_combout\ = ( \~GND~combout\ )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataf => \ALT_INV_~GND~combout\,
	combout => \counterror[4]~feeder_combout\);

-- Location: LABCELL_X68_Y89_N42
\Add0~1\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~1_sumout\ = SUM(( counterror(4) ) + ( GND ) + ( \Add0~26\ ))
-- \Add0~2\ = CARRY(( counterror(4) ) + ( GND ) + ( \Add0~26\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => ALT_INV_counterror(4),
	cin => \Add0~26\,
	sumout => \Add0~1_sumout\,
	cout => \Add0~2\);

-- Location: FF_X68_Y89_N5
\counterror[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[4]~feeder_combout\,
	asdata => \Add0~1_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(4));

-- Location: LABCELL_X68_Y89_N45
\Add0~5\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~5_sumout\ = SUM(( counterror(5) ) + ( GND ) + ( \Add0~2\ ))
-- \Add0~6\ = CARRY(( counterror(5) ) + ( GND ) + ( \Add0~2\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => ALT_INV_counterror(5),
	cin => \Add0~2\,
	sumout => \Add0~5_sumout\,
	cout => \Add0~6\);

-- Location: FF_X68_Y89_N8
\counterror[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[5]~feeder_combout\,
	asdata => \Add0~5_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(5));

-- Location: LABCELL_X68_Y89_N9
\counterror[6]~feeder\ : arriav_lcell_comb
-- Equation(s):
-- \counterror[6]~feeder_combout\ = \~GND~combout\

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010101010101010101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_~GND~combout\,
	combout => \counterror[6]~feeder_combout\);

-- Location: LABCELL_X68_Y89_N48
\Add0~9\ : arriav_lcell_comb
-- Equation(s):
-- \Add0~9_sumout\ = SUM(( counterror(6) ) + ( GND ) + ( \Add0~6\ ))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100000000000000000011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => ALT_INV_counterror(6),
	cin => \Add0~6\,
	sumout => \Add0~9_sumout\);

-- Location: FF_X68_Y89_N11
\counterror[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \counterror[6]~feeder_combout\,
	asdata => \Add0~9_sumout\,
	sclr => \Equal1~2_combout\,
	sload => \process_0~0_combout\,
	ena => \counterror[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counterror(6));

-- Location: LABCELL_X68_Y89_N21
\Equal2~1\ : arriav_lcell_comb
-- Equation(s):
-- \Equal2~1_combout\ = ( !counterror(6) & ( (\Equal2~0_combout\ & (!counterror(5) & !counterror(4))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000000000010100000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Equal2~0_combout\,
	datac => ALT_INV_counterror(5),
	datad => ALT_INV_counterror(4),
	dataf => ALT_INV_counterror(6),
	combout => \Equal2~1_combout\);

-- Location: LABCELL_X69_Y89_N30
\foo~0\ : arriav_lcell_comb
-- Equation(s):
-- \foo~0_combout\ = ( \foo~q\ & ( count(3) & ( !\process_0~0_combout\ ) ) ) # ( !\foo~q\ & ( count(3) & ( (!\process_0~0_combout\ & (!count(4) & (!count(1) & \Equal1~0_combout\))) ) ) ) # ( \foo~q\ & ( !count(3) & ( (!\process_0~0_combout\ & ((!count(4)) # 
-- ((!count(1)) # (!\Equal1~0_combout\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000101010101010100000000000100000001010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_process_0~0_combout\,
	datab => ALT_INV_count(4),
	datac => ALT_INV_count(1),
	datad => \ALT_INV_Equal1~0_combout\,
	datae => \ALT_INV_foo~q\,
	dataf => ALT_INV_count(3),
	combout => \foo~0_combout\);

-- Location: FF_X69_Y89_N31
foo : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \foo~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \foo~q\);

-- Location: IOIBUF_X76_Y0_N35
\ctl[0]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ctl(0),
	o => \ctl[0]~input_o\);

-- Location: IOIBUF_X78_Y0_N52
\ctl[1]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ctl(1),
	o => \ctl[1]~input_o\);

-- Location: IOIBUF_X78_Y0_N35
\ctl[2]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ctl(2),
	o => \ctl[2]~input_o\);

-- Location: IOIBUF_X80_Y0_N52
\uclk~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_uclk,
	o => \uclk~input_o\);

-- Location: IOIBUF_X80_Y0_N1
\fd[0]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(0),
	o => \fd[0]~input_o\);

-- Location: IOIBUF_X80_Y0_N18
\fd[1]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(1),
	o => \fd[1]~input_o\);

-- Location: IOIBUF_X76_Y0_N18
\fd[2]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(2),
	o => \fd[2]~input_o\);

-- Location: IOIBUF_X78_Y0_N18
\fd[3]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(3),
	o => \fd[3]~input_o\);

-- Location: IOIBUF_X75_Y0_N58
\fd[4]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(4),
	o => \fd[4]~input_o\);

-- Location: IOIBUF_X76_Y0_N1
\fd[5]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(5),
	o => \fd[5]~input_o\);

-- Location: IOIBUF_X75_Y0_N41
\fd[6]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(6),
	o => \fd[6]~input_o\);

-- Location: IOIBUF_X78_Y0_N1
\fd[7]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => fd(7),
	o => \fd[7]~input_o\);

-- Location: IOIBUF_X67_Y0_N92
\pa[0]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(0),
	o => \pa[0]~input_o\);

-- Location: IOIBUF_X67_Y0_N75
\pa[1]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(1),
	o => \pa[1]~input_o\);

-- Location: IOIBUF_X69_Y0_N52
\pa[2]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(2),
	o => \pa[2]~input_o\);

-- Location: IOIBUF_X69_Y0_N35
\pa[3]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(3),
	o => \pa[3]~input_o\);

-- Location: IOIBUF_X71_Y0_N52
\pa[4]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(4),
	o => \pa[4]~input_o\);

-- Location: IOIBUF_X71_Y0_N35
\pa[5]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(5),
	o => \pa[5]~input_o\);

-- Location: IOIBUF_X75_Y0_N92
\pa[6]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(6),
	o => \pa[6]~input_o\);

-- Location: IOIBUF_X75_Y0_N75
\pa[7]~input\ : arriav_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => pa(7),
	o => \pa[7]~input_o\);
END structure;


