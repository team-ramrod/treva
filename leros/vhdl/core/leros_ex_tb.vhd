----------------------------------------------------------------
-- Test Bench for ALU
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.leros_types.all;

entity leros_ex_TB is                -- entity declaration
end leros_ex_TB;

architecture TB of leros_ex_TB is
        
    component leros_ex
    port(       
                clk : in std_logic;
                reset : in std_logic;
                din : in fedec_out_type;
                ioin : in io_in_type; 
                dout : out ex_out_type
    );
    end component;
    
--     signal op : std_logic_vector(1 downto 0); -- add, lsh, or etc
--     signal accu, opd  : unsigned(15 downto 0);
--     signal logic, arith, shift, a_mux : unsigned (15 downto 0);
--     signal op_class : op_class_type;
    
    signal T_clk : std_logic;
    signal T_reset : std_logic;
    signal T_din : fedec_out_type;
    signal T_ioin : io_in_type;
    signal T_dout : ex_out_type;

    
   
begin
    
    TB_LEROS_EX: leros_ex port map (T_clk, T_reset, T_din, T_ioin, T_dout);
    
--     -- concurrent process to offer clock signal     
--     process
--     begin
--         T_clk <= '0';
--         wait for 5 ns;
--         T_clk <= '1';
--         wait for 5 ns;
--         wait;
--     end process;

--     process
--     begin
--       for i in 1 to 10 loop -- then wait for a few clock periods...
--     wait until rising_edge(CLK);
--   end loop;
--     end process;

    -- Simulate the clock
    process
    begin
        -- 60 => 120 ns
        for i in 60 downto 0 loop
            T_clk <= '1';
            wait for 1 ns;
            T_clk <= '0';
            wait for 1 ns;
        end loop;
        wait;
    end process;

    process
        variable err_cnt: integer := 0; 
    begin
               
        T_reset <= '0';
        T_din.dec.al_ena <= '1';
        T_din.dec.ah_ena <= '1';
        T_din.dec.sel_imm <= '0'; -- don't have a clue what this does

        -- Let the clock spin for a bit.
        wait for 5 ns;

        -- case 1, load 42 into the accumulator

        T_ioin.rddata <= "0000000000101010";
        wait for 2 ns;

        T_din.dec.op_class <= io_flag;
        wait for 2 ns;
        
        T_din.dec.al_ena <= '0';
        T_din.dec.ah_ena <= '0';
        wait for 2 ns;

        assert (T_dout.accu = "0000000000101010") report "Weasel Error" severity error;
        wait for 8 ns;
        if (T_dout.accu /= "0000000000101010") then
            err_cnt := err_cnt + 1;
        end if;
    
        -- case 2
            
        T_din.dec.op_class <= arith_flag;
         T_din.dec.op <= "00"; -- add
        wait for 5 ns;
-- 
        T_ioin.rddata <= "0000000000000001";
        wait for 10 ns;
        -- opd should now be 1;

        -- update the accumulator
        T_din.dec.al_ena <= '1';
        T_din.dec.ah_ena <= '1';
        wait for 1 ns;
        T_din.dec.al_ena <= '0';
        T_din.dec.ah_ena <= '0';
                
        wait for 2 ns;

        assert (T_dout.accu = "0000000000101011") report "Weasel Error" severity error;
        wait for 8 ns;
        if (T_dout.accu /= "0000000000101011") then
            err_cnt := err_cnt + 1;
        end if;

        wait for 10 ns;

        -- case 3
        


        wait;

    end process;

end TB;
