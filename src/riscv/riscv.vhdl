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

entity riscv is
  port (
    KEY                                : in std_logic_vector(1 downto 0);
	 SW                                 : in std_logic_vector(9 downto 0);
	 LEDR                               : out std_logic_vector(7 downto 0);
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
  );
end entity riscv;

architecture structure of riscv is
  constant PERIOD                : time                                            := 10 ns;
  constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)       := std_logic_vector(to_signed((4), WORD_WIDTH));
  constant ADD_ZERO_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)       := std_logic_vector(to_signed((0), WORD_WIDTH));

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
  signal s_alu_po_zero              : std_logic := '0';

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

  signal s_sign_ext_pi_instr        : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sign_ext_po_storeImm     : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sign_ext_po_immediateImm : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sign_ext_po_unsignedImm  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sign_ext_po_branchImm    : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sign_ext_po_jumpImm      : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_idex_sign_ex_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_idex_sign_ex_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_alu_imm_op2_mux_pi_sel : std_logic := '0';
  signal s_alu_imm_op2_mux_pi_fst : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_alu_imm_op2_mux_pi_snd : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_alu_imm_op2_mux_po_res : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_imwb_1_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_imwb_1_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_imwb_2_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_imwb_2_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_pcex_1_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_pcex_1_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_pcex_2_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_pcex_2_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_ex_pc_add_4_po_sum : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pc_add_4_pi_a : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  
  signal s_ex_pcp4_1_res_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_1_res_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_2_res_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_2_res_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_3_res_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_3_res_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_4_res_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_pcp4_4_res_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_ex_br_addr_pi_a   : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_br_addr_pi_b   : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_br_addr_po_sum : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_ex_mem_br_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ex_mem_br_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_b_sel : std_logic := '0';

  signal s_ex_mem_b_sel_pi_data : std_logic_vector(0 downto 0) := (others => '0');
  signal s_ex_mem_b_sel_po_data : std_logic_vector(0 downto 0) := (others => '0');

  signal s_pc_branch_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_rst_flush : std_logic := '0';

  signal s_ram_pi_adr       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ram_pi_ctrmem    : std_logic_vector(2 downto 0) := (others => '0');
  signal s_ram_pi_write     : std_logic := '0';
  signal s_ram_pi_read      : std_logic := '0';
  signal s_ram_pi_writedata : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ram_po_readdata  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_idmem_op2_pi_data  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_idmem_op2_po_data  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_ram_mem_wb_pi_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_ram_mem_wb_po_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_byp_rs1_sel : std_logic_vector(1 downto 0) := (others => '0');
  signal s_byp_rs2_sel : std_logic_vector(1 downto 0) := (others => '0');
  signal s_byp_rs1_mem : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_byp_rs2_mem : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_fwd_op1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_fwd_op2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  signal s_pc_adder_pi_b : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_stall : std_logic := '0';
  
  signal s_registersOut  : registermemory := (others => (others => '0'));
  -- signal s_instructions  : memory := (
  --  0  => x"00900093", -- ADDI x1 , x0 , 9
  --  1  => x"00800113", -- ADDI x2 , x0 , 8
  --  2  => x"0020e533", -- OR x10 , x1 , x2
  --  3  => x"00208433", -- ADD x8 , x1 , x2
  --  4  => x"402085b3", -- SUB x11 , x1 , x2
  --  5  => x"40110633", -- SUB x12 , x2 , x1
  --  6  => x"00810633", -- ADD x12 , x2 , x8
  --  7  => x"40110633", -- SUB x12 , x2 , x1
  --  8  => x"001170b3", -- AND x1 , x2 , x1
  --  9  => x"0020c633", -- XOR x12 , x1 , x2
  --  10 => x"000086b7", -- LUI x13 , 8
  --  11 => x"0001d6b7", -- LUI x13 , 29
  --  12 => x"00001717", -- AUIPC x14 , 1
  --  13 => x"00001717", -- AUIPC x14 , 1
  -- others => (others => '0')
  -- );
  
  signal s_instructions  : memory := (
    0 => x"00100093",
    1 => x"00000113",
    2 => x"00000193",
    3 => x"002081b3",
    4 => x"00100133",
    5 => x"003000b3",
    6 => x"ff5ff06f",
    others => (others => '0')
  );
  
  
  type seg_patterns_t is array (0 to 5) of std_logic_vector(6 downto 0); 
  signal seg_patterns : seg_patterns_t;
  
