library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rotary_encoder is
   port (
		clk : in std_logic;
		rotary_a_in : in  std_logic;
      rotary_b_in : in  std_logic;
      rotary_position : out  std_logic_vector (7 downto 0)
	);
end rotary_encoder;

architecture rtl of rotary_encoder is

	signal rotary_q1 : std_logic;
	signal rotary_q2 : std_logic;
	signal delay_rotary_q1 : std_logic;
	signal rotary_event : std_logic;
	signal rotary_left : std_logic;
	signal real_rotary_position : std_logic_vector (7 downto 0);

begin

rotary_position <= real_rotary_position;

rotary_filter : process(clk)
variable rotary_in : std_logic_vector(1 downto 0);
begin
	if rising_edge(clk) then
		rotary_in := rotary_b_in & rotary_a_in;
		
		case rotary_in is
			when "00" => rotary_q1 <= '0';
							 rotary_q2 <= rotary_q2;
			when "01" => rotary_q1 <= rotary_q1;
							 rotary_q2 <= '0';
			when "10" => rotary_q1 <= rotary_q1;
							 rotary_q2 <= '1';
			when "11" => rotary_q1 <= '1';
							 rotary_q2 <= rotary_q2;
							 
			when others => rotary_q1 <= rotary_q1;
							   rotary_q2 <= rotary_q2;
		end case;
	end if;
end process rotary_filter;

direction : process(clk)
begin
	if rising_edge(clk) then
		delay_rotary_q1 <= rotary_q1;
		if rotary_q1 = '1' and delay_rotary_q1 = '0' then
			rotary_event <= '1';
			rotary_left <= rotary_q2;
		else
			rotary_event <= '0';
			rotary_left <= rotary_left;
		end if;
	end if;
end process direction;

counter : process(clk)
begin
	if rising_edge(clk) then
		if rotary_event = '1' then
			if rotary_left = '1' then
				real_rotary_position <= std_logic_vector(unsigned(real_rotary_position) + 1);
			else
				real_rotary_position <= std_logic_vector(unsigned(real_rotary_position) - 1);
			end if;
		else
			real_rotary_position <= real_rotary_position;
		end if;
	end if;
end process counter;

end rtl;

