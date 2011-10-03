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
    when "000000000" => q <= "0000000000000000";
    when "000000001" => q <= "0010000100000000";
    when "000000010" => q <= "0010100100000000";
    when "000000011" => q <= "0011000000000001";
    when "000000100" => q <= "0010100100000010";
    when "000000101" => q <= "0011000000000000";
    when "000000110" => q <= "0010100111111111";
    when "000000111" => q <= "0000110100000001";
    when "000001000" => q <= "0100101011111111";
    when "000001001" => q <= "0010000111111111";
    when "000001010" => q <= "0010000000000000";
    when "000001011" => q <= "0000110100000001";
    when "000001100" => q <= "0011000000000000";
    when "000001101" => q <= "0100101011111001";
    when "000001110" => q <= "0010000111111111";
    when "000001111" => q <= "0010000000000001";
    when "000010000" => q <= "0000100100000001";
    when "000010001" => q <= "0011100000000000";
    when "000010010" => q <= "0011000000000001";
    when "000010011" => q <= "0100100011110001";
    when "000010100" => q <= "0010000100000000";

    when others => q <= "0000000000000000";
end case;
end process;

end rtl;
