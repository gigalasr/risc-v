-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity gen_mux is 
    generic(
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        pi_sel : in std_logic := '0';
        pi_fst : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        pi_snd : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');

        po_res : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0')
    );
end entity gen_mux;

architecture behavior of gen_mux is begin
    with pi_sel select
        po_res <=
        pi_fst when '0',
        pi_snd when '1',
        (others => '0') when others; 
end architecture behavior;
