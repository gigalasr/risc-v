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

entity register_file is 
    generic(
        G_WORD_WIDTH : integer := WORD_WIDTH;
        G_ADDR_WIDTH : integer := REG_ADR_WIDTH;
        G_REG_AMOUNT : integer := 2 ** REG_ADR_WIDTH - 1
    );
    port (
        pi_clk          : in std_logic := '0';
        pi_rst          : in std_logic := '0';
        
        pi_readRegData1 : in std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
        pi_readRegData2 : in std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
        
        pi_writeRegAddr : in std_logic_vector(G_ADDR_WIDTH - 1 downto 0) := (others => '0');
        pi_writeRegData : in std_logic_vector(G_WORD_WIDTH - 1 downto 0) := (others => '0');
        pi_writeEnable  : in std_logic := '0';

        po_readRegData1 : out std_logic_vector(G_WORD_WIDTH - 1 downto 0) := (others => '0');
        po_readREgData2 : out std_logic_vector(G_WORD_WIDTH - 1 downto 0) := (others => '0')

    );
end entity register_file;

architecture behavior of register_file is 
    type mem is array (1 to G_REG_AMOUNT) of std_logic_vector(G_WORD_WIDTH - 1 downto 0);
    signal s_mem : mem := (others => (others => '0')); 
begin
    -- Data can be read and written on rising edge 
    process(pi_clk, pi_rst) begin
        -- Reset 
        if(pi_rst = '1') then
            s_mem <= (others => (others => '0'));
        end if;

        if rising_edge(pi_clk) then   
            -- Assign Read Ouput 1
            if(toi(pi_readRegData1) = 0) then
                po_readRegData1 <= (others => '0');
            else 
                po_readRegData1 <= s_mem(toi(pi_readRegData1));
            end if;    

            -- Assign Read Ouput 2
            if(toi(pi_readRegData2) = 0) then
                po_readRegData2 <= (others => '0');
            else 
                po_readRegData2 <= s_mem(toi(pi_readRegData2));
            end if;    
            
            -- Set value if write enabled and addr is not 0
            if(pi_writeEnable = '1' AND toi(pi_writeRegAddr) /= 0) then 
                s_mem(toi(pi_writeRegAddr)) <= pi_writeRegData;
            end if;
        end if;
    end process;
end architecture behavior;
