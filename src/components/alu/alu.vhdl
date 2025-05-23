-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.constant_package.ALL;

entity alu is
  generic (
    data_width   : integer := DATA_WIDTH_GEN;
    op_width     : integer := ALU_OPCODE_WIDTH
  );
  port (
    pi_op1, pi_op2 : in std_logic_vector(data_width - 1  downto 0) := (others => '0');
    pi_alu_op      : in std_logic_vector(op_width   - 1  downto 0) := (others => '0');

    po_alu_out     : out std_logic_vector(data_width - 1 downto 0) := (others => '0');
    po_carry_out   : out std_logic := '0';
    po_zero        : out std_logic := '0'
  );

end entity alu;


architecture behavior of alu is
  signal s_op1, s_op2, s_res_xor, s_res_or, s_res_and, s_res_shift, s_res_add : STD_LOGIC_VECTOR(data_width - 1 downto 0) := (others => '0');
  signal s_res_slt, s_res_sltu                                                : STD_LOGIC_VECTOR(data_width - 1 downto 0) := (others => '0');
  signal s_carry_in, s_carry_out, s_shift_type, s_shift_direction, s_zero     : STD_LOGIC := '0';
  signal s_alu_op                                                             : STD_LOGIC_VECTOR(op_width   - 1 downto 0) := (others => '0');

begin

  XOR1:  entity work.gen_xor generic map (data_width) port map (s_op1, s_op2, s_res_xor);
  OR1:   entity work.gen_or  generic map (data_width) port map (s_op1, s_op2, s_res_or);
  AND1:  entity work.gen_and generic map (data_width) port map (s_op1, s_op2, s_res_and);
  Shift: entity work.shifter generic map (data_width) port map (s_op1, s_op2, s_shift_type, s_shift_direction, s_res_shift);
  ADD1:  entity work.gen_n_bit_full_adder generic map (data_width) port map (s_op1, s_op2, s_carry_in, s_res_add, s_carry_out);

process(pi_alu_op) is

  variable v_alu_out: std_logic_vector(data_width - 1 downto 0) := po_alu_out;

begin 

  s_op1 <= pi_op1;
  s_op2 <= pi_op2;
  s_alu_op <= pi_alu_op;
  s_shift_type <= pi_alu_op(op_width - 1);
  s_carry_in <= pi_alu_op(op_width - 1);
  s_res_slt <= std_logic_vector(to_unsigned(1, data_width)) when (signed(s_op1)) < (signed(s_op2)) else std_logic_vector(to_unsigned(0, data_width));
  s_res_sltu <= std_logic_vector(to_unsigned(1, data_width)) when (unsigned(s_op1)) < (unsigned(s_op2)) else std_logic_vector(to_unsigned(0, data_width));
  po_carry_out <= s_carry_out;
  po_zero <= s_zero;
  -- s_zero <= '1' when (s_op1 >= s_op2) else '0';

  

  -- with s_alu_op select
  --   s_shift_direction <= 
  --     '1' when SRL_ALU_OP,
  --     '0' when others;

  case s_alu_op is
    when SRL_ALU_OP => s_shift_direction <= '1';
    when others     => s_shift_direction <= '0';
  end case;


  case s_alu_op is
    when AND_ALU_OP  => v_alu_out := s_res_and;
    when XOR_ALU_OP  => v_alu_out := s_res_xor;
    when OR_ALU_OP   => v_alu_out := s_res_or;
    when SLL_ALU_OP  => v_alu_out := s_res_shift;
    when SRL_ALU_OP  => v_alu_out := s_res_shift;
    when SRA_ALU_OP  => v_alu_out := s_res_shift;
    when ADD_ALU_OP  => v_alu_out := s_res_add;
    when SUB_ALU_OP  => v_alu_out := s_res_add;
    when SLT_ALU_OP  => v_alu_out := s_res_slt;
    when SLTU_ALU_OP => v_alu_out := s_res_sltu;
    when others      => v_alu_out := (others => '0');
  end case;  
end process;
end architecture behavior;
