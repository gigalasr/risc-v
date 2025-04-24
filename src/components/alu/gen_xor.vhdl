library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity gen_xor is 
    generic(
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        pi_op1, pi_op2 : in  std_logic_vector(G_DATA_WIDTH - 1  downto 0);
        
        po_result     : out std_logic_vector(G_DATA_WIDTH - 1  downto 0)
    );
end entity gen_xor;

architecture behavior of gen_xor is begin
    po_result <= pi_op1 xor pi_op2;
end architecture behavior;
