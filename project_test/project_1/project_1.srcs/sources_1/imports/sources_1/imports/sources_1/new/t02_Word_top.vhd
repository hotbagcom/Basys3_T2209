----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 14:59:44
-- Design Name: 
-- Module Name: t02_Word_top - bhvrl_top
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

entity t02_Word_top is
    Port(
    CLK_top : in std_logic := '0' ;
    RST_top : in std_logic := '0'  
    );
end t02_Word_top;

architecture bhvrl_top of t02_Word_top is
----- COMPONENT -----
component t02_Word_PC is
    Port(
        RST : in std_logic  ; 
        CLK : in std_logic  ; 
        next_PC : in std_logic_vector(RV_lvlinbit-1 downto 0 ) ; 
        current_pc : out std_logic_vector( RV_lvlinbit-1 downto 0 ):= (others=>'0')
        
    );
end component ;
component  t02_Word_ALUbrnch is
    Port(
        add_pc : in std_logic_vector(3 downto 0) ;
        alu_jump_correction : in std_logic_vector(2 downto 0) ;
        cntrl_brnch_enable : in std_logic;
        prev_PC : in  std_logic_vector(RV_lvlinbit-1 downto 0) ; 
        -- next_PC : --jumpun çýkýþýna yaz 
        brnch_imm : in std_logic_vector (RV_lvlinbit-1 downto 0);
        alubrnch_out :  out std_logic_vector(RV_lvlinbit-1 downto 0) 
    );
end component ;

component t02_Word_IM is
   generic(
        im_rom_depth : integer  := RV_im_rom_depth ; -- RV_lvlinbit
        im_rom_width_inbit : integer := RV_im_rom_width_inbit -- RV_lvlinbitinbit
    );
    Port ( 
        RST : in std_logic := '0' ;  --active high mi active lov mu ? 
        current_pc : in std_logic_vector( im_rom_width_inbit-1 downto 0);
        opcode  : out std_logic_vector(6 downto 0) := "0000000" ;
        f7      : out std_logic_vector(6 downto 0) := "0000000" ;
        f3      : out std_logic_vector(2 downto 0) := "000";
        rs0     : out std_logic_vector(4 downto 0) := "00000";
        rs1     : out std_logic_vector(4 downto 0) := "00000";
        rd      : out std_logic_vector(4 downto 0) := "00000";
        imm12   : out std_logic_vector(11 downto 0) := (others=> '0'); 
        imm20   : out std_logic_vector(19 downto 0) := (others=> '0') 
    );
end component ;
component t02_Word_Reg is
    Generic(
        ram_length : integer :=  RV_lvlinbit ;
        ram_depth : integer :=  RV_lvlinbit 
    );
    Port(
        CLK : in std_logic ; 
        RST : in std_logic ;  --active high mi active lov mu ? 
        current_pc : in std_logic_vector(RV_lvlinbit-1 downto 0 ) ; 
        add_pc :in std_logic_vector(3 downto 0)  ;
        opcode  : in std_logic_vector(6 downto 0) ;
        reg_write_enable : in std_logic ;
        reg_source0_adrs : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_source1_adrs : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_dest : in std_logic_vector(RV_lvlinbitinbit-1 downto 0);
        reg_write_data : in std_logic_vector(RV_lvlinbit-1 downto 0);
        reg_source0_out : out std_logic_vector(RV_lvlinbit-1 downto 0);
        reg_source1_out : out std_logic_vector(RV_lvlinbit-1 downto 0)
    );
end component ;
component t02_Word_immGen is
    Port (
        opcode  : in std_logic_vector(6 downto 0) ;
        imm12 : in std_logic_vector(11 downto 0); 
        imm20 : in std_logic_vector(19 downto 0); 
        IMM_out : out std_logic_vector(RV_lvlinbit-1  downto 0) 
    );
end component ;
component t02_Word_ALU is
    Generic(
        opcodemax_inbit : integer :=2--daha sonrasý için control ünit ten sadec ebelirli codlarý alan bir hat çýkarýp öyle kontrol et 
    );
    Port(
        --alu_opcode : in std_logic_vector(opcodemax_inbit downto 0);
        opcode  : in std_logic_vector(6 downto 0) ;
        f7      : in std_logic_vector(6 downto 0) ;
        f3      : in std_logic_vector(2 downto 0) ;
        alu_data_in0 : in  std_logic_vector(31 downto 0);
        alu_data_in1 : in  std_logic_vector(31 downto 0);
        alu_flag : out std_logic_vector(2 downto 0) ; -- MSB overflow | zero LSB  | brnch active 
        
        alu_data_out : out std_logic_vector(31 downto 0)
    );
