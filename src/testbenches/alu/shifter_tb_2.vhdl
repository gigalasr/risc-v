-- Laboratory GdTi solutions/versuch8
-- Winter Semester 24/25
-- Group Details
-- Lab Date:
-- 1. Participant First and  Last Name: 
-- 2. Participant First and Last Name:
 
 
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;
use work.CONSTANT_Package.ALL;

entity  shifter_tb2 is
end  shifter_tb2;

architecture behavior of  shifter_tb2 is
  signal s_op1,s_op2, result, result2 : std_logic_vector( DATA_WIDTH_GEN-1 downto 0) := (others => '0');
  signal expect : std_logic_vector( DATA_WIDTH_GEN-1 downto 0) := (others => '0');
  signal s_shift_type, s_shift_direction :std_logic:='0';
  constant PERIOD : time := 10 ns; -- Example: Clockperiod of 10 ns
  
  
begin
  SHIFTER:        entity work.shifter(behavior)  generic map (G_DATA_WIDTH =>  DATA_WIDTH_GEN) port map (s_op1,s_op2,s_shift_type,s_shift_direction, result);
  SHIFTER_struct: entity work.shifter(dataflow) generic map (G_DATA_WIDTH =>  DATA_WIDTH_GEN) port map (s_op1,s_op2,s_shift_type,s_shift_direction, result2);
    
 process

  begin
  -- init 
  s_op1 <= std_logic_vector(to_unsigned(0,  DATA_WIDTH_GEN));
  s_op2 <= std_logic_vector(to_unsigned(0,  DATA_WIDTH_GEN));
  s_shift_type<=not s_shift_type;
  s_shift_direction<= not s_shift_direction;
   for op1_i in -(2**( DATA_WIDTH_GEN-1)) to (2**( DATA_WIDTH_GEN-1)-1) loop
     for op2_i in 0 to (2**(integer(log2(real( DATA_WIDTH_GEN))))-1) loop
        s_op1 <= std_logic_vector(to_signed(op1_i,  DATA_WIDTH_GEN));
        s_op2 <= std_logic_vector(to_unsigned(op2_i,  DATA_WIDTH_GEN));

        -- sll
        s_shift_type<='0';
        s_shift_direction<='0';
        wait for PERIOD/2;
        expect <= (others => '0');
        expect( DATA_WIDTH_GEN-1 downto op2_i) <= s_op1( DATA_WIDTH_GEN-1-op2_i downto 0);
        wait for PERIOD/2;
        assert(expect= result)  report "Had error in sll-Function (behavior)"  & "expect: " & integer'image(to_integer(unsigned(expect))) & " but is " & integer'image(to_integer(unsigned(result))) severity error;
        assert(expect= result2) report "Had error in sll-Function (dataflow)" & "expect: " & integer'image(to_integer(unsigned(expect))) & " but is " & integer'image(to_integer(unsigned(result2))) severity error;

        -- srl
        s_shift_type<='0';
        s_shift_direction<='1';
        wait for PERIOD/2;
        expect <= (others => '0');
        if (op2_i<=0) then 
        expect <= s_op1;
        elsif (op2_i< DATA_WIDTH_GEN) then
        expect( DATA_WIDTH_GEN-1-op2_i downto 0) <= s_op1( DATA_WIDTH_GEN-1 downto op2_i);
        end if;
        wait for PERIOD/2;
        assert(expect= result)  report "Had error in srl-Function (behavior)"& "expect: " & integer'image(to_integer(unsigned(expect)))   & " but is " & integer'image(to_integer(unsigned(result))) severity error;
        assert(expect= result2) report "Had error in srl-Function (dataflow)" & "expect: " & integer'image(to_integer(unsigned(expect))) & " but is " & integer'image(to_integer(unsigned(result2))) severity error;

        -- sra
        s_shift_type<='1';
        s_shift_direction<='1';
        wait for PERIOD/2;
        expect <= (others => s_op1( DATA_WIDTH_GEN-1));
        if (op2_i<=0) then 
        expect <= s_op1;
        elsif (op2_i< DATA_WIDTH_GEN) then
        expect( DATA_WIDTH_GEN-1-op2_i downto 0) <= s_op1( DATA_WIDTH_GEN-1 downto op2_i);
        end if;
        wait for PERIOD/2;
        assert(expect= result) report  "Had error in sra-Function (behavior)"  & "expect: " & integer'image(to_integer(unsigned(expect))) & " but is " & integer'image(to_integer(unsigned(result))) severity error;
        assert(expect= result2) report "Had error in sra-Function (dataflow)" & "expect: " & integer'image(to_integer(unsigned(expect))) & " but is " & integer'image(to_integer(unsigned(result2))) severity error;
        end loop;
        end loop;
    assert false report "end of test" severity note;
   wait; --  Wait forever; this will finish the simulation.
  end process;
end behavior;