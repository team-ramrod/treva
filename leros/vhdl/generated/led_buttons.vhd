--
--	leros_rom.vhd
--
--	generic VHDL version of ROM
--
--		DONT edit this file!
--		generated by vhdliser
--

library ieee;
use ieee.std_logic_1164.all;

entity leros_rom is
port (
    address : in std_logic_vector(8 downto 0);
    q : out std_logic_vector(15 downto 0)
);
end leros_rom;

architecture rtl of leros_rom is

begin

process(address) begin

case address is
    when "000000000" => q <= "0000000000000000";
    when "000000001" => q <= "0011110000000001";
    when "000000010" => q <= "0011100000000001";
    when "000000011" => q <= "0000000000000000";
    when "000000100" => q <= "0100100011111101";
    when others => q <= "0000000000000000";
end case;
end process;

end rtl;
