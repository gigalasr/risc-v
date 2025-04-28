-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt
 
 
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library ieee;
use ieee.std_logic_1164.all;

entity my_full_adder_tb is
end my_full_adder_tb;

architecture behaviour of my_full_adder_tb is
  signal s_inA,s_inB,s_carry_in,s_sum,s_carry_out : std_logic;
begin
  full_adder_0: entity work.full_adder(structure) port map (pi_a=>s_inA,pi_b=>s_inB,pi_carry=>s_carry_in,po_sum=>s_sum,po_carry=>s_carry_out);

  process begin
    s_inA <= '0'; s_inB <= '0'; s_carry_in <= '0'; wait for 1 fs;
    assert (s_carry_out='0') and (s_carry_out='0') report "bad result for input 0 0 0" severity error;
    wait for 1 fs;

    s_inA <= '0'; s_inB <= '0'; s_carry_in <= '1'; wait for 1 fs;
    assert (s_sum='1') and (s_carry_out='0') report "bad result for input 0 0 1" severity error;
    wait for 1 fs;

    s_inA <= '0'; s_inB <= '1'; s_carry_in <= '0'; wait for 1 fs;
    assert (s_sum='1') and (s_carry_out='0') report "bad result for input 0 1 0" severity error;
    wait for 1 fs;

    s_inA <= '0'; s_inB <= '1'; s_carry_in <= '1'; wait for 1 fs;
    assert (s_sum='0') and (s_carry_out='1') report "bad result for input 0 1 1" severity error;
    wait for 1 fs;

    s_inA <= '1'; s_inB <= '0'; s_carry_in <= '0'; wait for 1 fs;
    assert (s_sum='1') and (s_carry_out='0') report "bad result for input 1 0 0" severity error;
    wait for 1 fs;

    s_inA <= '1'; s_inB <= '0'; s_carry_in <= '1'; wait for 1 fs;
    assert (s_sum='0') and (s_carry_out='1') report "bad result for input 1 0 1" severity error;
    wait for 1 fs;

    s_inA <= '1'; s_inB <= '1'; s_carry_in <= '0'; wait for 1 fs;
    assert (s_sum='0') and (s_carry_out='1') report "bad result for input 1 1 0" severity error;
    wait for 1 fs;

    s_inA <= '1'; s_inB <= '1'; s_carry_in <= '1'; wait for 1 fs;
    assert (s_sum='1') and (s_carry_out='1') report "bad result for input 1 1 1" severity error;
    wait for 1 fs;
    
    assert false report "end of test" severity note;
    wait; --  Wait forever; this will finish the simulation.
  end process;
end behaviour;