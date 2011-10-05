library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

entity leros_s3e_1600 is
port (
	clk     : in std_logic;
	led     : out std_logic_vector(7 downto 0);
	pbtn	: in std_logic_vector(3 downto 0);
	sbtn	: in std_logic_vector(3 downto 0)
);
end leros_s3e_1600;

architecture rtl of leros_s3e_1600 is


--
--	Signals
--
	signal clk_int			: std_logic;

	signal int_res			: std_logic;
	signal res_cnt			: unsigned(2 downto 0) := "000";	-- for the simulation

	attribute altera_attribute : string;
	attribute altera_attribute of res_cnt : signal is "POWER_UP_LEVEL=LOW";

	signal ioout : io_out_type;
	signal ioin : io_in_type;
	
	signal outp 			: std_logic_vector(15 downto 0);
	signal inp 			: std_logic_vector(15 downto 0);
	
begin

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

--	clk_int <= clk;
--
--	internal reset generation
--	should include the PLL lock signal
--

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

process(clk_int)
begin
	if rising_edge(clk_int) then
-- Input definitions
		case ioout.addr is
			when "00000001" =>
				inp <= "000000000000" & pbtn;
			when "00000010" =>
				inp <= "000000000000" & sbtn;
			when others =>
				null;
		end case;
		if ioout.rd='1' then
			ioin.rddata <= inp;
		end if;
	end if;
end process;
	
process(clk_int)
begin
	if rising_edge(clk_int) then
		if ioout.wr='1' then
			outp <= ioout.wrdata;
			-- Output definitions
			case ioout.addr is
				when "00000001" =>
					led <= outp(7 downto 0);
				when others =>
					null;
			end case;
		end if;
	end if;
end process;


end rtl;
