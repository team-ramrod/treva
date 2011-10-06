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
    when "000000011" => q <= "0011000000000101";
    when "000000100" => q <= "0010000100000000";
    when "000000101" => q <= "0010100100000000";
    when "000000110" => q <= "0011000000000110";
    when "000000111" => q <= "0010000101001100";
    when "000001000" => q <= "0010100100000000";
    when "000001001" => q <= "0000000000000000";
    when "000001010" => q <= "0100000000000001";
    when "000001011" => q <= "0000000000000000";
    when "000001100" => q <= "0010000000000000";
    when "000001101" => q <= "0011000000000010";
    when "000001110" => q <= "0010000101001100";
    when "000001111" => q <= "0010100100000000";
    when "000010000" => q <= "0000000000000000";
    when "000010001" => q <= "0100000000000001";
    when "000010010" => q <= "0000000000000000";
    when "000010011" => q <= "0010000000000000";
    when "000010100" => q <= "0011000000000011";
    when "000010101" => q <= "0000110000000010";
    when "000010110" => q <= "0010000000000111";
    when "000010111" => q <= "0011000000000100";
    when "000011000" => q <= "0010000101001100";
    when "000011001" => q <= "0010100100000000";
    when "000011010" => q <= "0000000000000000";
    when "000011011" => q <= "0100000000000001";
    when "000011100" => q <= "0000000000000000";
    when "000011101" => q <= "0010000000000000";
    when "000011110" => q <= "0101000000000101";
    when "000011111" => q <= "0111000000010100";
    when "000100000" => q <= "0000100100000001";
    when "000100001" => q <= "0011000000000101";
    when "000100010" => q <= "0010000000000100";
    when "000100011" => q <= "0000101100000001";
    when "000100100" => q <= "0000000000000000";
    when "000100101" => q <= "0100101011110011";
    when "000100110" => q <= "0010000000000110";
    when "000100111" => q <= "0000100100000001";
    when "000101000" => q <= "0011000000000110";
    when "000101001" => q <= "0000101100000010";
    when "000101010" => q <= "0000000000000000";
    when "000101011" => q <= "0100100100001011";
    when "000101100" => q <= "0000000000000000";
    when "000101101" => q <= "0000000000000000";
    when "000101110" => q <= "0010000100000111";
    when "000101111" => q <= "0010100100000000";
    when "000110000" => q <= "0000000000000000";
    when "000110001" => q <= "0100000000000001";
    when "000110010" => q <= "0000000000000000";
    when "000110011" => q <= "0010000100000000";
    when "000110100" => q <= "0010100100000000";
    when "000110101" => q <= "0011000000000101";
    when "000110110" => q <= "0101000000000101";
    when "000110111" => q <= "0110000000010100";
    when "000111000" => q <= "0011000000001000";
    when "000111001" => q <= "0010000000000101";
    when "000111010" => q <= "0000100000000111";
    when "000111011" => q <= "0011000000001010";
    when "000111100" => q <= "0101000000001010";
    when "000111101" => q <= "0110000000010100";
    when "000111110" => q <= "0000100000001000";
    when "000111111" => q <= "0001001000000000";
    when "001000000" => q <= "0011000000001001";
    when "001000001" => q <= "0010000000000101";
    when "001000010" => q <= "0000100000000111";
    when "001000011" => q <= "0000100000000111";
    when "001000100" => q <= "0011000000001011";
    when "001000101" => q <= "0101000000001011";
    when "001000110" => q <= "0111000000010100";
    when "001000111" => q <= "0010000000000101";
    when "001001000" => q <= "0000100100000001";
    when "001001001" => q <= "0011000000000101";
    when "001001010" => q <= "0010000000000101";
    when "001001011" => q <= "0000101100000001";
    when "001001100" => q <= "0000101000000111";
    when "001001101" => q <= "0000000000000000";
    when "001001110" => q <= "0100101011101011";
    when "001001111" => q <= "0000000000000000";
    when "001010000" => q <= "0011110000000010";
    when "001010001" => q <= "0010001100000010";
    when "001010010" => q <= "0000000000000000";
    when "001010011" => q <= "0100100111111101";
    when "001010100" => q <= "0011110000000011";
    when "001010101" => q <= "0011000000000000";
    when "001010110" => q <= "0010000000000001";
    when "001010111" => q <= "0000000000000000";
    when "001011000" => q <= "0100000000000001";
    when others => q <= "0000000000000000";
end case;
end process;

end rtl;
