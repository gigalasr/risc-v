-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity my_gen_n_bit_full_adder_tb is end my_gen_n_bit_full_adder_tb;

architecture behaviour of my_gen_n_bit_full_adder_tb is
  constant DATA_WIDTH : integer := 3;
  signal s_carry_in, s_carry_out : std_logic;
  signal s_input_a, s_input_b, s_sum : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
  DUT1 : entity work.gen_n_bit_full_adder
  generic map (
    data_width => DATA_WIDTH
  )
  port map (
    pi_a       => s_input_a,
    pi_b       => s_input_b,
    pi_carry   => s_carry_in,
    po_sum     => s_sum,
    po_carry   => s_carry_out
  );

  process
    variable v_error_count : integer;

  begin
    v_error_count := 0;
    -- Add
    for ai in 0 to (2 ** (DATA_WIDTH-1))-1 loop
      for bi in 0 to (2 ** (DATA_WIDTH-1))-1 loop
        s_input_a <= std_logic_vector(to_unsigned(ai, DATA_WIDTH));
        s_input_b <= std_logic_vector(to_unsigned(bi, DATA_WIDTH));
        s_carry_in <= '0';
        wait for 1 fs;
        if ((ai+bi) /= to_integer(signed(s_sum))) and ((ai+bi- 2**DATA_WIDTH) /= (to_integer(signed(s_sum)))) then
          v_error_count := v_error_count + 1;
          report integer'image(ai) & "+" & integer'image(bi) & " ==> " & integer'image(ai+bi) & " but simulation returns " & integer'image(to_integer(signed(s_sum))) severity error;
        end if;
        wait for 1 fs;
      end loop;
    end loop;

    if v_error_count = 0 then
      report "Test had no errors";
    else
      report "Test had " & integer'image(v_error_count) & " errors";
    end if;
    report "end of normal test.";
    wait; -- Wait forever; this will finish the simulation.
  end process;
end behaviour;