begin
  -- Generate - Schleife f ü r 6 Decoderinstanzen
  gen_decoder : for i in 0 to 5 generate
  decoder_inst : entity work.hex_7seg_decoder
  port map (
   bin_in => s_instr_cache_po_data((i *4 + 3) downto i*4),
   seg_out => seg_patterns(i)
  );
  end generate ;

  -- Zuweisung zu den HEX - Anzeigen
  HEX0 <= seg_patterns(0);
  HEX1 <= seg_patterns(1);
  HEX2 <= seg_patterns(2);
  HEX3 <= seg_patterns(3);
  HEX4 <= seg_patterns(4);
  HEX5 <= seg_patterns(5);

  s_rst <= not KEY(0);
  s_clk <= KEY(1);
  LEDR (7 downto 0) <= s_registersOut(to_integer(unsigned(SW(4 downto 0))))(7 downto 0);

  -- Flushin signal is set when the PC source is not the PC-Adder anymore
  -- -> this means that we are performing a jump
  -- -> all registers from id to ex (inclusive) are resetted 
  s_rst_flush <= s_rst or s_ex_mem_b_sel_po_data(0) or s_cwr_2_po_controlWord.PC_SEL;

---********************************************************************
---* program counter adder and pc-register
---********************************************************************
  pc_adder: entity work.gen_n_bit_full_adder 
            generic map(WORD_WIDTH) 
            port map(
              pi_a     => s_pc_adder_pi_a,
              pi_b     => s_pc_adder_pi_b,
              pi_carry => '0',
              po_sum   => s_pc_adder_po_sum,
              po_carry => open
            );
    s_pc_adder_pi_b <= ADD_FOUR_TO_ADDRESS when s_stall = '0' else ADD_ZERO_TO_ADDRESS;
      
  pc: entity work.pipeline_register 
      generic map(WORD_WIDTH) 
      port map(
        pi_clk  => s_clk,
        pi_rst  => s_rst,
        pi_data => s_pc_pi_data,
        po_data => s_pc_po_data,
        pi_flush => '0',
        pi_enable => not s_stall
      
      );
  
-- Mux for switching between Branch Target or PC Adder 
with s_ex_mem_b_sel_po_data select 
  s_pc_branch_mux <=
    s_pc_adder_po_sum   when "0",
    s_ex_mem_br_po_data when "1",
    (others => '0')     when others;

-- Mux for switching between ALU (mem) or PC Adder
with s_cwr_2_po_controlWord.PC_SEL select
  s_pc_pi_data <=
    s_pc_branch_mux      when '0',
    s_ex_mem_res_po_data when '1',
    (others => '0')      when others;

  -- s_pc_pi_data <= s_pc_adder_po_sum;
  s_pc_adder_pi_a <= s_pc_po_data;

-- Register for saving PC to EX Phase
pcex_1: entity work.pipeline_register
        generic map (WORD_WIDTH)
        port map (
          pi_clk => s_clk,
          pi_rst => s_rst_flush,
          pi_data => s_pcex_1_pi_data,
          po_data => s_pcex_1_po_data,
          pi_flush => s_stall,
          pi_enable => '1'
        );
s_pcex_1_pi_data <= s_pc_po_data;

pcex_2: entity work.pipeline_register
        generic map (WORD_WIDTH)
        port map (
          pi_clk => s_clk,
          pi_rst => s_rst_flush,
          pi_data => s_pcex_2_pi_data,
          po_data => s_pcex_2_po_data,
          pi_flush => open,
          pi_enable => '1'
        );
