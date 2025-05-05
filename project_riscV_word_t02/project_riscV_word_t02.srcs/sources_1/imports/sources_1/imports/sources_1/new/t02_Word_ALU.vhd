----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2024 17:28:30
-- Design Name: 
-- Module Name: t02_Word_ALU - bhvrl_ALU
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.package_top.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity t02_Word_ALU is
    Generic(
        opcodemax_inbit : integer :=2--daha sonrasý için control ünit ten sadec ebelirli codlarý alan bir hat çýkarýp öyle kontrol et 
    );
    Port(
        --alu_opcode : in std_logic_vector(opcodemax_inbit downto 0);
        opcode  : in std_logic_vector(6 downto 0) ;
        f7      : in std_logic_vector(6 downto 0) ;
        f3      : in std_logic_vector(2 downto 0) ;
        alu_data_in0 : in  std_logic_vector(RV_lvlinbit-1 downto 0) ;
        alu_data_in1 : in  std_logic_vector(RV_lvlinbit-1 downto 0) ;
        
        alu_flag : out std_logic_vector(2 downto 0) := (others=>'0') ; -- MSB overflow | zero LSB  | brnch active 
        
        alu_data_out : out std_logic_vector(RV_lvlinbit-1 downto 0) := (others=>'0') 
    );
end t02_Word_ALU;

architecture bhvrl_ALU of t02_Word_ALU is

--signal one  : std_logic_vector(RV_lvlinbit-1 downto 0) := (others=> '1');
shared variable new_limit  :std_logic_vector(31 downto 0) ;
begin

process ( alu_data_in0 , alu_data_in1 , opcode , f7 , f3 ) begin
    
    if (opcode = R_typeop) then
        alu_flag(0) <= '0'; -- (activate branch )pasif
        case ( f3 ) is
            when "000" => --add sub
                if (f7(5) = '0') then 
                    alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
                else
                    alu_data_out <= std_logic_vector( signed( alu_data_in0) - signed( alu_data_in1 ) );
                end if ;
            when "001" => --sll
                    alu_data_out <= std_logic_vector( signed( alu_data_in0) sll to_integer(signed( alu_data_in1 )) );
            when "010" =>--slt
                if ( signed( alu_data_in0) < signed( alu_data_in1 ) ) then 
                    alu_data_out <= (X"00000001");
                else 
                    alu_data_out <= (X"00000000");
                end if ;
            when "011" =>--sltu
                if ( unsigned( alu_data_in0) < unsigned( alu_data_in1 ) ) then 
                    alu_data_out <= (X"00000001");
                else 
                    alu_data_out <= (X"00000000");
                end if ;
            when "100" =>--xor
                alu_data_out <=  alu_data_in0 xor alu_data_in1 ;
            when "101" =>--srl sra
                if (f7(5) = '0') then 
                    alu_data_out <= std_logic_vector( signed( alu_data_in0) srl to_integer(signed( alu_data_in1 )) );
                    --ToDo fix sra
                else
                    --alu_data_out <= std_logic_vector( signed( alu_data_in0) sra srl to_integer(signed( alu_data_in1 )) );
                end if ;
            when "110" =>--or
                alu_data_out <=  alu_data_in0 or alu_data_in1 ;
            when "111" =>--and
                alu_data_out <=  alu_data_in0 and alu_data_in1 ;
            when others =>
                alu_data_out <=  (others => others_case) ;
        end case;
        
        
    elsif (opcode = I_typeop_reg) then --to do regi iile imidiate_reg birleþtirilebilir mi ? 
        alu_flag(0) <= '0'; -- (activate branch )pasif
        case ( f3 ) is
            when "000" => --addi
                alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
            when "010" =>--slti
                if ( signed( alu_data_in0) < signed( alu_data_in1 ) ) then 
                    alu_data_out <= (X"00000001");
                else 
                    alu_data_out <= (X"00000000");
                end if ;
            when "011" =>--sltiu
                if ( unsigned( alu_data_in0) < unsigned( alu_data_in1 ) ) then 
                    alu_data_out <= (X"00000001");
                else 
                    alu_data_out <= (X"00000000");
                end if ;
            when "100" =>--xori
                alu_data_out <=  alu_data_in0 xor alu_data_in1 ;
            when "110" =>--ori
                alu_data_out <=  alu_data_in0 or alu_data_in1 ;
            when "111" =>--andi
                alu_data_out <=  alu_data_in0 and alu_data_in1 ;
            when "001" => --slli
                alu_data_out <= std_logic_vector( unsigned( alu_data_in0) sll to_integer(unsigned( alu_data_in1 )) );
            when "101" =>--srli srai
                if (f7(5) = '0') then 
                    alu_data_out <= std_logic_vector( unsigned( alu_data_in0) srl to_integer(unsigned( alu_data_in1 )) );
       --             to do fix sra
