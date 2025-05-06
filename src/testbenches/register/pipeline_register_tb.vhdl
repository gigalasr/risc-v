-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.constant_package.ALL;

entity pipeline_register_tb is
end pipeline_register_tb;

architecture behaviour of pipeline_register_tb is
  signal s_in_clk, s_in_rst    : std_logic := '0';
  signal s_in_data, s_out_data : std_logic_vector(31 DOWNTO 0) := (others => '0');

  signal s_expect : std_logic_vector(31 DOWNTO 0) := (others => '0');

  type int_array_t is array (0 to 4) of integer; 
  constant SIZES : int_array_t := (5,6,8,16,32); 
begin
    GEN: for i in 0 to 4 generate 
        my_inst: entity work.pipeline_register generic map (data_width => SIZES(i)) 
            port map (pi_clk => s_in_clk, 
                      pi_rst => s_in_rst, 
                      pi_data => s_in_data(SIZES(i) - 1 downto 0), 
                      po_data => s_out_data(SIZES(i) - 1 downto 0));   
        process begin
            report "Gen(" & INTEGER'image(SIZES(i)) & ")";
            s_expect <= (others => '0');
            s_in_rst <= '1';
            s_in_clk <= '1';
            wait for 1 ns;
            assert s_out_data(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): bad init state" severity error; 

            s_expect <= (others => '0');
            s_in_data <= (others => '1');
            s_in_rst <= '0';
            s_in_clk <= '0';
            wait for 1 ns;
            assert s_out_data(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): should be 0 before clock" severity error; 

            s_expect <= (others => '1');
            s_in_data <= (others => '1');
            s_in_rst <= '0';
            s_in_clk <= '1';
            wait for 1 ns;
            assert s_out_data(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): should be 1 before clock" severity error; 
            wait;

            s_expect <= (others => '1');
            s_in_data <= (others => '0');
            s_in_rst <= '0';
            s_in_clk <= '0';
            wait for 1 ns;
            assert s_out_data(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): should be 1 after clock" severity error; 
            wait;
        end process;
        assert false report "end of test" severity note;
    end generate; 
end behaviour;