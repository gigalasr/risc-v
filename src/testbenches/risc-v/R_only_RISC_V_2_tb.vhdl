-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 14.05.2025
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types_package.all;
  use work.util_asm_package.all;
  use work.utility_package.all;
  
entity R_only_RISC_V_2_tb is
end entity R_only_RISC_V_2_tb;

architecture structure of R_only_RISC_V_2_tb is

  constant PERIOD       : time           := 10 ns;
  -- signals
  signal s_clk          : std_logic      := '0';
  signal s_rst          : std_logic      := '0';      
  signal s_registersOut : registerMemory := (others => (others => '0'));
  signal s_instructions : memory := (
  -- begin solution:
  -- +--------------------------------------------------------------------------+
  -- | 31......25 |  24.....20  | 19.....15 | 14........12 | 11....7 | 6......0 |
  -- |   funct7   |     rs2     |    rs1    |    funct3    |    rd   |  opcode  |
  -- +--------------------------------------------------------------------------+
      1 => std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
      2 =>std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & R_INS_OP),
      3 => std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & R_INS_OP),
      4 => std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & R_INS_OP),
      5 => std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & R_INS_OP),
      others => (others => '0') 
  -- end solution!!
  );

begin
-- Instanziierung der Entity
riscv_inst : entity work.R_only_RISC_V
  port map (
    pi_rst             => s_rst,
    pi_clk             => s_clk,
    pi_instruction     => s_instructions,
    po_registersOut    => s_registersOut
  );

  process is


  begin
    --s_clk <= '0';
   wait for PERIOD/2;
    for i in 1 to 25 loop
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      report "For Cycle: " & integer'image(i) & ": " & integer'image(toi(s_registersOut(2)));
      if (i = 5) then -- after 5 clock cycles
        assert(toi(s_registersOut(2)) = 17) report "Not the expected value" severity error; -- fixed test not code, lol
      end if;
    end loop;
  report "End of test!!!";
wait;

  end process;

end architecture;
