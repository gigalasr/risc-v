-- Laboratory GdTi solutions/versuch5
-- Winter Semester 24/25
-- Group Details
-- Lab Date:
-- 1. Participant First and  Last Name: 
-- 2. Participant First and Last Name:
 
 
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constant_package.ALL;

entity gates_tb is
end gates_tb;

architecture behavior of gates_tb is
    signal s_in1, s_in2 : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_result_and, s_result_or, s_result_xor : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_result_expected : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    constant c_period : time := 10 ns;

    begin 
        AND_UNIT: entity work.gen_and generic map (G_DATA_WIDTH => DATA_WIDTH_GEN) port map (s_in1, s_in2, s_result_and);
        OR_UNIT: entity work.gen_or generic map (G_DATA_WIDTH => DATA_WIDTH_GEN) port map (s_in1, s_in2, s_result_or);
        XOR_UNIT: entity work.gen_xor generic map (G_DATA_WIDTH => DATA_WIDTH_GEN) port map (s_in1, s_in2, s_result_xor);

    process 
    begin 

        s_in1 <= std_logic_vector(to_unsigned(8, DATA_WIDTH_GEN));
        s_in2 <= std_logic_vector(to_unsigned(4, DATA_WIDTH_GEN));

        wait for c_period/2;

        -- AND 
        s_result_expected <= s_in1 and s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_and) report "Had error in AND-Function " severity error;
        
        -- OR 
        s_result_expected <= s_in1 or s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_or) report "Had error in OR-Function " severity error;

        -- XOR 
        s_result_expected <= s_in1 xor s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_xor) report "Had error in XOR-Function " severity error;
    
        wait for c_period/2;
        
        s_in1 <= std_logic_vector(to_unsigned(0, DATA_WIDTH_GEN));
        s_in2 <= std_logic_vector(to_unsigned(0, DATA_WIDTH_GEN));

        wait for c_period/2;

        -- AND 
        s_result_expected <= s_in1 and s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_and) report "Had error in AND-Function " severity error;
        
        -- OR 
        s_result_expected <= s_in1 or s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_or) report "Had error in OR-Function " severity error;

        -- XOR 
        s_result_expected <= s_in1 xor s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_xor) report "Had error in XOR-Function " severity error;
    
        wait for c_period/2;
         
        s_in1 <= std_logic_vector(to_unsigned(2**DATA_WIDTH_GEN-1, DATA_WIDTH_GEN));
        s_in2 <= std_logic_vector(to_unsigned(0, DATA_WIDTH_GEN));

        wait for c_period/2;

        -- AND 
        s_result_expected <= s_in1 and s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_and) report "Had error in AND-Function " severity error;
        
        -- OR 
        s_result_expected <= s_in1 or s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_or) report "Had error in OR-Function " severity error;

        -- XOR 
        s_result_expected <= s_in1 xor s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_xor) report "Had error in XOR-Function " severity error;
    
        wait for c_period/2;
    
        s_in1 <= std_logic_vector(to_unsigned(0, DATA_WIDTH_GEN));
        s_in2 <= std_logic_vector(to_unsigned(2**DATA_WIDTH_GEN-1, DATA_WIDTH_GEN));

        wait for c_period/2;

        -- AND 
        s_result_expected <= s_in1 and s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_and) report "Had error in AND-Function " severity error;
        
        -- OR 
        s_result_expected <= s_in1 or s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_or) report "Had error in OR-Function " severity error;

        -- XOR 
        s_result_expected <= s_in1 xor s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_xor) report "Had error in XOR-Function " severity error;
    
        wait for c_period/2;

        s_in1 <= std_logic_vector(to_unsigned(2**DATA_WIDTH_GEN-1, DATA_WIDTH_GEN));
        s_in2 <= std_logic_vector(to_unsigned(2**DATA_WIDTH_GEN-1, DATA_WIDTH_GEN));

        wait for c_period/2;

        -- AND 
        s_result_expected <= s_in1 and s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_and) report "Had error in AND-Function " severity error;
        
        -- OR 
        s_result_expected <= s_in1 or s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_or) report "Had error in OR-Function " severity error;

        -- XOR 
        s_result_expected <= s_in1 xor s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_xor) report "Had error in XOR-Function " severity error;
    
        wait for c_period/2;

        s_in1 <= std_logic_vector(to_unsigned(15, DATA_WIDTH_GEN));
        s_in2 <= std_logic_vector(to_unsigned(11, DATA_WIDTH_GEN));

        wait for c_period/2;

        -- AND 
        s_result_expected <= s_in1 and s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_and) report "Had error in AND-Function " severity error;
        
        -- OR 
        s_result_expected <= s_in1 or s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_or) report "Had error in OR-Function " severity error;

        -- XOR 
        s_result_expected <= s_in1 xor s_in2;  
        wait for c_period/2; -- Wait for one clock cycle
        assert(s_result_expected = s_result_xor) report "Had error in XOR-Function " severity error;
    
        wait for c_period/2;
        
        assert false report "end of test" severity note;
        wait; 

    end process;

end architecture behavior;