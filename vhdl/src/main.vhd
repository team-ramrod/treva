library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;

entity main is
    port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end main;

architecture main_arch of main is
    component cpu is
        port(
            -- instruction bus
            inst_add  : out   std_logic_vector(15 downto 0); -- Address lines.
            inst_data : in    std_logic_vector(15 downto 0); -- Data lines.
            inst_req  : out   std_logic;                     -- Pulled low to request bus usage.
            inst_ack  : in    std_logic;                     -- Pulled high to inform of request completion.
            -- data bus
            data_add  : out   std_logic_vector(15 downto 0); -- Address lines.
            data_line : inout std_logic_vector(15 downto 0); -- Data lines.
            data_read : out   std_logic;                     -- High for a read request, low for a write request.
            data_req  : out   std_logic;                     -- Pulled low to request bus usage.
            data_ack  : inout std_logic;                     -- Pulled high to inform of request completion.
            -- extras
            clk       : in  std_logic;
            reset     : in  std_logic
        );
    end component;

    component mmu is
        port (
            -- instruction bus
            inst_add  : in    std_logic_vector(15 downto 0); -- Address lines.
            inst_data : out   std_logic_vector(15 downto 0); -- Data lines.
            inst_req  : in    std_logic;                     -- Pulled low to request bus usage.
            inst_ack  : out   std_logic;                     -- Pulled high to inform of request completion.
            -- data bus
            data_add  : in    std_logic_vector(15 downto 0); -- Address lines.
            data_line : inout std_logic_vector(15 downto 0); -- Data lines.
            data_read : in    std_logic;                     -- High for a read request, low for a write request.
            data_req  : in    std_logic;                     -- Pulled low to request bus usage.
            data_ack  : inout std_logic;                     -- Pulled high to inform of request completion.
            -- extras
            clk       : in    std_logic
        );
    end component;

    component io is
        port(
            -- data bus
            data_add  : in    std_logic_vector(15 DOWNTO 0); -- Address lines.
            data_line : inout std_logic_vector(15 DOWNTO 0);  -- Data lines.
            data_read : in    std_logic;                     -- Pulled high for read, low for write.
            data_req  : in    std_logic;                     -- Pulled low to request bus usage.
            data_ack  : inout std_logic;                     -- Pulled high to inform request completion.
            -- extras
            clk       : in    std_logic
        );
    end component;

    -- instruction bus
    signal inst_add  : std_logic_vector(15 downto 0); -- Address lines.
    signal inst_data : std_logic_vector(15 downto 0); -- Data lines.
    signal inst_req  : std_logic;                     -- Pulled low to request bus usage.
    signal inst_ack  : std_logic;                     -- Pulled high to inform of request completion.
    -- data bus
    signal data_add  : std_logic_vector(15 downto 0); -- Address lines.
    signal data_line : std_logic_vector(15 downto 0); -- Data lines.
    signal data_read : std_logic;                     -- High for a read request, low for a write request.
    signal data_req  : std_logic;                     -- Pulled low to request bus usage.
    signal data_ack  : std_logic;                     -- Pulled high to inform of request completion.

begin
    c : cpu port map(
        inst_add  => inst_add,  inst_data => inst_data,
        inst_req  => inst_req,  inst_ack  => inst_ack,
        data_add  => data_add,  data_line => data_line,
        data_read => data_read, data_req  => data_req,
        data_ack  => data_ack,  clk       => clk,
        reset     => reset
    );

    m : mmu port map(
        inst_add  => inst_add,  inst_data => inst_data,
        inst_req  => inst_req,  inst_ack  => inst_ack,
        data_add  => data_add,  data_line => data_line,
        data_read => data_read, data_req  => data_req,
        data_ack  => data_ack,  clk       => clk
    );

    i : io  port map(
        data_add  => data_add,  data_data => data_line,
        data_read => data_read, data_req  => data_req,
        data_ack  => data_ack,  clk       => clk
    );
end architecture main_arch;