end component ;
component t02_Word_DM is 
    Generic(
        dm_length : integer :=  RV_lvl ;
        dm_depth : integer :=  RV_lvlinbit 
    );
    Port(
        RST : in std_logic := '0' ;  --active high mi active lov mu ? 
        CLK : in std_logic ;
        dm_write_enable: in std_logic ;
        dm_read_enable : in std_logic ;
        cntrl_dm_bitlen :in std_logic_vector(2 downto 0);
        dm_adress :in std_logic_vector(dm_depth-1 downto 0) ;
        dm_data_in :in std_logic_vector(dm_depth-1 downto 0) ;
        dm_data_out:out std_logic_vector(dm_depth-1 downto 0) := (others=>'0')
    );
end component ;
component t02_Word_cntrl is
    Port (
        opcode  : in std_logic_vector(6 downto 0) ;
        f7      : in std_logic_vector(6 downto 0) ;
        f3      : in std_logic_vector(2 downto 0) ;
        cntrl_dm_write_enable: out std_logic := '0';
        cntrl_dm_read_enable : out std_logic := '0';
        cntrl_dm_bitlen :out std_logic_vector(2 downto 0):= "010" ;
        cntrl_brnch_enable  : out std_logic := '0';
        cntrl_jump_enable  : out std_logic := '0';
        --cntrl_alu_opcode : out std_logic := '0' ;
        cnrtl_reg_write_enable : out std_logic := '0';
        cnrtl_alu_data_srce_slkt : out std_logic := '0' ;
        cnrtl_reg_write_srce_slkt : out std_logic := '0' ;
        add_pc : out std_logic_vector(3 downto 0) := X"1" 
        );
end component ;
component t02_Word_mux2 is
    Port (
        sellection : in std_logic ;
        choice_0 : in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        choice_1 : in std_logic_vector(RV_lvlinbit-1 downto 0) ;
        output : out std_logic_vector(RV_lvlinbit-1 downto 0) 
        );
end component ;


----- Signal -----
signal S_RST : std_logic ; 
signal S_CLK : std_logic ; 
signal S_next_PC : std_logic_vector(RV_lvlinbit-1 downto 0) ; 
signal S_current_pc : std_logic_vector(RV_lvlinbit-1 downto 0) ;
signal S_add_pc     : std_logic_vector(3 downto 0); 

signal S_opcode  : std_logic_vector(6 downto 0) ;
signal S_f7      : std_logic_vector(6 downto 0) ;
signal S_f3      : std_logic_vector(2 downto 0) ;
signal S_rs0     : std_logic_vector(4 downto 0) ;
signal S_rs1     : std_logic_vector(4 downto 0) ;
signal S_rd      : std_logic_vector(4 downto 0) ;
signal S_imm_12     : std_logic_vector(11 downto 0); 
signal S_imm_20     : std_logic_vector(19 downto 0); 

signal S_cntrl_dm_write_enable: std_logic ;
signal S_cntrl_dm_read_enable : std_logic ;
signal S_cntrl_dm_bitlen : std_logic_vector(2 downto 0);
signal S_cntrl_brnch_enable : std_logic ;
signal S_cntrl_jump_enable : std_logic ;
--signal S_cntrl_alu_opcode : std_logic ;
signal S_cnrtl_reg_write_enable : std_logic ;
signal S_cnrtl_alu_data_srce_slkt : std_logic ;
signal S_cnrtl_reg_write_srce_slkt : std_logic ;

signal S_imm_32     : std_logic_vector(RV_lvlinbit-1 downto 0); 
Signal S_alubrnch_out : std_logic_vector(RV_lvlinbit-1 downto 0); 

signal S_reg_source0_out : std_logic_vector(RV_lvlinbit-1 downto 0) ;
signal S_reg_source1_out : std_logic_vector(RV_lvlinbit-1 downto 0) ;
signal S_reg_write_data : std_logic_vector(RV_lvlinbit-1 downto 0);

signal S_alu_data_in1 :  std_logic_vector(RV_lvlinbit-1 downto 0);
signal S_alu_flag : std_logic_vector(2 downto 0) ; -- MSB overflow | zero LSB  | brnch active 
signal S_alu_data_out : std_logic_vector(RV_lvlinbit-1 downto 0);

--signal S_dm_adress: std_logic_vector(dm_depth-1 downto 0) ;
--signal S_dm_data_in: std_logic_vector(dm_depth-1 downto 0) ;
signal S_dm_data_out: std_logic_vector(dm_depth-1 downto 0) ;
        

begin
S_CLK <= CLK_top ;
S_RST <= RST_top ;
----- PORT MAP -----
PC : t02_Word_PC 
    port map(
        RST => S_RST ,
        CLK => S_CLK ,
        next_PC => S_next_PC ,
        current_pc => S_current_pc 
    );

