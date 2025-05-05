----------------------------------------------------------------------------------
-- Company: MU
-- Engineer: Arif
-- 
-- Create Date: 03.11.2024 22:24:52
-- Design Name: 
-- Module Name: t02_Word_Reg - bhvrl_Reg
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

entity t02_Word_Reg is
    Generic(
        ram_length : integer :=  RV_lvlinbit ;
        ram_depth : integer :=  RV_lvlinbit 
    );
    Port(
        CLK : in std_logic ;
        RST : in std_logic ;  --active high mi active lov mu ? 
        current_pc : in std_logic_vector(RV_lvlinbit-1 downto 0 ) ; 
        add_pc : in std_logic_vector(3 downto 0)  ;
        opcode  : in std_logic_vector(6 downto 0) ;
        reg_write_enable : in std_logic ;
        reg_source0_adrs : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_source1_adrs : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_dest : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_write_data : in std_logic_vector(RV_lvlinbit-1 downto 0);
        reg_source0_out : out std_logic_vector(RV_lvlinbit-1 downto 0);
        reg_source1_out : out std_logic_vector(RV_lvlinbit-1 downto 0)
    );
end t02_Word_Reg;

architecture bhvrl_Reg of t02_Word_Reg is

type ram_typ is array(0 to ram_length-1) of bit_vector(ram_depth-1 downto 0)  ;
signal RAM_reg : ram_typ := (



X"00000000" ,--0000 0110 signed byte
X"00000000" ,--0000 0110 unsigned byte
X"00000000" ,--0000 1100 word
X"00000000" ,--0000 1000 signed halfword
X"00000000" ,--0000 1000 unsigned halfword
X"00000000" ,--for all
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000" ,
X"00000000"
);

begin

--register write process
--REG_WRITE  
--ToDo  reg write does not work as wished in falling_edge
--register read process
--REG_READ

--sadece rise de çalýþtýrmsyý dene

process ( CLK , reg_source0_adrs , reg_source1_adrs ) begin 
-- TODO jal ý ilk clk deðiþiminde dýþarý vermeyen ne 
    if (opcode = auipc_typeop) or ( opcode = J_typeop_l) then 
        reg_source0_out <= current_pc;
    else --elsif ( opcode = J_typeop_lr) then
        reg_source0_out <= to_stdlogicvector( RAM_reg( to_integer(unsigned( reg_source0_adrs )) ) );
    end if;
    reg_source1_out <= to_stdlogicvector( RAM_reg( to_integer(unsigned( reg_source1_adrs )) ) );
end  process ;

process ( CLK  ) begin 
    if(rising_edge(CLK) )then 
        if ( reg_write_enable = '1' and reg_dest /= X"00000000" )then
            if ( opcode = J_typeop_l) or ( opcode = J_typeop_lr) then
            RAM_reg( to_integer(unsigned(reg_dest)) ) <= to_bitvector(std_logic_vector(unsigned( current_pc) + unsigned( add_pc)) );
            else
            RAM_reg( to_integer(unsigned(reg_dest)) ) <= to_bitvector(reg_write_data);
            end if;
        end if;
    end if;
end  process ;

end bhvrl_Reg;
