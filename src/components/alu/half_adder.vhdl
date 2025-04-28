-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity half_adder is 
    port (
        pi_a, pi_b : in  std_logic;
        
        po_sum         : out std_logic;
        po_carry       : out std_logic
    );
end entity half_adder;

architecture dataflow of half_adder is begin
    po_sum <= ((pi_a NAND pi_a) NAND pi_b) NAND (pi_a NAND (pi_b NAND pi_b));
    po_carry <= (pi_a NAND pi_b) NAND (pi_a NAND pi_b);
end architecture dataflow;