s_pcex_2_pi_data <= s_pcex_1_po_data;

---********************************************************************
---* instruction fetch 
---********************************************************************
instr_cache: entity work.instruction_cache
            generic map(WORD_WIDTH)
            port map(
              pi_adr => s_instr_cache_pi_adr,            
              pi_clk => not s_clk,             
              pi_rst => s_rst,             
              pi_instructionCache => s_instructions,
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
                  pi_rst => s_rst_flush,
                  pi_data => s_instr_cache_reg_pi_data,
                  po_data => s_instr_cache_reg_po_data,
                  pi_flush => '0',
                  pi_enable => not s_stall
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

sign_ex: entity work.sign_extension 
         port map ( 
            pi_instr => s_sign_ext_pi_instr,
            po_storeImm => s_sign_ext_po_storeImm,
            po_immediateImm => s_sign_ext_po_immediateImm,
            po_unsignedImm => s_sign_ext_po_unsignedImm,
            po_branchImm => s_sign_ext_po_branchImm,
            po_jumpImm => s_sign_ext_po_jumpImm
         );

s_sign_ext_pi_instr <= s_instr_cache_reg_po_data;

---********************************************************************
---* Pipeline-Register (ID -> EX) 
---********************************************************************
-- Pipeline Register for Control Word
cwr_1: entity work.control_word_register -- Ex Phase
       port map (
         pi_rst => s_rst_flush,
         pi_clk => s_clk,
         pi_controlWord => s_cwr_1_pi_controlWord,
         po_controlWord => s_cwr_1_po_controlWord,
         pi_flush => s_stall
       );

s_cwr_1_pi_controlWord <= s_dec_po_controlWord;

cwr_2: entity work.control_word_register -- Mem Phase
       port map (
         pi_rst => s_rst,
         pi_clk => s_clk,
         pi_controlWord => s_cwr_2_pi_controlWord,
         po_controlWord => s_cwr_2_po_controlWord,
         pi_flush => '0'
       );

s_cwr_2_pi_controlWord <= s_cwr_1_po_controlWord;

cwr_3: entity work.control_word_register -- Wb Phase
       port map (
         pi_rst => s_rst,
         pi_clk => s_clk,
         pi_controlWord => s_cwr_3_pi_controlWord,
         po_controlWord => s_cwr_3_po_controlWord,
         pi_flush => '0'
       );

s_cwr_3_pi_controlWord <= s_cwr_2_po_controlWord;

-- Pipeline Register for Addr of Destination Register 
-- Going from instruction to register file (3 registers)
idex_reg_1: entity work.pipeline_register 
                generic map(REG_ADR_WIDTH)
                port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst_flush,
                  pi_data => s_idex_reg_1_pi_data,
                  po_data => s_idex_reg_1_po_data,
                  pi_flush => s_stall,
                  pi_enable => '1'
                );

s_idex_reg_1_pi_data <= s_instr_cache_reg_po_data(11 downto 7);

idex_reg_2: entity work.pipeline_register 
                generic map(REG_ADR_WIDTH)
                port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst,
                  pi_data => s_idex_reg_2_pi_data,
                  po_data => s_idex_reg_2_po_data,
                  pi_flush => '0',
                  pi_enable => '1'
                );
s_idex_reg_2_pi_data <= s_idex_reg_1_po_data;


idex_reg_3: entity work.pipeline_register 
                generic map(REG_ADR_WIDTH)
                port map(
                  pi_clk => s_clk,
                  pi_rst => s_rst,
                  pi_data => s_idex_reg_3_pi_data,
                  po_data => s_idex_reg_3_po_data,
                  pi_flush => '0',
                  pi_enable => '1'
                );
s_idex_reg_3_pi_data <= s_idex_reg_2_po_data;


--
-- Load-Use Hazard Detection / Stalling
--

