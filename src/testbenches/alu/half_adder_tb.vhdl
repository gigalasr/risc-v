-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library ieee;
use ieee.std_logic_1164.all;

entity my_half_adder_tb is
end my_half_adder_tb;

architecture behaviour of my_half_adder_tb is
  signal s_inA,s_inB,s_sum,s_carry : std_logic;
begin
  half_adder_0: entity work.half_adder(dataflow) port map (pi_a=>s_inA, pi_b=>s_inB, po_sum=>s_sum, po_carry=>s_carry);

  process begin
    s_inA <= '0'; s_inB <= '0'; wait for 1 fs;
    assert (s_sum='0') and (s_carry='0') report "bad result for input 0 0" severity error;
    wait for 1 fs;

    s_inA <= '1'; s_inB <= '0'; wait for 1 fs;
    assert (s_sum='1') and (s_carry='0') report "bad result for input 1 0" severity error;
    wait for 1 fs;

    s_inA <= '0'; s_inB <= '1'; wait for 1 fs;
    assert (s_sum='1') and (s_carry='0') report "bad result for input 0 1" severity error;
    wait for 1 fs;

    s_inA <= '1'; s_inB <= '1'; wait for 1 fs;
    assert (s_sum='0') and (s_carry='1') report "bad result for input 1 1" severity error;
    wait for 1 fs;
    
    assert false report "end of test" severity note;
    wait; --  Wait forever; this will finish the simulation.
  end process;
end behaviour;