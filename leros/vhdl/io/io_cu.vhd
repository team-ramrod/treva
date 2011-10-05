library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;
use work.io_types.all;

entity io_cu is
	port (
		clk_int  : in  std_logic;
		int_res  : in  std_logic;
		pins_in  : in  io_pins_in_type;
		pins_out : out io_pins_out_type;
		cpu_out   : in  io_out_type;
		cpu_in    : out io_in_type
	);
end io_cu;

architecture rtl of io_cu is
	signal uart_addr : std_logic;
	signal uart_rd   : std_logic;
	signal uart_wr   : std_logic;
	signal uart_data_in : std_logic_vector(7 downto 0);
	signal uart_data_out : std_logic_vector(7 downto 0);
	signal data : std_logic_vector(15 downto 0);
	signal wr_dly : std_logic;

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

		address => uart_addr,
		wr_data => uart_data_out, 
		rd => uart_rd,
		wr => uart_wr,
		rd_data => uart_data_in,

		txd	 => pins_out.uart_tx,
		rxd	 => pins_in.uart_rx
	);

with cpu_out.addr select
	uart_addr <= '1' when "00000100",
		     '0' when others;

process(clk_int)
begin
	if rising_edge(clk_int) then
		uart_rd <= '0';
		cpu_in.rddata <= (others => '0');
		case cpu_out.addr is
			when "00000001" => cpu_in.rddata(3 downto 0) <= pins_in.pbtn;
			when "00000010" => cpu_in.rddata(3 downto 0) <= pins_in.sbtn;
			when "00000011" => cpu_in.rddata(7 downto 0) <= uart_data_in;
			when "00000100" => uart_rd <= '1'; cpu_in.rddata(7 downto 0) <= uart_data_in;
			when others => null;
		end case;
	end if;
end process;

process(clk_int)
begin
	if rising_edge(clk_int) then
		uart_wr <= '0';
		if wr_dly = '1' then
			case cpu_out.addr is
				when "00000001" => pins_out.leds <= data(7 downto 0);
				when "00000010" => uart_wr <= '1'; uart_data_out <= data(7 downto 0);
				when others => null;
			end case;
			wr_dly <= '0';
		end if;
		if cpu_out.wr = '1' then
			data <= cpu_out.wrdata;
			wr_dly <= '1';
		end if;
	end if;
end process;

end rtl;
