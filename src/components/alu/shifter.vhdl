-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.constant_package.ALL;

entity shifter is
    generic(
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port(
        pi_op1, pi_op2              : in  STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0) := (others => '0');

        pi_shift_type, pi_shift_dir : in  std_logic := '0';
        po_res                      : out STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0) := (others => '0')
    );
end entity;

architecture behavior of shifter is
    signal s_sham_int : integer range 0 to (2**(integer(log2(real(G_DATA_WIDTH)))));
    signal s_sign_fill : std_logic_vector(G_DATA_WIDTH-1 downto 0);
    signal s_logic_shift : std_logic_vector(G_DATA_WIDTH-1 downto 0);
    signal s_arith_shift : std_logic_vector(G_DATA_WIDTH-1 downto 0);
   begin
       s_sham_int <= to_integer(unsigned(pi_op2(integer(log2(real(G_DATA_WIDTH))) - 1 downto 0)));

        -- s_zero_fill <= (others => '0');
        -- s_shift_left <= pi_op1((G_DATA_WIDTH-1-s_sham_int) downto 0) & s_zero_fill(s_sham_int-1 downto 0) when (s_sham_int > 0 and s_sham_int < G_DATA_WIDTH) else
        --        pi_op1 when (s_sham_int <= 0) else
        --         (others => '0');
        -- s_shift_right <= s_zero_fill(s_sham_int-1 downto 0) & pi_op1((G_DATA_WIDTH-1) downto s_sham_int) when (s_sham_int > 0 and s_sham_int < G_DATA_WIDTH) else
        --          pi_op1 when (s_sham_int <= 0) else
        --          (others => '0');

        with pi_shift_dir select
            s_logic_shift <=
            std_logic_vector(shift_left(unsigned(pi_op1), s_sham_int))  when '0',
            std_logic_vector(shift_right(unsigned(pi_op1), s_sham_int)) when '1',
            (others => '0')                                             when others;

        s_sign_fill <= (others => pi_op1(G_DATA_WIDTH-1));
        s_arith_shift <= (s_sign_fill(s_sham_int-1 downto 0) & pi_op1((G_DATA_WIDTH-1) downto s_sham_int)) 
            when (pi_shift_type = '1' and s_sham_int > 0 and s_sham_int < G_DATA_WIDTH)
            else pi_op1;

        with pi_shift_type select
            po_res <= 
                s_logic_shift   when '0',
                s_arith_shift   when '1',
                (others => '0') when others;
end architecture behavior;
