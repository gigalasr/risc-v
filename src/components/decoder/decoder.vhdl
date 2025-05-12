-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

-- R Type
-- - All operations read the rs1 and rs2 registers as source operands and write 
--   the result into register rd
-- - The funct7 and funct3 fields select the type of operation 
-- - Although for funct7 only the second bit is interesting, 
--   as it indicated sub and shift directions
-- - opcode is 0110011 for R-Type 
--
-- +--------------------------------------------------------------------------+
-- | 31......25 |  24.....20  | 19.....15 | 14........12 | 11....7 | 6......0 |
-- |   funct7   |     rs2     |    rs1    |    funct3    |    rd   |  opcode  |
-- +--------------------------------------------------------------------------+

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;

entity decoder is
    port (
        pi_instruction : in  std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
        po_controlWord : out controlword := control_word_init
    );
end entity decoder;

architecture arch of decoder is begin
    process(pi_instruction) is
        variable v_insFormat : t_instruction_type := nullFormat;
    begin 
        -- Hardcoded for now
        po_controlWord.REG_WRITE <= '1';

        -- Decode instruction type
        case pi_instruction(6 downto 0) is
            when R_INS_OP => v_insFormat := rFormat;
            when others => v_insFormat := nullFormat; 
        end case;

        -- Decode instruction based on type
        case v_insFormat is
            when rFormat =>
                po_controlWord.ALU_OP(3)          <= pi_instruction(30);
                po_controlWord.ALU_OP(2 downto 0) <= pi_instruction(14 downto 12);
            when others => po_controlWord.ALU_OP  <= (others => '0');
        end case;
    end process;
end architecture;