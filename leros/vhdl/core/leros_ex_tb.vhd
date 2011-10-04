----------------------------------------------------------------
-- Test Bench for ALU
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity leros_ex_TB is                -- entity declaration
end leros_ex_TB;

architecture TB of dff_TB is
        
    component leros_ex
    port(       
                clk : in std_logic;
                reset : in std_logic;
                din : in fedec_out_type;
                ioin : in io_in_type; 
                dout : out ex_out_type
    );
    end component;
    
    --signal op : std_logic_vector(1 downto 0); -- add, lsh, or etc
    --signal accu, opd  : unsigned(15 downto 0);
    --signal logic, arith, shift, a_mux : unsigned (15 downto 0);
    --signal op_class : op_class_type;
    
    signal T_clk : std_logic;
    signal T_reset : std_logic;
    signal T_din : fedec_out_type;
    signal T_ioin : io_in_type;
    signal T_dout : ex_out_type;
    
   
begin

    __LEROS_EX: leros_ex port map (T_clk, T_reset, T_din, T_ioin, T_dout);
    
    T_reset <= '0';
    
    -- concurrent process to offer clock signal     
    process
    begin
        T_clk <= '0';
        wait for 5 ns;
        T_clk <= '1';
        wait for 5 ns;
    end process;
    
    process
        variable err_cnt: integer := 0; 
    begin
                
        -- case 1
        --T_din.dec.op <= "00"; -- load
        T_din.dec.op_class <= io_flag;
        T_ioin <= "0000000000000000";
        wait for 10 ns;
        assert (T_dout.accu = "0000000000000000") report "Error" severity error;
        if (T_dout.accu /= "0000000000000000") then
            err_cnt := err_cnt + 1;
        end if;
        
    end process;

end TB;
