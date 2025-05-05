----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2024 14:51:40
-- Design Name: 
-- Module Name: dummy_module - Behavioral
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

entity dummy_module is
    generic(
        dm_depth : integer :=  RV_lvlinbit 
    );
    Port (
        
        next_PC : in std_logic_vector(RV_lvlinbit-1 downto 0 ) ; 
        current_pc : in std_logic_vector( RV_lvlinbit-1 downto 0 ) := (others=>'0');
        
        
        add_pc :in std_logic_vector(3 downto 0) := X"1" ;
        alu_jump_correction : in std_logic;
        prev_PC : in  std_logic_vector(RV_lvlinbit-1 downto 0) ; 
        brnch_imm : in std_logic_vector (RV_lvlinbit-1 downto 0);
        alubrnch_out :  in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        
        
        opcode  : in std_logic_vector(6 downto 0) := "0000000" ;
        f7      : in std_logic_vector(6 downto 0) := "0000000" ;
        f3      : in std_logic_vector(2 downto 0) := "000";
        rs0     : in std_logic_vector(4 downto 0) := "00000";
        rs1     : in std_logic_vector(4 downto 0) := "00000";
        rd      : in std_logic_vector(4 downto 0) := "00000";
        imm12     : in std_logic_vector(11 downto 0) := (others=> '0'); 
        imm20     : in std_logic_vector(19 downto 0) := (others=> '0') ;
        
        
        reg_write_enable : in std_logic ;
        reg_source0_adrs : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_source1_adrs : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_dest : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_write_data : in std_logic_vector(RV_lvlinbit-1 downto 0);       
        reg_source0_out : in std_logic_vector(RV_lvlinbit-1 downto 0);
        reg_source1_out : in std_logic_vector(RV_lvlinbit-1 downto 0);
        
        
        IMM_out : in std_logic_vector(RV_lvlinbit-1  downto 0) ;
        
        alu_data_in0 : in  std_logic_vector(RV_lvlinbit-1 downto 0) ;
        alu_data_in1 : in  std_logic_vector(RV_lvlinbit-1 downto 0) ;
        alu_flag : in std_logic_vector(2 downto 0) := (others=>'0') ; -- MSB overflow | zero LSB  | brnch active 
        alu_data_out : in std_logic_vector(RV_lvlinbit-1 downto 0) := (others=>'0'); 
        
        
        dm_write_enable: in std_logic ;
        dm_read_enable : in std_logic ;
        cntrl_dm_bitlen :in std_logic_vector(2 downto 0);
        dm_adress :in std_logic_vector(dm_depth-1 downto 0) ;
        dm_data_in :in std_logic_vector(dm_depth-1 downto 0) ;
        dm_data_out:in std_logic_vector(dm_depth-1 downto 0) := (others=>'0');
        
        
        cntrl_dm_write_enable : in std_logic := '0';
        cntrl_dm_read_enable : in std_logic := '0';
        cntrl_brnch_enable  : in std_logic := '0';
        cntrl_jump_enable  : in std_logic := '0';
        cnrtl_reg_write_enable : in std_logic := '0';
        cnrtl_alu_data_srce_slkt : in std_logic := '0' ;
        cnrtl_reg_write_srce_slkt : in std_logic := '0' ;
       
       
       
        output_mux_pDM: in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        output_mux_aDM: in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        output_mux_jmp: in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        
        Xclk : in std_logic ;
        userbutton_msblsb : in std_logic_vector( 1 downto 0 ) ;
        usersw_msb : in std_logic_vector( 7 downto 0 ) ;
        usersw_lsb :in std_logic_vector( 7 downto 0 ) ;
        fourHEX_pure : out std_logic_vector( 15 downto 0 ) 

    );
end dummy_module;

architecture Behavioral of dummy_module is

signal upordown     : std_logic := '0';

