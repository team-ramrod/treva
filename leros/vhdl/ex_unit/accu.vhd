library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

entity accu is
port (
		clk  : in  std_logic;
		reset : in std_logic;
		low_en : in std_logic; 
		high_en : in std_logic;
		pc : in std_logic_vector(IM_BITS-1 downto 0);
		dm_addr : in std_logic_vector(DM_BITS-1 downto 0);
		a_mux : in stream_unsigned;
		
		pc_dly : out std_logic_vector(IM_BITS-1 downto 0);
		wraddr_dly : out std_logic_vector(DM_BITS-1 downto 0);
		accu : out stream_unsigned
	);
end accu;

architecture Behavioral of accu is

begin
	process(clk, reset)
	begin
		if reset='1' then
			for i in 0 to (stream-1) loop
				accu(i) <= (others => '0');
			end loop;
		elsif rising_edge(clk) then
			if low_en = '1' then
				for i in 0 to (stream-1) loop
					accu(i)(7 downto 0) <= a_mux(i)(7 downto 0);
				end loop;
			end if;
			if high_en = '1' then
				for i in 0 to (stream-1) loop
					accu(i)(15 downto 8) <= a_mux(i)(15 downto 8);
				end loop;
			end if;
			wraddr_dly <= dm_addr;
			pc_dly <= pc;
		end if;
	end process;
end Behavioral;

