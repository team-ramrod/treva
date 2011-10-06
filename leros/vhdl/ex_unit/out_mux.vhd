library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

entity out_mux is
	port (
		jal  : in  std_logic;
		accu : in stream_unsigned;
		pc_dly : in std_logic_vector(IM_BITS-1 downto 0);
		
		wrdata : out stream_std 
	);
end out_mux;

architecture Behavioral of out_mux is

begin
	-- a MUX between 'normal' data and the PC for jal
process(jal, accu, pc_dly)
begin
	if jal='1' then
		for i in (stream-1) downto 0 loop
			wrdata(i)(IM_BITS-1 downto 0) <= pc_dly;
			wrdata(i)(15 downto IM_BITS) <= (others => '0');
		end loop;
	else
		for i in (stream-1) downto 0 loop
			wrdata(i) <= std_logic_vector(accu(i));
			end loop;
	end if;
end process;		
end Behavioral;

