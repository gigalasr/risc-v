-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

-- ========================================================================
-- Description:  Sign extender for a RV32I processor. Takes the entire instruction
--               and produces a 32-Bit value by sign-extending, shifting and piecing
--               together the immedate value in the instruction.
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity sign_extension is
  port (
    pi_instr       : in std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    po_storeImm     : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_immediateImm : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_unsignedImm  : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_branchImm    : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_jumpImm      : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0')
  );
end entity sign_extension;

architecture arc of sign_extension is
begin
  -- S-Type
  po_storeImm(11 downto 5) <= pi_instr(31 downto 25);
  po_storeImm(4 downto 0) <= pi_instr(11 downto 7);
  po_storeImm(31 downto 12) <= (others => pi_instr(31)); -- sign extension

  -- I-Type
  po_immediateImm(11 downto 0) <= pi_instr(31 downto 20);
  po_immediateImm(31 downto 12) <= (others => pi_instr(31)); -- sign extension

  -- U-Type
  po_unsignedImm(31 downto 12) <= pi_instr(31 downto 12);
  --po_unsignedImm(11 downto 0) <= (others => '0');

  -- B-Type
  po_branchImm(12) <= pi_instr(31);
  po_branchImm(11) <= pi_instr(7);
  po_branchImm(10 downto 5) <= pi_instr(30 downto 25);
  po_branchImm(4 downto 1) <= pi_instr(11 downto 8);
  po_branchImm(31 downto 13) <= (others => pi_instr(31)); -- sign extension

  -- J-Type
  po_jumpImm(20) <= pi_instr(31);
  po_jumpImm(19 downto 12) <= pi_instr(19 downto 12);
  po_jumpImm(11) <= pi_instr(20);
  po_jumpImm(10 downto 1) <= pi_instr(30 downto 21);
  po_jumpImm(31 downto 21) <= (others => pi_instr(31)); -- sign extension
end architecture arc;