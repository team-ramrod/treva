-- Authors:
--    Wim Looman

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flipflop_tb is
end d_flipflop_tb;

architecture behav of d_flipflop_tb is
  component d_flipflop
    Port(
      D   : in  STD_LOGIC;
      Q   : out STD_LOGIC;
      clk : in  STD_LOGIC;
      rst : in  STD_LOGIC
    );
  end component;

  for d_flipflop_0: d_flipflop use entity work.d_flipflop;

  signal D, Q, clk, rst : STD_LOGIC;

begin

  d_flipflop_0: d_flipflop port map (D => D, Q => Q, clk => clk, rst => rst);

  process
  begin
    -- Check initialisation state.
    D   <= '0';
    clk <= '0';
    rst <= '0'; wait for 1 ns;
    rst <= '1'; wait for 1 ns;

    assert Q = '0' report "Initialisation check failed" severity error;

    -- Check doesn't change after one clock cycle.
    clk <= '1'; wait for 1 ns;
    clk <= '0'; wait for 1 ns;

    assert Q = '0' report "Set without input" severity error;

    -- Check that doesn't set without edge.
    D   <= '1'; wait for 1 ns;

    assert Q = '0' report "Set without clock edge" severity error;

    -- Check that can be set.
    clk <= '1'; wait for 1 ns;
    clk <= '0'; wait for 1 ns;

    assert Q = '1' report "Didn't set" severity error;

    -- Check that keeps high value.
    clk <= '1'; wait for 1 ns;
    clk <= '0'; wait for 1 ns;

    assert Q = '1' report "Cleared without input" severity error;

    -- Check that doesn't clear without edge.
    D   <= '0'; wait for 1 ns;

    assert Q = '1' report "Cleared without clock edge" severity error;

    D <= '1'; wait for 1 ns;

    clk <= '1'; wait for 1 ns;

    D <= '0'; wait for 1 ns;

    assert Q = '1' report "Cleared without clock edge" severity error;

    clk <= '0'; wait for 1 ns;

    assert Q = '1' report "Cleared on negative clock edge" severity error;

    -- Check that can be cleared;
    clk <= '1'; wait for 1 ns;
    clk <= '0'; wait for 1 ns;

    assert Q = '0' report "Didn't clear" severity error;

    assert false report "End of test" severity note;
    wait;
  end process;
end behav;
