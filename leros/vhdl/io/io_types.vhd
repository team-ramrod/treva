library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package io_types is

type io_pins_in_type is record
	sbtn : std_logic_vector(3 downto 0);
	pbtn : std_logic_vector(3 downto 0);
	rotary_a : std_logic;
	rotary_b : std_logic;
	uart_rx : std_logic;
end record;

type io_pins_out_type is record
	leds : std_logic_vector(7 downto 0);
	uart_tx : std_logic;
end record;

type io_input_select_type is (pbtn_select, sbtn_select, uart_data_select, uart_control_select, rotary_select, null_select);
type io_output_select_type is (led_select, uart_data_select, null_select);

end io_types;
