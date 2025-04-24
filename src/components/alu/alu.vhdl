library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;


entity alu is
  generic (
    G_DATA_WIDTH  : integer := DATA_WIDTH_GEN;
    G_OP_WIDTH    : integer := OPCODE_WIDTH
  );
  port (
    pi_op1, pi_op2 : in std_logic_vector(G_DATA_WIDTH - 1  downto 0);
    pi_alu_op     : in std_logic_vector(G_OP_WIDTH   - 1  downto 0);

    po_alu_out    : out std_logic_vector(G_DATA_WIDTH - 1 downto 0);
    po_carry_out  : out std_logic
  );

end entity alu;


architecture behavior of alu is
  signal s_res_xor, s_res_or, s_rs_and, s_res_shift, s_res_add : STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal s_cIn, s_cOut, s_shift_type, s_shift_direction   : STD_LOGIC := '0';

begin
  XOR1:  entity work.gen_xor generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_res_xor);
  OR1:   entity work.gen_or  generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_res2);
  AND1:  entity work.gen_and generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_res3);
  Shift: entity work.shifter generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2,s_shift_type,s_shift_direction, s_res4);
  ADD1:  entity work.gen_n_bit_full_adder generic map (G_DATA_WIDTH) port map (p_op1, pi_op2, s_cIn, s_res5, s_cOut);

  s_shift_type <= pi_alu_op(G_OP_WIDTH - 1);
  s_cIn <= pi_alu_op(G_OP_WIDTH - 1);


  s_res_xor <= pi_op1 xor pi_op2;
  s_res_or <= pi_op1 or pi_op2;
  s_res_and <= pi_op1 and pi_op2;
  s_res_add <= std_logic_vector(unsigned(op1) + unsigned(op2));

  aluout <= std_logic_vector(shift_right(signed(op1), to_integer(unsigned(op2(4 downto 0)))));  
  aluout <= std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2(4 downto 0)))));  


-- begin solution:
-- end solution!!


end architecture behavior;