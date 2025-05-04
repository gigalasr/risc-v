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

entity single_port_ram_tb is
end single_port_ram_tb;

architecture behaviour of single_port_ram_tb is
    constant WORD_WIDTH : integer := 16;
    constant ADDR_WIDTH : integer := 5;

    signal s_in_clk  : std_logic := '0';
    signal s_in_rst  : std_logic := '0';
    signal s_in_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal s_in_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_in_we   : std_logic := '0';

    signal s_out_data : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Do not convert to ASCII, worst mistake of my life
    type mem is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0);
    signal s_expected_mem : mem := (
        0 =>  B"01001110_01100101",
        1 =>  B"01110110_01100101",
        2 =>  B"01110010_00100000",
        3 =>  B"01100111_01101111",
        4 =>  B"01101110_01101110",
        5 =>  B"01100001_00100000",
        6 =>  B"01100111_01101001",
        7 =>  B"01110110_01100101",
        8 =>  B"00100000_01111001",
        9 =>  B"01101111_01110101",
        10 => B"00100000_01110101",
        11 => B"01110000_00101100",
        12 => B"00100000_01101110",
        13 => B"01100101_01110110",
        14 => B"01100101_01110010",
        15 => B"00100000_01100111",
        16 => B"01101111_01101110",
        17 => B"01101110_01100001",
        18 => B"00100000_01101100",
        19 => B"01100101_01110100",
        20 => B"00100000_01111001",
        21 => B"01101111_01110101",
        22 => B"00100000_01100100",
        23 => B"01101111_01110111",
        24 => B"01101110_00001010",
        25 => B"01001110_01100101",
        26 => B"01110110_01100101",
        27 => B"01110010_00100000",
        28 => B"01100111_01101111",
        29 => B"01101110_01101110",
        30 => B"01100001_00100000",
        31 => B"01110010_01110101",
        others => (others => '0')
    );
begin
    RAM: entity work.single_port_ram 
         generic map (WORD_WIDTH, ADDR_WIDTH) 
         port map(s_in_clk, s_in_rst, s_in_addr, s_in_data, s_in_we, s_out_data);

    process begin
        -- Reset everything
        s_in_rst <= '1';
        wait for 1 ns;

        s_in_rst <= '0';
        wait for 1 ns;

        -- Write without pi_we enabled 
        s_in_we <= '0';
        for i in s_expected_mem'range loop
            s_in_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            s_in_data <= s_expected_mem(i);

            s_in_clk <= '0'; wait for 1 ns;
            s_in_clk <= '1'; wait for 1 ns;
            s_in_clk <= '0'; wait for 1 ns;
            s_in_clk <= '1'; wait for 1 ns;

            assert s_out_data = B"00000000_00000000" report "wrote data without WRITE_ENABLED=1" severity failure;
        end loop;

        -- Write with pi_we enabled, but without clock 
        s_in_we <= '1';
        s_in_clk <= '0';
        wait for 1 ns;
        for i in s_expected_mem'range loop
            s_in_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            s_in_data <= s_expected_mem(i);
            wait for 1 ns;
            assert s_out_data = B"00000000_00000000" report "wrote data without CLK" severity failure;
        end loop;

        -- Write with pi_we enabled and clk
        s_in_we <= '1';
        s_in_clk <= '0';
        wait for 1 ns;
        for i in s_expected_mem'range loop
            s_in_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            s_in_data <= s_expected_mem(i);

            s_in_clk <= '0'; wait for 1 ns;
            s_in_clk <= '1'; wait for 1 ns;
            
            assert s_out_data = B"00000000_00000000" report "wrote data before rising edge" severity failure;
            
            s_in_clk <= '0'; wait for 1 ns;
            assert s_out_data = B"00000000_00000000" report "wrote data on falling edge" severity failure;
            s_in_clk <= '1'; wait for 1 ns;

            assert s_out_data = s_expected_mem(i) report "did not write data on rising edge" severity failure;
        end loop;

        -- disable we
        s_in_we <= '0';
        s_in_clk <= '0'; wait for 1 ns;

        -- check written data
        for i in s_expected_mem'range loop
            s_in_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            s_in_data <= s_expected_mem(i);

            s_in_clk <= '0'; wait for 1 ns;
            s_in_clk <= '1'; wait for 1 ns;

            assert s_out_data = s_expected_mem(i) report "written data did not persist" severity failure;
        end loop;

        -- Reset everything
        s_in_rst <= '1'; wait for 1 ns;
        s_in_rst <= '0'; wait for 1 ns;
        
        for i in s_expected_mem'range loop
            s_in_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));

            s_in_clk <= '0'; wait for 1 ns;
            s_in_clk <= '1'; wait for 1 ns;

            assert s_out_data = B"00000000_00000000" report "did not reset" severity failure;
        end loop;


        assert false report "end of test" severity note;
        wait;
    end process;
     
end behaviour;