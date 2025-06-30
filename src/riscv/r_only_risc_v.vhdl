-- Laboratory RA solutions/versuch4
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
use work.utility_package.all;

entity r_only_risc_v is
  port (
    pi_rst          : in    std_logic;
    pi_clk          : in    std_logic;
    pi_instruction  : in    memory := (others => (others => '0'));
    po_registersOut : out   registermemory := (others => (others => '0'))
  );
end entity r_only_risc_v;

architecture structure of r_only_risc_v is
  constant PERIOD                : time                                            := 10 ns;
  constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)       := std_logic_vector(to_signed((4), WORD_WIDTH));

  signal s_clk, s_rst : std_logic := '0';

  signal s_pc_adder_po_sum          : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_pc_adder_pi_a            : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_pc_po_data               : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_pc_pi_data               : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  
  signal s_instr_cache_pi_adr       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_instr_cache_po_data      : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_instr_cache_reg_po_data  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_instr_cache_reg_pi_data  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  
  signal s_dec_po_controlWord       : controlword := control_word_init; 
  signal s_dec_pi_instruction       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_cwr_1_po_controlWord     : controlword := control_word_init;
  signal s_cwr_2_po_controlWord     : controlword := control_word_init;
  signal s_cwr_3_po_controlWord     : controlword := control_word_init;
  signal s_cwr_1_pi_controlWord     : controlword := control_word_init;
  signal s_cwr_2_pi_controlWord     : controlword := control_word_init;
  signal s_cwr_3_pi_controlWord     : controlword := control_word_init;
  
  signal s_idex_reg_1_po_data       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_reg_2_po_data       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_reg_3_po_data       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
 
  signal s_idex_reg_1_pi_data       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_reg_2_pi_data       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_reg_3_pi_data       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
 
  signal s_idex_op1_po_data         : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_op2_po_data         : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_op1_pi_data         : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_op2_pi_data         : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_alu_out                  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_alu_pi_op1               : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_alu_pi_op2               : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_alu_pi_alu_op            : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');

  signal s_ex_mem_res_po_data       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0'); 
  signal s_mem_wb_res_po_data       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_mem_res_pi_data       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0'); 
  signal s_mem_wb_res_pi_data       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_reg_file_po_readRegData1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_reg_file_po_readRegData2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_reg_file_pi_readRegAddr1 : std_logic_vector(REG_ADR_WIDTH -1 downto 0) := (others => '0');
  signal s_reg_file_pi_readRegAddr2 : std_logic_vector(REG_ADR_WIDTH -1 downto 0) := (others => '0');
  signal s_reg_file_pi_writeRegAddr : std_logic_vector(REG_ADR_WIDTH -1 downto 0) := (others => '0');
  signal s_reg_file_pi_writeRegData : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_reg_file_pi_writeEnable  : std_logic := '0';

begin
  s_clk <= pi_clk;
  s_rst <= pi_rst;

---********************************************************************
---* program counter adder and pc-register
---********************************************************************
  pc_adder: entity work.gen_n_bit_full_adder 
            generic map(WORD_WIDTH) 
            port map(
              pi_a     => s_pc_adder_pi_a,
              pi_b     => ADD_FOUR_TO_ADDRESS,
              pi_carry => '0',
              po_sum   => s_pc_adder_po_sum,
              po_carry => open
            );
  pc: entity work.pipeline_register 
      generic map(WORD_WIDTH) 
      port map(
        pi_clk  => s_clk,
        pi_rst  => s_rst,
        pi_data => s_pc_pi_data,
        po_data => s_pc_po_data
      );
  
  s_pc_pi_data <= s_pc_adder_po_sum;
  s_pc_adder_pi_a <= s_pc_po_data;

---********************************************************************
---* instruction fetch 
---********************************************************************
instr_cache: entity work.instruction_cache
            generic map(WORD_WIDTH)
            port map(
              pi_adr => s_instr_cache_pi_adr,            
              pi_clk => not s_clk,             
              pi_rst => s_rst,             
              pi_instructionCache => pi_instruction,
              po_instruction => s_instr_cache_po_data
            );

  s_instr_cache_pi_adr <=s_pc_po_data;

---********************************************************************
---* Pipeline-Register (IF -> ID) start
---********************************************************************  
instr_cache_reg: entity work.pipeline_register
                 generic map(WORD_WIDTH)
                 port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst,
                  pi_data => s_instr_cache_reg_pi_data,
                  po_data => s_instr_cache_reg_po_data
                 );
s_instr_cache_reg_pi_data <= s_instr_cache_po_data;

---********************************************************************
---* decode phase
---********************************************************************
dec: entity work.decoder 
     port map(
      pi_instruction => s_dec_pi_instruction,
      po_controlWord => s_dec_po_controlWord
     );

s_dec_pi_instruction <= s_instr_cache_reg_po_data;

---********************************************************************
---* Pipeline-Register (ID -> EX) 
---********************************************************************
cwr_1: entity work.control_word_register 
       port map (
         pi_rst => s_rst,
         pi_clk => s_clk,
         pi_controlWord => s_cwr_1_pi_controlWord,
         po_controlWord => s_cwr_1_po_controlWord
       );

