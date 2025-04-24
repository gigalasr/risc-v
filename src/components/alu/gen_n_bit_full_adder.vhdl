library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity gen_n_bit_full_adder is 
    generic(
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        pi_a, pi_b   : in  std_logic_vector(G_DATA_WIDTH - 1  downto 0);
        pi_carry     : in  std_logic;
        
        po_sum       : out std_logic_vector(G_DATA_WIDTH - 1  downto 0);
        po_carry     : out std_logic

    );
end entity gen_n_bit_full_adder;

architecture structure of gen_n_bit_full_adder is
    signal s_carry_temp : std_logic_vector(G_DATA_WIDTH - 1 downto 0);
    signal s_b          : std_logic_vector(G_DATA_WIDTH - 1 downto 0);  
begin
    GEN: for i in 0 to G_DATA_WIDTH - 1 generate
        s_b(i) <= pi_b(i) xor pi_carry;

        FIRST: if i = 0 generate
            FULL_ADDER: entity work.full_adder(structure)
            port map (pi_a(i), s_b(i), pi_carry, po_sum(i), s_carry_temp(i));
        end generate;

        MID: if (i /= G_DATA_WIDTH - 1) and (i /= 0) generate
            FULL_ADDER: entity work.full_adder(structure)
            port map (pi_a(i), s_b(i), s_carry_temp(i-1), po_sum(i), s_carry_temp(i));
        end generate;

        LAST: if i = G_DATA_WIDTH - 1 generate
            FULL_ADDER: entity work.full_adder(structure)
            port map (pi_a(i), s_b(i), s_carry_temp(i-1) , po_sum(i), po_carry);
        end generate;
    
    end generate;
end architecture structure;