ALU_adress : t02_Word_ALUbrnch 
    port map(
        add_pc => S_add_pc ,
        alu_jump_correction => S_alu_flag ,-- MSB overflow | zero LSB  | <brnch active> 
        cntrl_brnch_enable => S_cntrl_brnch_enable ,
        prev_PC => S_current_pc ,
        -- next_PC => S_next_PC  : --jumpun çýkýþýna yaz 
        brnch_imm => S_imm_32 ,
        alubrnch_out =>  S_alubrnch_out
    );
IM : t02_Word_IM
    port map( 
        RST => S_RST , --active high mi active lov mu ? 
        current_pc => S_current_pc,
        opcode  => S_opcode ,
        f7      => S_f7 ,
        f3      => S_f3 ,
        rs0     => S_rs0 ,
        rs1     => S_rs1 ,
        rd      => S_rd ,
        imm12   => S_imm_12 ,
        imm20   => S_imm_20
         
    );
Reg : t02_Word_Reg
    port map(
        CLK => S_CLK ,
        RST => S_RST , --active high mi active lov mu ? 
        current_pc => S_current_pc , 
        add_pc => S_add_pc ,
        opcode  => S_opcode ,
        reg_write_enable => S_cnrtl_reg_write_enable ,
        reg_source0_adrs => S_rs0 ,
        reg_source1_adrs => S_rs1 ,
        reg_dest =>  S_rd ,
        reg_write_data => S_reg_write_data ,
        reg_source0_out => S_reg_source0_out ,
        reg_source1_out => S_reg_source1_out
    );
immGen : t02_Word_immGen
    port map(
        opcode => S_opcode ,
        imm12 => S_imm_12 , 
        imm20 => S_imm_20 , 
        IMM_out => S_imm_32 
    );

ALU : t02_Word_ALU
    port map(
        --alu_opcode : in std_logic_vector(opcodemax_inbit downto 0);
        opcode  => S_opcode ,
        f7      => S_f7 ,
        f3      => S_f3 ,
        alu_data_in0 =>  S_reg_source0_out ,
        alu_data_in1 => S_alu_data_in1 ,
        alu_flag => S_alu_flag , -- MSB overflow | zero LSB  | brnch active 
        alu_data_out => S_alu_data_out
    );

DM : t02_Word_DM
    port map(
        RST => S_RST , --active high mi active lov mu ? 
        CLK => S_CLK ,
        dm_write_enable => S_cntrl_dm_write_enable ,
        dm_read_enable => S_cntrl_dm_read_enable ,
        cntrl_dm_bitlen => S_f3 , --S_cntrl_dm_bitlen,  dealy ocured so that f3 directly taken from IM  
        dm_adress => S_alu_data_out ,
        dm_data_in => S_reg_source1_out ,
        dm_data_out => S_dm_data_out
    );

cntrl : t02_Word_cntrl
    port map(
        opcode  => S_opcode ,
        f7      => S_f7 ,
        f3      => S_f3 ,
        cntrl_dm_write_enable => S_cntrl_dm_write_enable ,
        cntrl_dm_read_enable => S_cntrl_dm_read_enable ,
        cntrl_dm_bitlen => S_cntrl_dm_bitlen, ---curently un connected to DM module 
        cntrl_brnch_enable => S_cntrl_brnch_enable ,
        cntrl_jump_enable => S_cntrl_jump_enable ,
        --cntrl_alu_opcode : out std_logic := '0' ;
        cnrtl_reg_write_enable => S_cnrtl_reg_write_enable ,
        cnrtl_alu_data_srce_slkt => S_cnrtl_alu_data_srce_slkt ,
        cnrtl_reg_write_srce_slkt => S_cnrtl_reg_write_srce_slkt ,
        add_pc => S_add_pc 
        );

mux2_preDM : t02_Word_mux2 
    port map(
        sellection => S_cnrtl_alu_data_srce_slkt ,
        choice_0 => S_reg_source1_out ,
        choice_1 => S_imm_32 ,
        output => S_alu_data_in1
        );
mux2_afterDM : t02_Word_mux2 
    port map(
        sellection => S_cnrtl_reg_write_srce_slkt ,
        choice_0 => S_dm_data_out ,
        choice_1 => S_alu_data_out ,
        output => S_reg_write_data 
        );
mux2_jump : t02_Word_mux2 
    port map(
        sellection => S_cntrl_jump_enable ,
        choice_0 =>  S_alubrnch_out ,
        choice_1 => S_alu_data_out ,
        output => S_next_PC  
        );











end bhvrl_top;
