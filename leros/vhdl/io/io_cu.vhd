library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;
use work.io_types.all;

entity io_cu is
	port (
		clk_int  : in  std_logic;
		pins_in  : in  io_pins_in_type;
		pins_out : out io_pins_out_type;
		cpu_out   : in  io_out_type;
		cpu_in    : out io_in_type
	);
end io_cu;

architecture rtl of io_cu is
begin

ua: entity work.uart generic map (
					 clk_freq => 100000000,
					 baud_rate => 115200,
					 txf_depth => 1,
					 rxf_depth => 1
				 )
port map(
		clk => clk_int,
		reset => int_res,

		address => ioout.addr(0),
		wr_data => ioout.wrdata,
		rd => ioout.rd,
		wr => ioout.wr,
		rd_data => ioin.rddata,

		txd	 => ser_txd,
		rxd	 => ser_rxd
	);

process(clk_int)
begin
	if rising_edge(clk_int) then
		cpu_in.rddata(0) <= (others => '0');
		case cpu_out.addr is
<<<<<<< HEAD
			when "00000001" => cpu_in.rddata(3 downto 0) <= pins_in.pbtn;
			when "00000010" => cpu_in.rddata(3 downto 0) <= pins_in.sbtn;
            when "00000011" => -- Read from uart
=======
			when "00000001" => cpu_in.rddata(0)(3 downto 0) <= pins_in.pbtn;
			when "00000010" => cpu_in.rddata(0)(3 downto 0) <= pins_in.sbtn;
>>>>>>> aa1c0d9848c6158687cb1599e5ca403b032a5890
			when others => null;
		end case;
	end if;
end process;

process(clk_int)
begin
	if rising_edge(clk_int) then if cpu_out.wr = '1' then
		case cpu_out.addr is
<<<<<<< HEAD
			when "00000001" => pins_out.leds <= cpu_out.wrdata(7 downto 0);
            when "00000010" => -- write uart
=======
			when "00000001" => pins_out.leds <= cpu_out.wrdata(0)(7 downto 0);
>>>>>>> aa1c0d9848c6158687cb1599e5ca403b032a5890
			when others => null;
		end case;
	end if; end if;
end process;

end rtl;
