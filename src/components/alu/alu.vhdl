library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constant_package.ALL;


entity alu is
  generic (
    G_DATA_WIDTH   : integer := DATA_WIDTH_GEN;
    G_OP_WIDTH     : integer := ALU_OPCODE_WIDTH
  );
  port (
    pi_op1, pi_op2 : in std_logic_vector(G_DATA_WIDTH - 1  downto 0) := (others => '0');
    pi_alu_op      : in std_logic_vector(G_OP_WIDTH   - 1  downto 0) := (others => '0');

    po_alu_out     : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
    po_carry_out   : out std_logic := '0'
  );

end entity alu;


architecture behavior of alu is
  signal s_op1, s_op2, s_res_xor, s_res_or, s_res_and, s_res_shift, s_res_add : STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0) := (others => '0');
  signal s_carry_in, s_carry_out, s_shift_type, s_shift_direction                       : STD_LOGIC := '0';
  signal s_alu_op                                                             : STD_LOGIC_VECTOR(G_OP_WIDTH   - 1 downto 0) := (others => '0');

begin
  XOR1:  entity work.gen_xor generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_res_xor);
  OR1:   entity work.gen_or  generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_res_or);
  AND1:  entity work.gen_and generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_res_and);
  Shift: entity work.shifter generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_shift_type, s_shift_direction, s_res_shift);
  ADD1:  entity work.gen_n_bit_full_adder generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_carry_in, s_res_add, s_carry_out);

  s_op1 <= pi_op1;
  s_op2 <= pi_op2;
  s_alu_op <= pi_alu_op;
  s_shift_type <= pi_alu_op(G_OP_WIDTH - 1);
  s_carry_in <= pi_alu_op(G_OP_WIDTH - 1);
  po_carry_out <= s_carry_out;

  process(s_op1, s_op2, s_alu_op, s_shift_type, s_shift_direction, s_res_add, s_res_shift) begin 
    case s_alu_op is
      when AND_ALU_OP => po_alu_out <= s_res_and;
      when XOR_ALU_OP => po_alu_out <= s_res_xor;
      when OR_ALU_OP => po_alu_out <= s_res_or;

      when SLL_ALU_OP => 
        s_shift_direction <= '0';
        po_alu_out <= s_res_shift;
      when SRL_ALU_OP =>         
        s_shift_direction <= '1';
        po_alu_out <= s_res_shift;
      when SRA_ALU_OP => po_alu_out <= s_res_shift;

      when ADD_ALU_OP => po_alu_out <= s_res_add;
      when SUB_ALU_OP => po_alu_out <= s_res_add;

      when others =>
    end case;
  end process;
end architecture behavior;