-- We detect a stall if
-- 1. In the EX Phase the cwr has MEM_READ=1
-- 2. RS1 or RS2 from ID Phase = RD in EX Phase
s_stall <= '1' 
  when (s_cwr_1_po_controlWord.MEM_READ = '1') 
  and ((s_idex_reg_1_po_data /= "00000") 
  and ((s_idex_reg_1_po_data = s_instr_cache_reg_po_data(19 downto 15)) or (s_idex_reg_1_po_data = s_instr_cache_reg_po_data(24 downto 20))))
  else '0';


--
-- FORWARDING
--

-- Selector for Forwarding rs1 / rs2 from different phases
-- s_instr_cache_reg_po_data(19 downto 15) -- rs1
-- s_instr_cache_reg_po_data(24 downto 20) -- rs2

s_byp_rs1_sel <= "01" when ( (s_instr_cache_reg_po_data(19 downto 15) = s_idex_reg_1_po_data) and (s_stall = '0') ) else -- ex 
                 "10" when ( s_instr_cache_reg_po_data(19 downto 15) = s_idex_reg_2_po_data )                       else -- mem
                 "11" when ( s_instr_cache_reg_po_data(19 downto 15) = s_idex_reg_3_po_data )                       else -- wb 
                 "00"; 

s_byp_rs2_sel <= "01" when ( (s_instr_cache_reg_po_data(24 downto 20) = s_idex_reg_1_po_data) and (s_stall = '0') ) else -- ex 
                 "10" when ( s_instr_cache_reg_po_data(24 downto 20) = s_idex_reg_2_po_data )                       else -- mem
                 "11" when ( s_instr_cache_reg_po_data(24 downto 20) = s_idex_reg_3_po_data )                       else -- wb 
                 "00";


-- Selector for choosing correct source (alu result or mem read)
-- s_ex_mem_res_po_data     -- alu result from mem phase
-- s_ram_po_readdata        -- ram result from mem phase

s_byp_rs1_mem <= s_ram_po_readdata 
  when (s_instr_cache_reg_po_data(19 downto 15) = s_idex_reg_2_po_data) and (s_cwr_2_po_controlWord.MEM_READ = '1') 
  else s_ex_mem_res_po_data;

s_byp_rs2_mem <= s_ram_po_readdata 
  when (s_instr_cache_reg_po_data(24 downto 20) = s_idex_reg_2_po_data) and (s_cwr_2_po_controlWord.MEM_READ = '1') 
  else s_ex_mem_res_po_data;


-- Selector for choosing direct pipeline or forwarded result

fwd_op1_mux: entity work.gen_mux_fto
             generic map (WORD_WIDTH)
             port map(
               pi_sel => s_byp_rs1_sel,
               pi_a => s_reg_file_po_readRegData1,   -- no forwarding
               pi_b => s_alu_out,                    -- forward from ex
               pi_c => s_byp_rs1_mem,                -- forward from mem
               pi_d => s_mem_wb_res_po_data,         -- forward from wb
               po_res => s_fwd_op1
             );

fwd_op2_mux: entity work.gen_mux_fto
             generic map (WORD_WIDTH)
             port map(
               pi_sel => s_byp_rs2_sel,
               pi_a => s_reg_file_po_readRegData2,   -- no forwarding
               pi_b => s_alu_out,                    -- forward from ex
               pi_c => s_byp_rs2_mem,                -- forward from mem
               pi_d => s_mem_wb_res_po_data,         -- forward from wb
               po_res => s_fwd_op2
             );



-- Pipeline Register for op1 from register file
idex_op1: entity work.pipeline_register 
           generic map (WORD_WIDTH)
           port map(
              pi_clk => s_clk,
              pi_rst => s_rst_flush,
              pi_data => s_idex_op1_pi_data,
              po_data => s_idex_op1_po_data,
              pi_flush => s_stall,
              pi_enable => '1'
           );
s_idex_op1_pi_data <= s_fwd_op1;

-- Pipeline Register for op2 from register file
idex_op2: entity work.pipeline_register 
           generic map (WORD_WIDTH)
           port map(
              pi_clk => s_clk,
              pi_rst => s_rst_flush,
              pi_data => s_idex_op2_pi_data,
              po_data => s_idex_op2_po_data,
              pi_flush => s_stall,
              pi_enable => '1'
           );
