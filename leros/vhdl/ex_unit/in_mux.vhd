library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

entity in_mux is
	port (
		sel_imm  : in  std_logic;
		imm : in std_logic_vector(15 downto 0);
		rddata : in stream_std;
		
		opd  : out stream_unsigned
	);
end in_mux;

architecture Behavioral of in_mux is

begin
process(sel_imm, imm, rddata)
begin
	if sel_imm='1' then
		for i in (stream-1) downto 0 loop
			opd(i) <= unsigned(imm);
		end loop;
	else
		-- a MUX for IO will be added
		for i in (stream-1) downto 0 loop
			opd(i) <= unsigned(rddata(i));
		end loop;
	end if;
end process;
end Behavioral;

