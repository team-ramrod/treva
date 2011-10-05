library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;
use work.io_types.all;

entity leros_s3e_1600 is
port (
	clk     : in std_logic;
	leds     : out std_logic_vector(7 downto 0);
	pbtn	: in std_logic_vector(3 downto 0);
	sbtn	: in std_logic_vector(3 downto 0);
	rs232_dce_rxd : in  std_logic;
	rs232_dce_txd : out std_logic
);
end leros_s3e_1600;

architecture rtl of leros_s3e_1600 is
	signal clk_int			: std_logic;

	signal int_res			: std_logic;
	signal res_cnt			: unsigned(2 downto 0) := "000";	-- for the simulation

	signal ioout : io_out_type;
	signal ioin : io_in_type;
	
	signal outp 			: std_logic_vector(15 downto 0);
	signal inp 			: std_logic_vector(15 downto 0);
	
	signal data : std_logic_vector(15 downto 0);
	signal wr_dly : std_logic;
	
	signal pins_in : io_pins_in_type;
	signal pins_out : io_pins_out_type;
begin
	pins_in.sbtn <= sbtn;
	pins_in.pbtn <= pbtn;

	leds <= pins_out.leds;

	-- input clock is 50 MHz
	-- let's go for 200 MHz ;-)
	-- but for now 100 MHz is enough
	-- limit is 9.354ns => 100 MHz should be ok
	pll_inst : entity work.sp3epll generic map(
		multiply_by => 2,
		divide_by => 1
	)
	port map (
		CLKIN_IN => clk,
		RST_IN => '0',
		CLKFX_OUT => clk_int,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open,
		LOCKED_OUT => open
	);

--	internal reset generation
--	should include the PLL lock signal

process(clk_int)
begin
	if rising_edge(clk_int) then
		if (res_cnt/="111") then
			res_cnt <= res_cnt+1;
		end if;

		int_res <= not res_cnt(0) or not res_cnt(1) or not res_cnt(2);
	end if;
end process;


	cpu: entity work.leros
		port map(clk_int, int_res, ioout, ioin);
		
		leds <= pins_out.leds;
		pins_in.uart_rx <= rs232_dce_rxd;
		rs232_dce_txd <= pins_out.uart_tx;
		
	io: entity work.io_cu
		port map(clk_int, int_res,
		pins_in,
		pins_out,
		ioout,
		ioin);



	cpu : entity work.leros port map(clk_int, int_res, ioout, ioin);
	io  : entity work.io_cu port map(clk_int, pins_in, pins_out, ioout, ioin);
end rtl;