s_cwr_1_pi_controlWord <= s_dec_po_controlWord;

cwr_2: entity work.control_word_register 
       port map (
         pi_rst => s_rst,
         pi_clk => s_clk,
         pi_controlWord => s_cwr_2_pi_controlWord,
         po_controlWord => s_cwr_2_po_controlWord
       );

s_cwr_2_pi_controlWord <= s_cwr_1_po_controlWord;


cwr_3: entity work.control_word_register 
       port map (
         pi_rst => s_rst,
         pi_clk => s_clk,
         pi_controlWord => s_cwr_3_pi_controlWord,
         po_controlWord => s_cwr_3_po_controlWord
       );

s_cwr_3_pi_controlWord <= s_cwr_2_po_controlWord;


idex_reg_1: entity work.pipeline_register 
                generic map(REG_ADR_WIDTH)
                port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst,
                  pi_data => s_idex_reg_1_pi_data,
                  po_data => s_idex_reg_1_po_data
                );

s_idex_reg_1_pi_data <= s_instr_cache_reg_po_data(11 downto 7);

idex_reg_2: entity work.pipeline_register 
                generic map(REG_ADR_WIDTH)
                port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst,
                  pi_data => s_idex_reg_2_pi_data,
                  po_data => s_idex_reg_2_po_data
                );
s_idex_reg_2_pi_data <= s_idex_reg_1_po_data;


idex_reg_3: entity work.pipeline_register 
                generic map(REG_ADR_WIDTH)
                port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst,
                  pi_data => s_idex_reg_3_pi_data,
                  po_data => s_idex_reg_3_po_data
                );
s_idex_reg_3_pi_data <= s_idex_reg_2_po_data;


idex_op1: entity work.pipeline_register 
           generic map (WORD_WIDTH)
           port map(
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_data => s_idex_op1_pi_data,
              po_data => s_idex_op1_po_data
           );
s_idex_op1_pi_data <= s_reg_file_po_readRegData1;

idex_op2: entity work.pipeline_register 
           generic map (WORD_WIDTH)
           port map(
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_data => s_idex_op2_pi_data,
              po_data => s_idex_op2_po_data
           );
s_idex_op2_pi_data <= s_reg_file_po_readRegData2;


---********************************************************************
---* execute phase
---********************************************************************
alu: entity work.alu
     generic map (WORD_WIDTH, ALU_OPCODE_WIDTH)
     port map(
       pi_op1 => s_alu_pi_op1,
       pi_op2 => s_alu_pi_op2,
       pi_alu_op => s_alu_pi_alu_op,
       po_alu_out => s_alu_out,
       po_carry_out => open
     );

s_alu_pi_op1 <= s_idex_op1_po_data;
s_alu_pi_op2 <= s_idex_op2_po_data;
s_alu_pi_alu_op <= s_cwr_1_po_controlWord.ALU_OP;

---********************************************************************
---* Pipeline-Register (EX -> MEM) 
---********************************************************************
ex_mem_res: entity work.pipeline_register
            generic map (WORD_WIDTH)
            port map (
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_data => s_ex_mem_res_pi_data,
              po_data => s_ex_mem_res_po_data
            );
s_ex_mem_res_pi_data <= s_alu_out;

---********************************************************************
---* memory phase
---********************************************************************


---********************************************************************
---* Pipeline-Register (MEM -> WB) 
---********************************************************************
mem_wb_res: entity work.pipeline_register
            generic map (WORD_WIDTH)
            port map (
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_data => s_mem_wb_res_pi_data,
              po_data => s_mem_wb_res_po_data
            );
s_mem_wb_res_pi_data <= s_ex_mem_res_po_data;

---********************************************************************
---* write back phase
---********************************************************************



---********************************************************************
---* register file (negative clock)
---********************************************************************
reg_file: entity work.register_file 
          port map(
            pi_clk => not s_clk,
            pi_rst => s_rst,
            pi_readRegAddr1 => s_reg_file_pi_readRegAddr1,
            pi_readRegAddr2 => s_reg_file_pi_readRegAddr2,
            pi_writeRegAddr => s_reg_file_pi_writeRegAddr,
            pi_writeRegData => s_reg_file_pi_writeRegData,
            pi_writeEnable  => s_reg_file_pi_writeEnable,
            po_readRegData1 => s_reg_file_po_readRegData1,
            po_readRegData2 => s_reg_file_po_readRegData2,
            po_registerOut  => po_registersOut
          );

s_reg_file_pi_readRegAddr1 <= s_instr_cache_reg_po_data(19 downto 15);
s_reg_file_pi_readRegAddr2 <= s_instr_cache_reg_po_data(24 downto 20);
s_reg_file_pi_writeRegAddr <= s_idex_reg_3_po_data;
s_reg_file_pi_writeRegData <= s_mem_wb_res_po_data;
s_reg_file_pi_writeEnable  <= s_cwr_3_po_controlWord.REG_WRITE;  
end architecture;


