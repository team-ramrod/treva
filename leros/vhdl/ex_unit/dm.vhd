library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

entity dm is
	port (
		clk  : in  std_logic;
		store : in std_logic;
		wrdata : in stream_std; 
		wraddr : in std_logic_vector(DM_BITS-1 downto 0);
		rdaddr :in std_logic_vector(DM_BITS-1 downto 0);
		rddata : out stream_std
	);
end dm;

architecture Behavioral of dm is

	-- the data ram
	constant nwords : integer := 2 ** DM_BITS;
	type ram_type is array(0 to nwords-1) of std_logic_vector(15 downto 0);
	type ram_array_type is array(0 to stream-1) of ram_type;

	-- 0 initialization is for simulation only
	-- Xilinx and Altera FPGA initialize memory blocks to 0
	signal dm : ram_array_type := (others => (others => (others => '0')));
	
begin
process (clk)
begin
	if rising_edge(clk) then
		-- is store overloaded?
		-- now we have only 'register' read and write
		if store='1' then
		for i in (stream-1) downto 0 loop
			dm(i)(to_integer(unsigned(wraddr))) <= wrdata(i);
		end loop;
		end if;
		for i in (stream-1) downto 0 loop
			rddata(i) <= dm(i)(to_integer(unsigned(rdaddr)));
		end loop;
		
	end if;
end process;
end Behavioral;