s_idex_op2_pi_data <= s_fwd_op2;


-- Sign Extender Pipeline Register
idex_se: entity work.pipeline_register
         generic map (WORD_WIDTH)
         port map(
            pi_clk => s_clk,
            pi_rst => s_rst_flush,
            pi_data => s_idex_sign_ex_pi_data,
            po_data => s_idex_sign_ex_po_data,
            pi_flush => s_stall,
            pi_enable => '1'
         );

-- Selection of Immediate from Sign Extender based on Opcode
with s_instr_cache_reg_po_data(6 downto 0) select
  s_idex_sign_ex_pi_data <= 
    s_sign_ext_po_immediateImm when I_INS_OP,
    s_sign_ext_po_unsignedImm  when LUI_INS_OP,
    s_sign_ext_po_unsignedImm  when AUIPC_INS_OP,
    s_sign_ext_po_jumpImm      when JAL_INS_OP,
    s_sign_ext_po_immediateImm when JALR_INS_OP,
    s_sign_ext_po_branchImm    when B_INS_OP,
    s_sign_ext_po_storeImm     when S_INS_OP,
    s_sign_ext_po_immediateImm when L_INS_OP,
    (others => '0')            when others;

---********************************************************************
---* execute phase
---********************************************************************

-- Mux for selecting between op2 from register file or immediate from sign extender
alu_imm_mux: entity work.gen_mux
             generic map (WORD_WIDTH)
             port map (
              pi_sel => s_alu_imm_op2_mux_pi_sel,
              pi_fst => s_alu_imm_op2_mux_pi_fst,
              pi_snd => s_alu_imm_op2_mux_pi_snd,
              po_res => s_alu_imm_op2_mux_po_res 
             );

s_alu_imm_op2_mux_pi_sel <= s_cwr_1_po_controlWord.I_IMM_SEL;
s_alu_imm_op2_mux_pi_fst <= s_idex_op2_po_data;
s_alu_imm_op2_mux_pi_snd <= s_idex_sign_ex_po_data;


-- Mux for selecting between rs1 or pc
with s_cwr_1_po_controlWord.A_SEL select
  s_alu_pi_op1 <=
    s_idex_op1_po_data when '0',
    s_pcex_2_po_data   when '1',
    (others => '0') when others;

-- alu (lol)
alu: entity work.alu
     generic map (WORD_WIDTH, ALU_OPCODE_WIDTH)
     port map(
       pi_op1 => s_alu_pi_op1,
       pi_op2 => s_alu_pi_op2,
       pi_alu_op => s_alu_pi_alu_op,
       po_alu_out => s_alu_out,
       po_carry_out => open,
       po_zero => s_alu_po_zero
     );
--s_alu_pi_op1 <= s_idex_op1_po_data;
s_alu_pi_op2 <= s_alu_imm_op2_mux_po_res;
s_alu_pi_alu_op <= s_cwr_1_po_controlWord.ALU_OP;


-- Adder to calculate PC+4 for JAL Instruction
ex_pc_add_4: entity work.gen_n_bit_full_adder 
             generic map(WORD_WIDTH) 
             port map(
               pi_a     => s_ex_pc_add_4_pi_a,
               pi_b     => ADD_FOUR_TO_ADDRESS,
               pi_carry => '0',
               po_sum   => s_ex_pc_add_4_po_sum,
               po_carry => open
             );
s_ex_pc_add_4_pi_a <= s_pc_po_data;      

-- Pipeline registers for feeding PC+4 result to WB Phase
ex_pcp4_1: entity work.pipeline_register
         generic map (WORD_WIDTH)
         port map (
           pi_clk => s_clk,
           pi_rst => s_rst_flush,
           pi_data => s_ex_pcp4_1_res_pi_data,
           po_data => s_ex_pcp4_1_res_po_data,
           pi_flush => '0',
           pi_enable => '1'
         );
