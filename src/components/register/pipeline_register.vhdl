-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;

entity pipeline_register is 
    generic(
        data_width : integer := DATA_WIDTH_GEN
    );
    port (
        pi_clk : in std_logic := '0';
        pi_rst : in std_logic := '0';
        pi_data : in std_logic_vector(data_width - 1 downto 0) := (others => '0');

        po_data : out std_logic_vector(data_width - 1 downto 0) := (others => '0')
    );
end entity pipeline_register;

architecture behavior of pipeline_register is 
    signal s_reg : std_logic_vector(data_width - 1  downto 0) := (others => '0');
begin
    po_data <= s_reg;

    process(pi_clk, pi_rst) begin
        if rising_edge(pi_clk) then
            if(pi_rst = '1') then
                s_reg <= (others => '0');
            else 
                s_reg <= pi_data;
            end if;            
        end if; 
    end process;
end architecture behavior;
