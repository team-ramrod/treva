-- Authors:
--      Wim Looman

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flipflop is
  Port(
    D   : in  STD_LOGIC;
    Q   : out STD_LOGIC;
    clk : in  STD_LOGIC;
    rst : in  STD_LOGIC
  );
end d_flipflop;

architecture arch_d_flipflop of d_flipflop is
begin
	process(clk,rst)
	begin
		if rst = '0' then
			Q <= '0';
		elsif rising_edge(clk) then
			Q <= D;
		end if;
	end process;
end arch_d_flipflop;
