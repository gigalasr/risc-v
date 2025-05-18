-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Lars Pfrenger
-- 2. Participant First and Last Name: Rouven Schönigt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;
use std.textio.all;

package utility_package is
    function toi(vec : std_logic_vector) return integer;

    procedure print_instr(instr : std_logic_vector(31 downto 0); mem : registermemory);
    procedure print_mem(mem : registermemory);

end package utility_package;

package body utility_package is
    function toi(vec : std_logic_vector) return integer is
    begin
        return to_integer(unsigned(vec));
    end function;

    procedure print_mem(mem : registermemory) is begin
        for i in 0 to 31 loop
            if(toi(mem(i)) /= 0) then
                write(output, "[" &  integer'image(i) & "]: " & integer'image(toi(mem(i))) & LF);
            end if;
        end loop;
    end procedure;


    procedure print_instr(instr : std_logic_vector(31 downto 0); mem : registermemory) is 
        variable aluop : std_logic_vector(3 downto 0);
    begin
        case instr(6 downto 0) is 
            when R_INS_OP =>
                write(output, "R-Format (");
                aluop(3) := instr(30);
                aluop(2 downto 0) := instr(14 downto 12);

                write(output, "rs2: [" & integer'image(toi(instr(24 downto 20))) & "] = " & integer'image(toi(mem(toi(instr(24 downto 20))))) & ", ");
                write(output, "rs1: [" & integer'image(toi(instr(19 downto 15))) & "] = " & integer'image(toi(mem(toi(instr(19 downto 15))))) & ", ");
                write(output, "rd: [" & integer'image(toi(instr(11 downto 7)))  & "] = " & integer'image(toi(mem(toi(instr(11 downto 7))))) & ", ");
                
                write(output, "aluop: ");
                case aluop is
                    when AND_ALU_OP => write(output, "AND" );
                    when XOR_ALU_OP => write(output, "XOR" );
                    when OR_ALU_OP => write(output, "OR"   );
                    when SLL_ALU_OP => write(output, "SLL" );
                    when SRL_ALU_OP => write(output, "SRL" );
                    when SRA_ALU_OP => write(output, "SRA" );
                    when ADD_ALU_OP => write(output, "ADD" );
                    when SUB_ALU_OP => write(output, "SUB" );
                    when others =>  write(output, "UNKNOWN");
                end case;
                write(output, ")" & LF);
            when others =>
                write(output, "Unknown Opcode" & LF);
        end case;

    end procedure;
end package body utility_package;