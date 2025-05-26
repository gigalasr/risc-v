-- laboratory ra solutions/versuch5
-- sommersemester 25
-- group details
-- lab date:
-- 1. participant first and last name: 
-- 2. participant first and last name:

-- ========================================================================
-- author:       marcel rieß
-- last updated: 21.05.2025
-- description:  ri-only-risc-v for an incomplete rv32i implementation, support
--               only r- and i-instructions. 
--
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;
use work.util_asm_package.all;

entity ri_only_risc_v_tb is
end entity ri_only_risc_v_tb;

architecture structure of ri_only_risc_v_tb is

  constant period           : time            := 10 ns;
  signal s_clk              : std_logic       := '0';
  signal s_rst              : std_logic       := '0';
  signal cycle              : integer         :=0;
  signal s_test             : integer         := 0;
  signal s_registersout     : registermemory  := (others => (others => '0'));
  signal s_instructions     : memory          := (others => (others => '0'));

  -- prozedur fuer vergleich
 procedure check_register (
  expected : integer;
  reg_num  : integer;
  instr    : string
) is
begin
  assert (to_integer(signed(s_registersout(reg_num))) = expected)
    report instr & " fehlgeschlagen. register " & integer'image(reg_num) &
           " enthaelt " & integer'image(to_integer(signed(s_registersout(reg_num)))) &
           ", sollte aber " & integer'image(expected) & " enthalten!" severity failure;
end procedure;

begin

  dut : entity work.ri_only_risc_v
    port map(
      pi_rst          => s_rst,
      pi_clk          => s_clk,
      pi_instruction  => s_instructions,
      po_registersout => s_registersout
    );

  process (cycle) is

  begin

       if s_test = 1 then
        if (cycle =  5) then check_register(  9, 1, "addi" );end if;
        if (cycle =  6) then check_register(  8, 2, "addi" );end if;
        if (cycle = 12) then check_register( 13, 3, "ori"  );end if;
        if (cycle = 13) then check_register(  8, 2, "addi" );end if;
        if (cycle = 14) then check_register(288, 3, "slli" );end if;
        if (cycle = 15) then check_register(  0, 3, "srli" );end if;
        if (cycle = 16) then check_register( 12, 3, "xori" );end if;
        if (cycle = 17) then check_register(  1, 3, "xor"  );end if;
        if (cycle = 18) then check_register(  1, 3, "slti" );end if;
        if (cycle = 19) then check_register(  0, 3, "sltiu");end if;
        if (cycle = 20) then check_register(  0, 3, "slti" );end if;
        if (cycle = 21) then check_register(  1, 3, "sltiu");end if;
        if (cycle = 28) then check_register(  1, 3, "slt"  );end if;
        if (cycle = 29) then check_register(  1, 3, "sltu" );end if;
        if (cycle = 30) then check_register(  0, 3, "slt"  );end if;
        if (cycle = 31) then check_register(  0, 3, "sltu" );end if;

      elsif s_test = 2 then
        if (cycle =  5) then check_register(  9, 1, "addi" );end if;
        if (cycle =  6) then check_register(  8, 2, "addi" );end if;
        if (cycle = 10) then check_register( 17, 8, "add"  );end if;
        if (cycle = 11) then check_register(  1,11, "sub"  );end if;
        if (cycle = 12) then check_register( -1,12, "sub"  );end if;
        if (cycle = 13) then check_register(  9, 9, "or"   );end if;
        if (cycle = 14) then check_register(  1, 9, "xor"  );end if;
        if (cycle = 15) then check_register(  8, 9, "and"  );end if;
        if (cycle = 16) then check_register( 16, 8, "sll"  );end if;
        if (cycle = 17) then check_register(  8, 8, "srl"  );end if;
        if (cycle = 18) then check_register( -8, 9, "sub"  );end if;
        if (cycle = 19) then check_register(  0,10, "sra"  );end if;
      end if;

  end process;

  process is
  begin
    -- test 1 i-format
    s_test <= 1;
    s_instructions <= (
       1 => asm2std("addi" , 1, 0,  9),
       2 => asm2std("addi" , 2, 0,  8),
       8 => asm2std("ori"  , 3, 1,  5),
       9 => asm2std("andi" , 3, 1,  5),
      10 => asm2std("slli" , 3, 1,  5),
      11 => asm2std("srli" , 3, 1,  5),
      12 => asm2std("xori" , 3, 1,  5),
      13 => asm2std("xor"  , 3, 1,  2),
      14 => asm2std("slti" , 3, 1, 10),
      15 => asm2std("sltiu", 3, 1,  8),
      16 => asm2std("slti" , 3, 1,-10),
      17 => asm2std("sltiu", 3, 1, -8),
      18 => asm2std("sub"  ,14, 0,  1),
      19 => asm2std("sub"  ,15, 0,  2),
      24 => asm2std("slt"  , 3,14, 15),
      25 => asm2std("sltu" , 3,14, 15),
      26 => asm2std("slt"  , 3,15, 14),
      27 => asm2std("sltu" , 3,15, 14), 
      others => (others => '0')
      );
    wait for period;
    for i in 1 to 35 loop
      s_clk <= '1';
      wait for period / 2;
      s_clk <= '0';
      wait for period / 2;
      cycle <= i;
    end loop;
    report "end of tests for i-format!";

    -- test 2 (r befehle)
s_test <= 2;

      s_rst <= '1';
      wait for period / 2;
      s_rst <= '0';
      wait for period / 2;

    s_instructions <= (
       1 => asm2std("addi",  1, 0,  9),
       2 => asm2std("addi",  2, 0,  8),
       6 => asm2std("add" ,  8, 1,  2),
       7 => asm2std("sub" , 11, 1,  2),
       8 => asm2std("sub" , 12, 2,  1),
       9 => asm2std("or"  ,  9, 2,  1),
      10 => asm2std("xor" ,  9, 2,  1),
      11 => asm2std("and" ,  9, 2,  1),
      12 => asm2std("sll" ,  8, 2, 11),
      13 => asm2std("srl" ,  8, 8, 11),
      14 => asm2std("sub" ,  9, 0,  2),
      15 => asm2std("sra" , 10, 1,  2),
      others => (others => '0')
      );

      wait for period ;

    for i in 1 to 22 loop
      s_clk <= '1';
      wait for period / 2;
      s_clk <= '0';
      wait for period / 2;
      cycle <= i;
    end loop;
    report "end of tests for r-format!";
    report "end of test ri!!!";
    wait;

  end process;

end architecture;