----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2024 23:09:03
-- Design Name: 
-- Module Name: t02_Word_immGen - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity t02_Word_immGen is
    Port (
    opcode  : in std_logic_vector(6 downto 0) ;
    imm12 : in std_logic_vector(11 downto 0); 
    imm20 : in std_logic_vector(19 downto 0); 
    IMM_out : out std_logic_vector(RV_lvlinbit-1  downto 0) 
    );
end t02_Word_immGen;

architecture bhvrl_immGen of t02_Word_immGen is
constant zero : std_logic_vector(RV_lvlinbit-1 downto 0) := (others=> '0');
constant one  : std_logic_vector(RV_lvlinbit-1 downto 0) := (others=> '1');
begin
--signed
process ( imm12 , imm20 , opcode ) begin
    if(opcode = I_typeop_reg or opcode = I_typeop_dm) or (opcode = J_typeop_lr) then
        if (imm12(11)='1') then
            IMM_out <=  one(RV_lvlinbit-1 downto 12) & imm12 ; 
        else
            IMM_out <=  zero(RV_lvlinbit-1 downto 12) & imm12 ; 
        end if ;
    elsif (opcode = B_typeop) then 
        if (imm12(11)='1') then
            IMM_out <=  one(RV_lvlinbit-1 downto 13) & imm12 & '0' ; 
        else
            IMM_out <=  zero(RV_lvlinbit-1 downto 13) & imm12 & '0' ; 
        end if ;
    elsif (opcode = S_typeop) then 
        if (imm12(11)='1') then
            IMM_out <=  one(RV_lvlinbit-1 downto 12) & imm12 ; 
        else
            IMM_out <=  zero(RV_lvlinbit-1 downto 12) & imm12 ; 
        end if ;
    elsif (opcode = lui_typeop) then 
            IMM_out <=  imm20 & zero(11 downto 0) ; 
    
    elsif (opcode = auipc_typeop) then 
            IMM_out <=  imm20 & zero(11 downto 0) ; 
    elsif (opcode = J_typeop_l) then 
        if (imm20(19)='1') then
            IMM_out <=  one(RV_lvlinbit-1 downto 20) & imm20 ; 
        else
            IMM_out <=  zero(RV_lvlinbit-1 downto 20) & imm20 ; 
        end if ;
    end if ;
    
end process;

end bhvrl_immGen;