--signal code_pc      : std_logic_vector(7 downto 0 ) := X"01"; 
--signal code_Abrnch  : std_logic_vector(7 downto 0 ) := X"02"; 
--signal code_IM      : std_logic_vector(7 downto 0 ) := X"03"; 
--signal code_Req     : std_logic_vector(7 downto 0 ) := X"04"; 
--signal code_ImGen   : std_logic_vector(7 downto 0 ) := X"05"; 
--signal code_ALU     : std_logic_vector(7 downto 0 ) := X"06"; 
--signal code_DM      : std_logic_vector(7 downto 0 ) := X"07"; 
--signal code_cntrl   : std_logic_vector(7 downto 0 ) := X"08"; 
--signal code_predm   : std_logic_vector(7 downto 0 ) := X"09"; 
--signal code_aftdm   : std_logic_vector(7 downto 0 ) := X"0a"; 
--signal code_jmp     : std_logic_vector(7 downto 0 ) := X"0b"; 


signal fourHEX :  std_logic_vector( 15 downto 0 ) := x"0000" ;

begin


process (userbutton_msblsb ) begin 

    if ( falling_edge(userbutton_msblsb(0)) ) then
        upordown <= '0'; 
    end if ;
    if ( falling_edge(userbutton_msblsb(1)) ) then
        upordown <= '1';
    end if ;
    
end process ;




