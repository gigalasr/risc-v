-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity full_adder is 
    port (
        pi_a, pi_b, pi_carry : in  std_logic;
        
        po_sum               : out std_logic;
        po_carry             : out std_logic
    );
end entity full_adder;

architecture structure of full_adder is 
    signal s_sum1, s_carry1, s_carry2 : std_logic := '0';
    begin
        HA1: entity work.half_adder port map (pi_a, pi_carry, s_sum1, s_carry1);
        HA2: entity work.half_adder port map (s_sum1, pi_b, po_sum, s_carry2);
        po_carry <= (s_carry1 nand s_carry1) nand (s_carry2 nand s_carry2);
end architecture structure;