s_ex_pcp4_1_res_pi_data <= s_ex_pc_add_4_po_sum;

ex_pcp4_2: entity work.pipeline_register
         generic map (WORD_WIDTH)
         port map (
           pi_clk => s_clk,
           pi_rst => s_rst_flush,
           pi_data => s_ex_pcp4_2_res_pi_data,
           po_data => s_ex_pcp4_2_res_po_data,
           pi_flush => '0',
           pi_enable => '1'
         );
s_ex_pcp4_2_res_pi_data <= s_ex_pcp4_1_res_po_data;

ex_pcp4_3: entity work.pipeline_register
         generic map (WORD_WIDTH)
         port map (
           pi_clk => s_clk,
           pi_rst => s_rst,
           pi_data => s_ex_pcp4_3_res_pi_data,
           po_data => s_ex_pcp4_3_res_po_data,
           pi_flush => '0',
           pi_enable => '1'
         );
s_ex_pcp4_3_res_pi_data <= s_ex_pcp4_2_res_po_data;

ex_pcp4_4: entity work.pipeline_register
         generic map (WORD_WIDTH)
         port map (
           pi_clk => s_clk,
           pi_rst => s_rst,
           pi_data => s_ex_pcp4_4_res_pi_data,
           po_data => s_ex_pcp4_4_res_po_data,
           pi_flush => '0',
           pi_enable => '1'
         );
s_ex_pcp4_4_res_pi_data <= s_ex_pcp4_3_res_po_data;

-- Adder for Branches: Add branch immediate to addr of instruction 
ex_br_addr: entity work.gen_n_bit_full_adder 
            generic map(WORD_WIDTH) 
            port map(
              pi_a     => s_ex_br_addr_pi_a,
              pi_b     => s_ex_br_addr_pi_b,
              pi_carry => '0',
              po_sum   => s_ex_br_addr_po_sum,
              po_carry => open
            );
s_ex_br_addr_pi_a <= s_idex_sign_ex_po_data;
s_ex_br_addr_pi_b <= s_pcex_2_po_data;

-- b-sel: Should we use our branch-imm + addr of instr as next PC value?
s_b_sel <= s_cwr_1_po_controlWord.IS_BRANCH and (s_alu_po_zero xor s_cwr_1_po_controlWord.CMP_RESULT);

---********************************************************************
---* Pipeline-Register (EX -> MEM) 
---********************************************************************
-- register for alu result -> mem phase
ex_mem_res: entity work.pipeline_register
            generic map (WORD_WIDTH)
            port map (
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_data => s_ex_mem_res_pi_data,
              po_data => s_ex_mem_res_po_data,
              pi_flush => '0',
              pi_enable => '1'
            );
s_ex_mem_res_pi_data <= s_alu_out;

-- register for branch target -> mem phase
ex_mem_br: entity work.pipeline_register
           generic map (WORD_WIDTH)
           port map (
             pi_clk => s_clk,
             pi_rst => s_rst,
             pi_data => s_ex_mem_br_pi_data,
             po_data => s_ex_mem_br_po_data,
             pi_flush => '0',
             pi_enable => '1'
           );
s_ex_mem_br_pi_data <= s_ex_br_addr_po_sum;

-- register for b-sel -> mem phase 
ex_mem_b_sel: entity work.pipeline_register
              generic map (1)
              port map (
                pi_clk => s_clk,
                pi_rst => s_rst,
                pi_data => s_ex_mem_b_sel_pi_data,
                po_data => s_ex_mem_b_sel_po_data,
                pi_flush => '0',
                pi_enable => '1'
              );

s_ex_mem_b_sel_pi_data(0) <=s_b_sel; 

---********************************************************************
---* memory phase
---********************************************************************

