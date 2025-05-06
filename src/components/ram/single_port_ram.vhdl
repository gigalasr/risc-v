-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.constant_package.ALL;
use work.utility_package.ALL;

entity single_port_ram is 
    generic(
        word_width : integer := WORD_WIDTH;
        addr_width : integer := REG_ADR_WIDTH  
    );
    port (
        pi_clk  : in std_logic := '0';
        pi_rst  : in std_logic := '0';
        pi_addr : in std_logic_vector(addr_width - 1 downto 0) := (others => '0');
        pi_data : in std_logic_vector(word_width - 1 downto 0) := (others => '0');
        pi_we   : in std_logic := '0';

        po_data : out std_logic_vector(word_width - 1 downto 0) := (others => '0')
    );
end entity single_port_ram;

architecture behavior of single_port_ram is 
    type mem is array (0 to 2 ** addr_width - 1) of std_logic_vector(word_width - 1 downto 0);
    signal s_mem : mem := (others => (others => '0')); 
begin
    -- Data can be read and written on rising edge 
    process(pi_clk, pi_rst) begin
        -- Reset 
        if(pi_rst = '1') then
            s_mem <= (others => (others => '0'));
        end if;

        if rising_edge(pi_clk) then        
            -- Set value if write enabled
            if(pi_we = '1') then 
                s_mem(toi(pi_addr)) <= pi_data;
            end if;
        
            -- Assign Output
            po_data <= s_mem(toi(pi_addr));
        end if;
    end process;
end architecture behavior;
