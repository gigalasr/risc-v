-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.constant_package.ALL;
use work.utility_package.ALL;
use work.types_package.ALL;

entity register_file is 
    generic(
        word_width : integer := WORD_WIDTH;
        addr_width : integer := REG_ADR_WIDTH
    );
    port (
        pi_clk          : in std_logic := '0';
        pi_rst          : in std_logic := '0';
        
        pi_readRegAddr1 : in std_logic_vector(addr_width - 1 downto 0) := (others => '0');
        pi_readRegAddr2 : in std_logic_vector(addr_width - 1 downto 0) := (others => '0');
        
        pi_writeRegAddr : in std_logic_vector(addr_width - 1 downto 0) := (others => '0');
        pi_writeRegData : in std_logic_vector(word_width - 1 downto 0) := (others => '0');
        pi_writeEnable  : in std_logic := '0';

        po_readRegData1 : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_readRegData2 : out std_logic_vector(word_width - 1 downto 0) := (others => '0');

        po_registerOut  : out registermemory
    );
end entity register_file;

architecture behavior of register_file is 
    signal s_mem : registermemory := (others => (others => '0')); 
    signal s_read1, s_read2 : std_logic_vector(word_width - 1 downto 0) := (others => '0');
begin
    -- Debug Output
    po_registerOut <= s_mem;
    
    -- Data can be read and written on rising edge 
    process(pi_clk) begin
        -- Reset 
        if(pi_rst = '1') then
            s_mem <= (others => (others => '0'));
        elsif rising_edge(pi_clk) then   
            -- Assign Read Ouput 1
            if(toi(pi_readRegAddr1) = 0) then
                s_read1 <= (others => '0');
            else 
                s_read1 <= s_mem(toi(pi_readRegAddr1))(word_width-1 downto 0);
            end if;    

            -- Assign Read Ouput 2
            if(toi(pi_readRegAddr2) = 0) then
                s_read2 <= (others => '0');
            else 
                s_read2 <= s_mem(toi(pi_readRegAddr2))(word_width-1 downto 0);
            end if;   

            -- Set value if write enabled and addr is not 0
            if(pi_writeEnable = '1' AND toi(pi_writeRegAddr) /= 0) then 
                s_mem(toi(pi_writeRegAddr))(word_width-1 downto 0) <= pi_writeRegData;
            end if;
        end if;
    end process;

    po_readRegData1 <= s_read1;
    po_readRegData2 <= s_read2;
end architecture behavior;



