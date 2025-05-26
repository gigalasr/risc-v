-- Laboratory RA solutions/versuch5
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;

entity register_file_tb is
end register_file_tb;

architecture behavior of register_file_tb is
  -- Constants
  constant c_clk_period : time := 10 ns;

  -- Signals
  signal clk            : std_logic := '0';
  signal rst            : std_logic := '0';
  signal readAddr1      : std_logic_vector(REG_ADR_WIDTH-1 downto 0) := (others => '0');
  signal readAddr2      : std_logic_vector(REG_ADR_WIDTH-1 downto 0) := (others => '0');
  signal writeAddr      : std_logic_vector(REG_ADR_WIDTH-1 downto 0) := (others => '0');
  signal writeData      : std_logic_vector(WORD_WIDTH-1 downto 0) := (others => '0');
  signal writeEnable    : std_logic := '0';
  signal readData1      : std_logic_vector(WORD_WIDTH-1 downto 0);
  signal readData2      : std_logic_vector(WORD_WIDTH-1 downto 0);
  signal regDump        : registerMemory;

begin
  -- DUT instantiation
  uut: entity work.register_file
    port map (
      pi_clk            => clk,
      pi_rst            => rst,
      pi_readRegAddr1   => readAddr1,
      pi_readRegAddr2   => readAddr2,
      pi_writeRegAddr   => writeAddr,
      pi_writeRegData   => writeData,
      pi_writeEnable    => writeEnable,
      po_readRegData1   => readData1,
      po_readRegData2   => readData2,
      po_registerOut    => regDump
    );

  -- Test process
  test_proc: process
  begin
    -- Reset
    rst <= '1';
    wait for c_clk_period;
    rst <= '0';
    wait for c_clk_period;

    -- Write to register 1
    writeAddr   <= std_logic_vector(to_unsigned(1, REG_ADR_WIDTH));
    writeData   <= x"DEADBEEF";
    writeEnable <= '1';

    -- Attempt to read the same register in the same cycle (RAW hazard test)
    readAddr1   <= std_logic_vector(to_unsigned(1, REG_ADR_WIDTH));

    clk <= '0';
    wait for c_clk_period / 2;
    clk <= '1';
    wait for c_clk_period / 2;

    assert readData1 = x"00000000"
    report "RAW hazard: Value mismatch! Expected 00000000, got " & to_hstring(readData1)
    severity failure;
  
    writeEnable <= '0';
    clk <= '0';
    wait for c_clk_period / 2;
    clk <= '1';
    wait for c_clk_period / 2;
    -- Now read register 1 again to verify correct write
    assert readData1 = x"DEADBEEF"
    report "RAW hazard: Value mismatch! Expected DEADBEEF, got " & to_hstring(readData1)
    severity failure;

    report "Test passed: RAW hazard correctly handled.";
    wait;
  end process;

end behavior;