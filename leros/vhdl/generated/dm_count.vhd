--
--	leros_rom.vhd
--
--	generic VHDL version of ROM
--
--		DONT edit this file!
--		generated by leros.asm.LerosAsm
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
    when others => q <= "0000000000000000";
end case;
end process;

end rtl;
