library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Hold device in reset for 7 clock cycles at startup
entity reset_generator is
port (
	clk     : in std_logic;
	reset   : out std_logic
);
end reset_generator;

architecture rtl of reset_generator is
	signal res_cnt			: unsigned(2 downto 0) := "000";
begin
	with res_cnt select reset <= '1' when "111",
	                             '0' when others;

	process(clk)
	begin
		if rising_edge(clk) then
			if (res_cnt/="111") then
				res_cnt <= res_cnt+1;
			end if;
		end if;
	end process;

end rtl;
