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
	signal rotary_position : std_logic_vector(7 downto 0);
	
	signal input_select  : io_input_select_type;
	signal output_select : io_output_select_type;

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
	
re : entity work.rotary_encoder port map(clk_int, pins_in.rotary_a, pins_in.rotary_b, rotary_position);

with cpu_out.addr(3 downto 0) select
	input_select <= pbtn_select         when "0001",
	                sbtn_select         when "0010",
						 uart_control_select when "0011",
						 uart_data_select    when "0100",
						 rotary_select       when "0101",
						 null_select         when others;
						 
with input_select select
	uart_addr <= '0' when uart_control_select,
					 '1' when others;

process(input_select, cpu_out.rd)
begin
	if input_select = uart_data_select and cpu_out.rd = '1' then
		uart_rd <= '1';
	else
		uart_rd <= '0';
	end if;
end process;

data_in_select : process(input_select)
begin
	cpu_in.rddata <= (others => '0');
	case input_select is
		when pbtn_select =>
			cpu_in.rddata(3 downto 0) <= pins_in.pbtn;
		when sbtn_select =>
			cpu_in.rddata(3 downto 0) <= pins_in.sbtn;
		when uart_control_select =>
			cpu_in.rddata(7 downto 0) <= uart_data_in;
		when uart_data_select =>
			cpu_in.rddata(7 downto 0) <= uart_data_in;
		when rotary_select =>
			cpu_in.rddata(7 downto 0) <= rotary_position;
		when null_select =>
			null;
	end case;
end process;

with cpu_out.addr(3 downto 0) select
	output_select <= led_select       when "0001",
	                 uart_data_select when "0100",
						  null_select      when others;

process(output_select, wr_dly)
begin
	if output_select = uart_data_select and wr_dly = '1' then
		uart_wr <= '1';
	else
		uart_wr <= '0';
	end if;
end process;
						  
data_out_select : process(clk_int)
begin
	if rising_edge(clk_int) then
		if wr_dly = '1' then
			case output_select is
				when led_select =>
					pins_out.leds <= data(7 downto 0);
				when uart_data_select =>
					uart_data_out <= data(7 downto 0);
				when null_select =>
					null;
			end case;
		end if;
		
		wr_dly <= '0';
		if cpu_out.wr = '1' then
			data <= cpu_out.wrdata;
			wr_dly <= '1';
		end if;
	end if;
end process;

end rtl;
