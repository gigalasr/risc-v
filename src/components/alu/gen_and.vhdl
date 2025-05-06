-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity gen_and is 
    generic(
        data_width : integer := DATA_WIDTH_GEN
    );
    port (
        pi_op1, pi_op2 : in  std_logic_vector(data_width - 1  downto 0);
        
        po_result     : out std_logic_vector(data_width - 1  downto 0)
    );
end entity gen_and;

architecture behavior of gen_and is begin
    po_result <= pi_op1 and pi_op2;
end architecture behavior;
