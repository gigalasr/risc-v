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

entity gen_mux_tb is
end gen_mux_tb;

architecture behaviour of gen_mux_tb is
  signal s_in_sel                      : std_logic := '0';
  signal s_in_fst, s_in_snd, s_out_res : std_logic_vector(31 DOWNTO 0) := (others => '0');

  signal s_expect : std_logic_vector(31 DOWNTO 0) := (others => '0');

  type int_array_t is array (0 to 4) of integer; 
  constant SIZES : int_array_t := (5,6,8,16,32); 
begin
    GEN: for i in 0 to 4 generate 
        my_inst: entity work.gen_mux generic map (data_width => SIZES(i)) 
            port map (pi_sel =>  s_in_sel, 
                      pi_fst =>  s_in_fst(SIZES(i) - 1 downto 0), 
                      pi_snd =>  s_in_snd(SIZES(i) - 1 downto 0), 
                      po_res =>  s_out_res(SIZES(i) - 1 downto 0));   
        process begin
            report "Gen(" & INTEGER'image(SIZES(i)) & ")";
            s_expect <= (others => '1');
            s_in_fst <= (others => '1');
            s_in_snd <= (others => '0');
            s_in_sel <= '0';

            wait for 1 ns;
            assert s_out_res(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): bad init state" severity failure; 

            s_expect <= (others => '0');
            s_in_fst <= (others => '1');
            s_in_snd <= (others => '0');
            s_in_sel <= '1';

            wait for 1 ns;
            assert s_out_res(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): bad init state" severity failure; 


            s_expect <= (others => '0');
            s_in_fst <= (others => '0');
            s_in_snd <= (others => '1');
            s_in_sel <= '0';

            wait for 1 ns;
            assert s_out_res(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): bad init state" severity failure; 


            s_expect <= (others => '1');
            s_in_fst <= (others => '0');
            s_in_snd <= (others => '1');
            s_in_sel <= '1';

            wait for 1 ns;
            assert s_out_res(SIZES(i) - 1 downto 0) = s_expect(SIZES(i) - 1 downto 0) report "Gen(" & INTEGER'image(SIZES(i)) & "): bad init state" severity failure; 



            wait;
        end process;
        assert false report "end of test" severity note;
    end generate; 
end behaviour;