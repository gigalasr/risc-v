-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

package utility_package is
    function toi(vec : std_logic_vector) return integer;
end package utility_package;

package body utility_package is
    function toi(vec : std_logic_vector) return integer is
    begin
        return to_integer(unsigned(vec));
    end function;
end package body utility_package;