process (Xclk  ) begin
fourHEX_pure <=  userbutton_msblsb & "00" &  fourHEX(11 downto 5) & rs0;

    case (usersw_msb ) is
        when X"01" => -- PC
            case (usersw_lsb) is 
                when X"01" => -- next_PC
                    if (upordown = '1' ) then 
                    fourHEX <= next_PC(31 downto 16);
                    else 
                    fourHEX <= next_PC(15 downto 0);
                    end if;
                when X"81" => -- current_pc
                    if (upordown = '1' ) then 
                    fourHEX <= current_pc(31 downto 16);
                    else 
                    fourHEX <= current_pc(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;
        when X"02" => -- ALU branch
            case (usersw_lsb) is 
                when X"01" => -- add_pc
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"000" & add_pc;
                    end if; 
                when X"02" => -- alu_jump_correction
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( alu_jump_correction = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;
                when X"03" => -- cntrl_brnch_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cntrl_brnch_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if; 
                when X"04" => -- prev_PC
                    if (upordown = '1' ) then 
                    fourHEX <= current_pc(31 downto 16);
                    else 
                    fourHEX <= current_pc(15 downto 0);
                    end if; 
                when X"05" => -- brnch_imm
                    if (upordown = '1' ) then 
                    fourHEX <= brnch_imm(31 downto 16);
                    else 
                    fourHEX <= brnch_imm(15 downto 0);
                    end if;  
                when X"81" => -- alubrnch_out
                    if (upordown = '1' ) then 
                    fourHEX <= alubrnch_out(31 downto 16);
                    else 
                    fourHEX <= alubrnch_out(15 downto 0);
                    end if; 
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;
        when X"03" => --code_IM
            case (usersw_lsb) is 
                when X"01" => -- current_pc
                    if (upordown = '1' ) then 
                    fourHEX <= current_pc(31 downto 16);
                    else 
                    fourHEX <= current_pc(15 downto 0);
                    end if;  
                when X"81" => -- opcode
                    if (upordown = '1' ) then 
                    fourHEX <=  X"0000";
                    else 
                    fourHEX <= X"00" & '0'& opcode;
                    end if;  
                when X"82" => -- f7
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & '0' & f7 ;
                    end if;  
                when X"83" => -- f3
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <=  X"000" & '0' & f3 ;
                    end if;  
                when X"84" => -- rs0
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & "000" & rs0 ;
                    end if;  
                when X"85" => -- rs1
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" &  "000" & rs1 ;
                    end if;  
                when X"86" => -- rd
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <=  X"00" & "000" & rd ;
                    end if;     
                when X"87" => -- imm12
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"0" &  imm12;
                    end if;  
                when X"88" => -- imm20
                    if (upordown = '1' ) then 
                    fourHEX <= X"000" &  imm20(19 downto 16);
                    else 
                    fourHEX <= imm20(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;
        when X"04" => --- code_Reg
            case (usersw_lsb) is 
                when X"01" => -- current_pc
                    if (upordown = '1' ) then 
                    fourHEX <= current_pc(31 downto 16);
                    else 
                    fourHEX <= current_pc(15 downto 0);
                    end if;
                when X"02" => -- add_pc
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000" ;
                    else 
                    fourHEX <= X"000" & add_pc;
                    end if;
                when X"03" => -- opcode
                    if (upordown = '1' ) then 
                    fourHEX <=  X"0000";
                    else 
                    fourHEX <= X"00" & '0'& opcode;
                    end if;
                when X"04" => -- reg_write_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( reg_write_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if; 
                when X"05" => -- reg_source0_adrs
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & "000" & reg_source0_adrs ;
                    end if;
                when X"06" => -- reg_source1_adrs
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & "000" & reg_source1_adrs ;
                    end if;
                when X"07" => -- reg_dest
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & "000" & reg_dest ;
                    end if;
                when X"08" => -- reg_write_data
                    if (upordown = '1' ) then 
                    fourHEX <= reg_write_data(31 downto 16) ;
                    else 
                    fourHEX <= reg_write_data(15 downto 0);
                    end if;
                when X"81" => -- reg_source0_out
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000" ;
                    fourHEX <= reg_source0_out(31 downto 16) ;
                    else 
                    fourHEX <= reg_source0_out(15 downto 0);
                    end if;
                when X"82" => -- reg_source1_out
                    if (upordown = '1' ) then 
                    fourHEX <= reg_source1_out(31 downto 16) ;
                    else 
                    fourHEX <= reg_source1_out(15 downto 0);
                    end if; 
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;
        when X"05" => --code_ImGen
            case (usersw_lsb) is
                when X"01" => -- opcode imm12
                    if (upordown = '1' ) then 
                    fourHEX <=  X"0000";
                    else 
                    fourHEX <= X"00" & '0'& opcode;
                    end if;  
                when X"02" => -- imm12
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"0" &  imm12;
                    end if;  
                when X"03" => -- imm20
                    if (upordown = '1' ) then 
                    fourHEX <= X"000" &  imm20(19 downto 16);
                    else 
                    fourHEX <= imm20(15 downto 0);
                    end if;
                when X"80" => -- IMM_out
                    if (upordown = '1' ) then 
                    fourHEX <= IMM_out(31 downto 16);
                    else 
                    fourHEX <= IMM_out(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;  
        when X"06" => --code_ALU
            case (usersw_lsb) is 
                when X"01" => -- opcode
                    if (upordown = '1' ) then 
                    fourHEX <=  X"0000";
                    else 
                    fourHEX <= X"00" & '0'& opcode;
                    end if;  
                when X"02" => -- f7
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & '0' & f7 ;
                    end if;  
                when X"03" => -- f3
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <=  X"000" & '0' & f3 ;
                    end if;  
                when X"04" => -- alu_data_in0
                    if (upordown = '1' ) then 
                    fourHEX <= alu_data_in0(31 downto 16);
                    else 
                    fourHEX <= alu_data_in0(15 downto 0);
                    end if;
                when X"05" => -- alu_data_in1
                    if (upordown = '1' ) then 
                    fourHEX <= alu_data_in1(31 downto 16);
                    else 
                    fourHEX <= alu_data_in1(15 downto 0);
                    end if; 
                when X"81" => -- alu_flag
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else  
                    fourHEX <=  X"000" & '0' & alu_flag;
                    end if;
                when X"82" => -- alu_data_out
                    if (upordown = '1' ) then 
                    fourHEX <= alu_data_out(31 downto 16);
                    else 
                    fourHEX <= alu_data_out(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;  
        when X"07"  => --"code_DM"
            case (usersw_lsb) is 
                when X"01" => -- dm_write_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( dm_write_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if; 
                when X"02" => -- dm_read_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( dm_read_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;  
                when X"03" => -- cntrl_dm_bitlen
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"000" & '0' & cntrl_dm_bitlen  ;
                    end if;
                when X"04" => -- dm_adress
                    if (upordown = '1' ) then 
                    fourHEX <= dm_adress(31 downto 16);
                    else 
                    fourHEX <= dm_adress(15 downto 0);
                    end if;
                when X"05" => -- dm_data_in
                    if (upordown = '1' ) then 
                    fourHEX <= dm_data_in(31 downto 16);
                    else 
                    fourHEX <= dm_data_in(15 downto 0);
                    end if;
                    
                when X"81" => -- dm_data_out
                    if (upordown = '1' ) then 
                    fourHEX <= dm_data_out(31 downto 16);
                    else 
                    fourHEX <= dm_data_out(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;  
        when X"08" => -- "code_cntrl" 
            case (usersw_lsb) is 
                when X"01" => -- opcode
                    if (upordown = '1' ) then 
                    fourHEX <=  X"0000";
                    else 
                    fourHEX <= X"00" & '0'& opcode;
                    end if;  
                when X"02" => -- f7
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"00" & '0' & f7 ;
                    end if;  
                when X"03" => -- f3
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <=  X"000" & '0' & f3 ;
                    end if;  
                when X"81" => -- cntrl_dm_write_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cntrl_dm_write_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;   
                when X"82" => -- cntrl_dm_read_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cntrl_dm_read_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;   
                when X"83" => -- cntrl_dm_bitlen
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                    fourHEX <= X"000" & '0' & cntrl_dm_bitlen  ;
                    end if;
                when X"84" => -- cntrl_brnch_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cntrl_brnch_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;   
                when X"85" => -- cntrl_jump_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cntrl_jump_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;   
                when X"86" => -- cnrtl_reg_write_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cnrtl_reg_write_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;   
                when X"87" => -- cnrtl_alu_data_srce_slkt
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cnrtl_alu_data_srce_slkt = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;   
                when X"88" => -- cnrtl_reg_write_srce_slkt
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cnrtl_reg_write_srce_slkt = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;  
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ; 
        when X"09" => ---"code_predm"
            case (usersw_lsb) is 
            
                when X"01" => -- cnrtl_alu_data_srce_slkt
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cnrtl_reg_write_srce_slkt = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;  
                when X"02" => -- reg_source1_out
                    if (upordown = '1' ) then 
                    fourHEX <= reg_source1_out(31 downto 16);
                    else 
                    fourHEX <= reg_source1_out(15 downto 0);
                    end if;
                when X"03" => -- IMM_out
                    if (upordown = '1' ) then 
                    fourHEX <= IMM_out(31 downto 16);
                    else 
                    fourHEX <= IMM_out(15 downto 0);
                    end if;
                when X"81" => -- current_pc
                    if (upordown = '1' ) then 
                    fourHEX <= alu_data_in1(31 downto 16);
                    else 
                    fourHEX <= alu_data_in1(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ; 
        when X"0a"  => ---"code_aftdm"
            case (usersw_lsb) is 
                when X"01" => -- cnrtl_reg_write_srce_slkt
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cnrtl_reg_write_srce_slkt = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;  
                when X"02" => -- dm_data_out
                    if (upordown = '1' ) then 
                    fourHEX <= dm_data_out(31 downto 16);
                    else 
                    fourHEX <= dm_data_out(15 downto 0);
                    end if;
                when X"03" => -- alu_data_out
                    if (upordown = '1' ) then 
                    fourHEX <= alu_data_out(31 downto 16);
                    else 
                    fourHEX <= alu_data_out(15 downto 0);
                    end if;
                when X"81" => -- reg_write_data
                    if (upordown = '1' ) then 
                    fourHEX <= reg_write_data(31 downto 16);
                    else 
                    fourHEX <= reg_write_data(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;
            
            
        when  X"0b" => --"code_jmp" 
            case (usersw_lsb) is 
                when X"01" => -- cntrl_jump_enable
                    if (upordown = '1' ) then 
                    fourHEX <= X"0000";
                    else 
                        if ( cntrl_jump_enable = '0') then 
                            fourHEX <= X"0000";
                        else
                            fourHEX <= X"0001";
                        end if ;
                    end if;  
                when X"02" => -- alubrnch_out
                    if (upordown = '1' ) then 
                    fourHEX <= alubrnch_out(31 downto 16);
                    else 
                    fourHEX <= alubrnch_out(15 downto 0);
                    end if;
                when X"03" => -- alu_data_out
                    if (upordown = '1' ) then 
                    fourHEX <= alu_data_out(31 downto 16);
                    else 
                    fourHEX <= alu_data_out(15 downto 0);
                    end if;
                when X"81" => -- next_PC
                    if (upordown = '1' ) then 
                    fourHEX <= next_PC(31 downto 16);
                    else 
                    fourHEX <= next_PC(15 downto 0);
                    end if;
                when others =>  
                    fourHEX <=  X"0000" ;
            end case ;
            
            
            
            
        when others =>  
                fourHEX <=  X"0000" ;
        
        
    end case ;




end process ;



end Behavioral;
