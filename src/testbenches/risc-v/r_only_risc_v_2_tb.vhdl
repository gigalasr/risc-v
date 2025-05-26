-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

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
  
entity r_only_risc_v_2_tb is
end entity r_only_risc_v_2_tb;

architecture structure of r_only_risc_v_2_tb is
  constant PERIOD       : time           := 10 ns;

  signal s_clk          : std_logic      := '0';
  signal s_rst          : std_logic      := '0';      
  signal s_registersOut : registerMemory := (others => (others => '0'));
  signal s_instructions : memory := (
      1  => Asm2Std("ADD", 2, 2, 1),
      5  => Asm2Std("ADD", 2, 2, 1),
      9  => Asm2Std("ADD", 2, 2, 1), 
      13 => Asm2Std("ADD", 2, 2, 1),
      17 => Asm2Std("ADD", 2, 2, 1), 
      others => (others => '0') 
  );
begin

riscv_inst: entity work.r_only_risc_v
  port map (
    pi_rst             => s_rst,
    pi_clk             => s_clk,
    pi_instruction     => s_instructions,
    po_registersOut    => s_registersOut
  );

  process is begin
    wait for PERIOD/2;
    for i in 1 to 25 loop
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      -- report "For Cycle: " & integer'image(i) & ": " & integer'image(toi(s_registersOut(2)));
      if (i = 1) then 
        assert(toi(s_registersOut(2)) = 8) report "Should be 8 in the beginning" severity failure;
      elsif (i = 5) then
        assert(toi(s_registersOut(2)) = 17) report "Should be 17 after cycle 4" severity failure;
      elsif (i = 9) then
        assert(toi(s_registersOut(2)) = 26) report "Should be 26 after cycle 7" severity failure;
      elsif (i = 13) then
        assert(toi(s_registersOut(2)) = 35) report "Should be 35 after cycle 10" severity failure;
      elsif (i = 17) then
        assert(toi(s_registersOut(2)) = 44) report "Should be 44 after cycle 13" severity failure;
      elsif (i = 21) then
        assert(toi(s_registersOut(2)) = 53) report "Should be 53 after cycle 16" severity failure;
      end if;
    end loop;

    report "End of test";
    wait;
  end process;

end architecture;

