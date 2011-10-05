library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

entity out_mux is
port (
		clk  : in  std_logic;
		reset : in std_logic;
		low_en : in std_logic; 
		high_en : in std_logic;
		pc : in std_logic_vector(IM_BITS-1 downto 0);
		dm_addr : in std_logic_vector(DM_BITS-1 downto 0);
		
		pc_dly : out std_logic_vector(IM_BITS-1 downto 0);
		wraddr_dly : out std_logic_vector(DM_BITS-1 downto 0);
	);
end out_mux;

architecture Behavioral of out_mux is

begin


end Behavioral;

