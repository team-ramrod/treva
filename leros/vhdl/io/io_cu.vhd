library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;
use work.io_types.all;

entity io_cu is
	port (
		clk_int  : in  std_logic;
		pins_in  : in  io_pins_in_type;
		pins_out : out io_pins_out_type;
		cpuout   : in  io_out_type;
		cpuin    : out io_in_type
	);
end io_cu;

architecture rtl of io_cu is
begin

process(clk_int)
begin
	if rising_edge(clk_int) then
		with ioout.addr select
		cpuin.rddata <= pbtn when "00000001",
		                sbtn when "00000010",
		                (others => '0') when others;
	end if;
end process;

process(clk_int)
begin
	if rising_edge(clk_int) then if cpu_out.wr = '1' then
		case cpu_out.addr is
		when "00000001" => led <= outp(7 downto 0);
		when others => null;
		end case;
	end if; end if;
end process;

end rtl;
