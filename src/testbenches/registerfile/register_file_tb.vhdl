-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.constant_package.ALL;
use work.utility_package.ALL;

entity register_file_tb is
end register_file_tb;

architecture behaviour of register_file_tb is
    constant WORD_WIDTH : integer := 32;
    constant ADDR_WIDTH : integer := 5;
    constant TEST_CASES : integer := 2;

    type int_array_t is array (0 to TEST_CASES - 1) of integer; 
    constant SIZES : int_array_t := (16, 32); 

    type logic_t    is array (0 to TEST_CASES - 1) of std_logic; 
    type addr_vec_t is array (0 to TEST_CASES - 1) of std_logic_vector(ADDR_WIDTH - 1 downto 0);
    type word_vec_t is array (0 to TEST_CASES - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0);  


    signal s_in_clk  : logic_t := (others => '0');
    signal s_in_rst  : logic_t := (others => '0');

    signal s_in_readRegAddr1 : addr_vec_t := (others => (others => '0'));
    signal s_in_readRegAddr2 : addr_vec_t := (others => (others => '0'));

    signal s_in_writeRegAddr : addr_vec_t := (others => (others => '0'));
    signal s_in_writeRegData : word_vec_t := (others => (others => '0'));
    signal s_in_writeEnable  : logic_t := (others => '0');

    signal s_out_readRegData1 : word_vec_t := (others => (others => '0'));
    signal s_out_readRegData2 : word_vec_t := (others => (others => '0'));

    -- Do not convert to ASCII, worst mistake of my life
    type mem is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0);
    signal s_expected_mem : mem := (
        0 =>  B"01001110_01100101_01001110_01100101",
        1 =>  B"01110110_01100101_01110110_01100101",
        2 =>  B"01110010_00100000_01110010_00100000",
        3 =>  B"01100111_01101111_01100111_01101111",
        4 =>  B"01101110_01101110_01101110_01101110",
        5 =>  B"01100001_00100000_01100001_00100000",
        6 =>  B"01100111_01101001_01100111_01101001",
        7 =>  B"01110110_01100101_01110110_01100101",
        8 =>  B"00100000_01111001_00100000_01111001",
        9 =>  B"01101111_01110101_01101111_01110101",
        10 => B"00100000_01110101_00100000_01110101",
        11 => B"01110000_00101100_01110000_00101100",
        12 => B"00100000_01101110_00100000_01101110",
        13 => B"01100101_01110110_01100101_01110110",
        14 => B"01100101_01110010_01100101_01110010",
        15 => B"00100000_01100111_00100000_01100111",
        16 => B"01101111_01101110_01101111_01101110",
        17 => B"01101110_01100001_01101110_01100001",
        18 => B"00100000_01101100_00100000_01101100",
        19 => B"01100101_01110100_01100101_01110100",
        20 => B"00100000_01111001_00100000_01111001",
        21 => B"01101111_01110101_01101111_01110101",
        22 => B"00100000_01100100_00100000_01100100",
        23 => B"01101111_01110111_01101111_01110111",
        24 => B"01101110_00001010_01101110_00001010",
        25 => B"01001110_01100101_01001110_01100101",
        26 => B"01110110_01100101_01110110_01100101",
        27 => B"01110010_00100000_01110010_00100000",
        28 => B"01100111_01101111_01100111_01101111",
        29 => B"01101110_01101110_01101110_01101110",
        30 => B"01100001_00100000_01100001_00100000",
        31 => B"01110010_01110101_01110010_01110101",
        others => (others => '0')
    );

begin
    GEN: for n in 0 to 1 generate
    RAM: entity work.register_file 
         generic map (word_width => SIZES(n), addr_width => 5) 
         port map(
            pi_clk => s_in_clk(n), 
            pi_rst => s_in_rst(n), 
            pi_readRegAddr1 => s_in_readRegAddr1(n),
            pi_readRegAddr2 => s_in_readRegAddr2(n), 
            pi_writeRegAddr => s_in_writeRegAddr(n), 
            pi_writeRegData => s_in_writeRegData(n)(SIZES(n) - 1 downto 0), 
            pi_writeEnable => s_in_writeEnable(n), 
            po_readRegData1 => s_out_readRegData1(n)(SIZES(n) - 1 downto 0), 
            po_readRegData2 => s_out_readRegData2(n)(SIZES(n) - 1 downto 0));

    process begin
        report "Gen(" & INTEGER'image(SIZES(n)) & ")";

        -- Reset Test 
        s_in_rst(n) <= '1'; wait for 1 ns;
        s_in_rst(n) <= '0'; wait for 1 ns;  
        for i in s_expected_mem'range loop
            s_in_readRegAddr1(n) <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            
            s_in_clk(n) <= '0'; wait for 1 ns;
            s_in_clk(n) <= '1'; wait for 1 ns;

            assert s_out_readRegData1(n) = B"00000000_00000000_00000000_00000000" report "did not reset" severity failure;
        end loop;

        -- Write Test without Write Enable
        s_in_rst(n) <= '1'; wait for 1 ns;
        s_in_rst(n) <= '0'; wait for 1 ns;  
        s_in_writeEnable(n) <= '0'; wait for 1 ns;
        for i in 0 to 31 loop
            s_in_writeRegAddr(n) <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));

            s_in_clk(n) <= '0'; wait for 1 ns;
            s_in_clk(n) <= '1'; wait for 1 ns;

            assert s_out_readRegData1(n) = B"00000000_00000000_00000000_00000000" report "wrote without write enable" severity failure;
        end loop;

        -- Write Test 
        s_in_rst(n) <= '1'; wait for 1 ns;
        s_in_rst(n) <= '0'; wait for 1 ns;  
        for i in 1 to 31 loop
            s_in_writeRegAddr(n) <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            s_in_writeRegData(n)(SIZES(n) - 1 downto 0) <= s_expected_mem(i)(SIZES(n) - 1 downto 0);

            s_in_writeEnable(n) <= '1'; wait for 1 ns;
            s_in_clk(n) <= '0'; wait for 1 ns;
            s_in_clk(n) <= '1'; wait for 1 ns;
            s_in_writeEnable(n) <= '0'; wait for 1 ns;

            s_in_writeRegData(n) <= (others => '0');
            s_in_writeRegAddr(n) <= (others => '0');

            s_in_readRegAddr1(n) <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            s_in_writeEnable(n) <= '0'; wait for 1 ns;
            s_in_clk(n) <= '0'; wait for 1 ns;
            s_in_clk(n) <= '1'; wait for 1 ns;

            assert (s_out_readRegData1(n)(SIZES(n) - 1 downto 0)) = (s_expected_mem(i)(SIZES(n) - 1 downto 0)) report "did not write" severity failure;
        end loop;

        -- Read Test
        for i in 1 to 30 loop
            s_in_readRegAddr1(n) <= std_logic_vector(to_unsigned(i,     ADDR_WIDTH));
            s_in_readRegAddr2(n) <= std_logic_vector(to_unsigned(i + 1, ADDR_WIDTH)); 

            s_in_clk(n) <= '0'; wait for 1 ns;
            s_in_clk(n) <= '1'; wait for 1 ns;

            assert (s_out_readRegData1(n)(SIZES(n) - 1 downto 0)) = (s_expected_mem(i    )(SIZES(n) - 1 downto 0)) report "read failed" severity failure;
            assert (s_out_readRegData2(n)(SIZES(n) - 1 downto 0)) = (s_expected_mem(i + 1)(SIZES(n) - 1 downto 0)) report "read failed" severity failure;
        end loop;

        wait;
    end process;
    assert false report "end of test" severity note;
end generate;
end behaviour;