ram: entity work.data_memory
     generic map (WORD_WIDTH)
     port map (
       pi_adr             => s_ram_pi_adr,
       pi_clk             => not s_clk,
       pi_rst             => s_rst,
       pi_ctrmem          => s_ram_pi_ctrmem,
       pi_write           => s_ram_pi_write,
       pi_read            => s_ram_pi_read,
       pi_writedata       => s_ram_pi_writedata,      
       po_readdata        => s_ram_po_readdata,
       po_debugdatamemory => open
     );

    s_ram_pi_writedata <= s_idmem_op2_po_data;
    s_ram_pi_adr <= s_ex_mem_res_po_data;
    s_ram_pi_ctrmem <= s_cwr_2_po_controlWord.MEM_CTR;
    s_ram_pi_read <= s_cwr_2_po_controlWord.MEM_READ;
    s_ram_pi_write <= s_cwr_2_po_controlWord.MEM_WRITE;

-- Registers for Read Operand 2 of Register file
-- Store the read value from the decode phase until the memory phase 
idmem_op2: entity work.pipeline_register 
           generic map (WORD_WIDTH)
           port map(
              pi_clk =>  s_clk,
              pi_rst =>  s_rst,
              pi_data => s_idmem_op2_pi_data,
              po_data => s_idmem_op2_po_data,
              pi_flush => '0',
              pi_enable => '1'
           );
s_idmem_op2_pi_data <= s_idex_op2_po_data;

---********************************************************************
---* Pipeline-Register (MEM -> WB) 
---********************************************************************
mem_wb_res: entity work.pipeline_register
            generic map (WORD_WIDTH)
            port map (
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_data => s_mem_wb_res_pi_data,
              po_data => s_mem_wb_res_po_data,
              pi_flush => '0',
              pi_enable => '1'
            );
s_mem_wb_res_pi_data <= s_ex_mem_res_po_data;

-- Pipline Register for output of memory, save for WB Phase
ram_mem_wb: entity work.pipeline_register 
           generic map (WORD_WIDTH)
           port map(
              pi_clk =>  s_clk,
              pi_rst =>  s_rst,
              pi_data => s_ram_mem_wb_pi_data,
              po_data => s_ram_mem_wb_po_data,
              pi_flush => '0',
              pi_enable => '1'
           );
s_ram_mem_wb_pi_data <= s_ram_po_readdata;

---********************************************************************
---* write back phase
---********************************************************************

-- Register for Immediate -> Writeback Phase
imwb_1: entity work.pipeline_register
        generic map (WORD_WIDTH)
        port map (
          pi_clk => s_clk,
          pi_rst => s_rst,
          pi_data => s_imwb_1_pi_data,
          po_data => s_imwb_1_po_data,
          pi_flush => '0',
          pi_enable => '1'
        );

s_imwb_1_pi_data <= s_idex_sign_ex_po_data;

imwb_2: entity work.pipeline_register
        generic map (WORD_WIDTH)
        port map (
          pi_clk => s_clk,
          pi_rst => s_rst,
          pi_data => s_imwb_2_pi_data,
          po_data => s_imwb_2_po_data,
          pi_flush => '0',
          pi_enable => '1'
        );

s_imwb_2_pi_data <= s_imwb_1_po_data;


-- MUX for select the correct result for WB
with s_cwr_3_po_controlWord.WB_SEL select
  s_reg_file_pi_writeRegData <=
    s_mem_wb_res_po_data      when "00", -- ALU 
    s_imwb_2_po_data          when "01", -- Immediate
    s_ex_pcp4_4_res_po_data   when "10", -- PC + 4
    s_ram_mem_wb_po_data  when "11", -- Memory
    (others => '0') when others;


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
            po_registerOut  => s_registersOut
          );

s_reg_file_pi_readRegAddr1 <= s_instr_cache_reg_po_data(19 downto 15);
s_reg_file_pi_readRegAddr2 <= s_instr_cache_reg_po_data(24 downto 20);
s_reg_file_pi_writeRegAddr <= s_idex_reg_3_po_data;
-- s_reg_file_pi_writeRegData <= s_mem_wb_res_po_data;
s_reg_file_pi_writeEnable  <= s_cwr_3_po_controlWord.REG_WRITE;  

end architecture;



