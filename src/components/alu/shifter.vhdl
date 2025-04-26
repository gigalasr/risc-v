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
    signal s_shamtInt : integer range 0 to (2**(integer(log2(real(G_DATA_WIDTH)))));
    signal s_fill : std_logic_vector(G_DATA_WIDTH -1 downto 0) := (others => '0');
    signal s_sign_bit : std_logic := '0';
   begin
       s_shamtInt <= to_integer( unsigned(pi_op2(integer(log2(real(G_DATA_WIDTH))) - 1 downto 0)));

       process (pi_op1, pi_op2, pi_shift_type, pi_shift_dir, s_fill, s_sign_bit, s_shamtInt)
       begin
           case pi_shift_type is
               when '0' => 
                s_fill <= (others => '0');
                case pi_shift_dir is
                    when '0' => 
                    if (s_shamtInt <= 0) then
                        po_res <= pi_op1;
                    elsif (s_shamtInt < G_DATA_WIDTH) then
                        po_res <= pi_op1((G_DATA_WIDTH - 1) - s_shamtInt downto 0) & s_fill(s_shamtInt -1 downto 0);
                    end if;
                        when '1' => 
                    if (s_shamtInt <= 0) then
                        po_res <= pi_op1;
                    elsif (s_shamtInt < G_DATA_WIDTH) then
                        po_res <= s_fill(s_shamtInt -1 downto 0) & pi_op1((G_DATA_WIDTH - 1) downto s_shamtInt);
                    end if;
                        when others => po_res <= (others => '0');
               end case;
               when '1' => 
                s_sign_bit <= pi_op1(G_DATA_WIDTH - 1);
                s_fill <= (others => s_sign_bit);
                if (s_shamtInt <= 0) then
                    po_res <= pi_op1;
                elsif (s_shamtInt < G_DATA_WIDTH) then
                    po_res <= s_fill(s_shamtInt -1 downto 0) & pi_op1((G_DATA_WIDTH -1) downto s_shamtInt);
                end if;
               when others => po_res <= (others => '0');
            end case;
        end process;
end architecture behavior;
