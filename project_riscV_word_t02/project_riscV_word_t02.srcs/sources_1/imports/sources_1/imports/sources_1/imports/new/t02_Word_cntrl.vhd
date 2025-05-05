----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Arif
-- 
-- Create Date: 03.11.2024 22:24:52
-- Design Name: 
-- Module Name: t02_Word_cntrl - bhvrl_cntrl
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

entity t02_Word_cntrl is
    Port (
        opcode  : in std_logic_vector(6 downto 0) ;
        f7      : in std_logic_vector(6 downto 0) ;
        f3      : in std_logic_vector(2 downto 0) ;
        cntrl_dm_write_enable : out std_logic := '0';
        cntrl_dm_read_enable : out std_logic := '0';
        cntrl_dm_bitlen : out std_logic_vector(2 downto 0) := "000";
        cntrl_brnch_enable  : out std_logic := '0';
        cntrl_jump_enable  : out std_logic := '0';
        --cntrl_alu_opcode : out std_logic := '0' ;
        cnrtl_reg_write_enable : out std_logic := '0';
        cnrtl_alu_data_srce_slkt : out std_logic := '0' ;
        cnrtl_reg_write_srce_slkt : out std_logic := '0' ;
        
        add_pc : out std_logic_vector(3 downto 0) := X"1"
        );
end t02_Word_cntrl;

architecture bhvrl_cntrl of t02_Word_cntrl is

begin

--constant R_typeop : std_logic_vector(6 downto 0) := "0110011" ;
--constant S_typeop : std_logic_vector(6 downto 0) := "0100011" ;
--constant I_typeop_0 : std_logic_vector(6 downto 0) := "000011" ;
--constant I_typeop_1 : std_logic_vector(6 downto 0) := "0010011" ;
--constant B_typeop : std_logic_vector(6 downto 0) := "1100011" ;

process ( opcode , f3 , f7 ) begin
-- to do case mi if mi 
    if (opcode = R_typeop) then
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- 0: signed 1:unsigned ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '1' ;
        cnrtl_alu_data_srce_slkt <= '0' ;--reg çýkýþ 
        cnrtl_reg_write_srce_slkt<= '1' ;--alu out yazýlýr

    elsif (opcode = I_typeop_reg) then 
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- 0: signed 1:unsigned ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '1' ;
        cnrtl_alu_data_srce_slkt <= '1' ;--imm12 çýkýþ
        cnrtl_reg_write_srce_slkt<= '1' ;--alu out yazýlýr
        
    elsif (opcode = I_typeop_dm) then 
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '1' ;
        cntrl_dm_bitlen  <= f3 ;-- 0: signed 1:unsigned ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '0' ;
        cnrtl_alu_data_srce_slkt <= '1' ;--imm12 çýkýþ
        cnrtl_reg_write_srce_slkt<= '0' ;--dm out yazýlýr
        
    elsif (opcode = B_typeop) then 
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- 0: signed 1:unsigned ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '1' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '0' ;
        cnrtl_alu_data_srce_slkt <= '0' ;--reg çýkýþ 
        cnrtl_reg_write_srce_slkt<= '0' ;--dm out yazýlýr 
    elsif (opcode = S_typeop) then 
        cntrl_dm_write_enable    <= '1' ;
        cntrl_dm_read_enable     <= '0' ;
        cntrl_dm_bitlen  <= f3 ;-- ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '0' ;
        cnrtl_alu_data_srce_slkt <= '1' ;--imm12 çýkýþ 
        cnrtl_reg_write_srce_slkt<= '0' ;--dm out yazýlýr 
    elsif (opcode = lui_typeop or opcode = auipc_typeop) then 
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '1' ;
        cnrtl_alu_data_srce_slkt <= '1' ;--immxx çýkýþ 
        cnrtl_reg_write_srce_slkt<= '1' ;--alu out yazýlýr
    elsif (opcode = J_typeop_l) then
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '1' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '1' ;
        cnrtl_alu_data_srce_slkt <= '1' ;--immxx çýkýþ 
        cnrtl_reg_write_srce_slkt<= '1' ;--alu out yazýlýr
    elsif (opcode = J_typeop_lr) then
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '1' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '1' ;
        cnrtl_alu_data_srce_slkt <= '1' ;--immxx çýkýþ 
        cnrtl_reg_write_srce_slkt<= '1' ;--alu out yazýlýr
    else 
        cntrl_dm_write_enable    <= '0' ;
        cntrl_dm_read_enable     <= '0' ;
        --cntrl_dm_bitlen  <= f3 ;-- 0: signed 1:unsigned ||||00: 8 byte | 01: half word | 10: word |
        cntrl_brnch_enable <= '0' ;
        cntrl_jump_enable <= '0' ;
        --cntrl_alu_opcode         <= '0' ;
        cnrtl_reg_write_enable   <= '0' ;
        cnrtl_alu_data_srce_slkt <= '0' ;--reg çýkýþ 
        cnrtl_reg_write_srce_slkt<= '0' ;--dm out yazýlýr
    end if ;



end process ;



end bhvrl_cntrl;