--                else
--                    if (alu_data_in0(RV_lvlinbit -1 ) = '0') then
--                        alu_data_out <= std_logic_vector( unsigned( alu_data_in0) srl to_integer(unsigned( alu_data_in1 )) );
--                    elsif (alu_data_in0(RV_lvlinbit -1 ) = '1') then
                    
--                        new_limit:= std_logic_vector( 31 - unsigned( alu_data_in1 ) );
--                        alu_data_out <=  one( 31 downto to_integer(unsigned(new_limit) ) ) &  alu_data_in0( 30 downto to_integer(unsigned(alu_data_in1)) );
                        
--                    end if ;
                end if ;
            when others =>
                alu_data_out <=  (others => others_case) ;
        end case;
        
        
    elsif (opcode = I_typeop_dm) then 
        alu_flag(0) <= '0'; -- (activate branch )pasif
        case ( f3 ) is
            when "000" =>--lb
                alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) ); -- reg0 + / imm12 |reg1 /
            when "001" =>--lh
                alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
            when "010" =>--lw
                alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
            when "100" =>--lbu
                alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
            when "101" =>--lhu
                alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
            when others =>
                alu_data_out <=  (others => others_case) ;
        end case ;
    elsif (opcode = B_typeop) then --alu_flag-- MSB overflow | zero LSB  | <brnch active> 
        alu_data_out <=  (others => others_case) ;
        case ( f3 ) is
            when "000" =>--beq
                if ( alu_data_in0 = alu_data_in1 )then
                alu_flag(0) <= '1'; 
                else 
                alu_flag(0) <= '0'; 
                end if ;
            when "001" =>--bne
                if ( alu_data_in0 /= alu_data_in1 )then
                alu_flag(0) <= '1'; 
                else 
                alu_flag(0) <= '0'; 
                end if ; 
            when "100" =>--blt
                if ( signed( alu_data_in0) < signed( alu_data_in1)  )then
                alu_flag(0) <= '1'; 
                else 
                alu_flag(0) <= '0'; 
                end if ;
            when "101" =>--bge
                if ( signed( alu_data_in0) > signed( alu_data_in1)  )then
                alu_flag(0) <= '1'; 
                else 
                alu_flag(0) <= '0'; 
                end if ;
            when "110" =>--bltu
                if ( unsigned( alu_data_in0) < unsigned( alu_data_in1)  )then
                alu_flag(0) <= '1'; 
                else 
                alu_flag(0) <= '0'; 
                end if ;
            when "111" =>--bgeu
                if ( unsigned( alu_data_in0) > unsigned( alu_data_in1)  )then
                alu_flag(0) <= '1'; 
                else 
                alu_flag(0) <= '0'; 
                end if ;
            when others =>
                alu_flag(0) <= '0'; 
        end case ;
    elsif (opcode = S_typeop) then 
        alu_flag(0) <= '0';-- (activate branch )pasif
        case ( f3 ) is
            when "000" =>--sb
                alu_data_out <= std_logic_vector( unsigned( alu_data_in0) + unsigned( alu_data_in1 ) ); -- reg0 + / imm12 |reg1 /
            when "001" =>--sh
                alu_data_out <= std_logic_vector( unsigned( alu_data_in0) + unsigned( alu_data_in1 ) );
            when "010" =>--sw
                alu_data_out <= std_logic_vector( unsigned( alu_data_in0) + unsigned( alu_data_in1 ) );
            when others =>
                alu_data_out <=  (others => others_case) ;
        end case ;
    elsif (opcode = lui_typeop) then 
        alu_data_out <= alu_data_in1;
    elsif (opcode = auipc_typeop) or (opcode = J_typeop_l) or (opcode = J_typeop_lr) then 
        alu_data_out <= std_logic_vector( signed( alu_data_in0) + signed( alu_data_in1 ) );
    
    
    
    
    
    
    
--    else if (opcode = J_typeop) then 
--        case ( f3 ) is
--            when "000" =>--
--                <statement>;
--            when "001" =>--
--                <statement>;
--            when "010" =>--
--                <statement>;
--            when "100" =>--
--                <statement>;
--            when "101" =>--
--                <statement>;
--            when others =>
--                <statement>;
--        end case ;
    end if ;    
    
end process ;

end bhvrl_ALU;
