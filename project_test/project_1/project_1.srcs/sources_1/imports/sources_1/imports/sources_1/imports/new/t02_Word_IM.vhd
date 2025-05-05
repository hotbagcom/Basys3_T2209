----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Arif
-- 
-- Create Date: 03.11.2024 22:24:52
-- Design Name: 
-- Module Name: t02_Word_IM - bhvrl_IM
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

entity t02_Word_IM is
    generic(
        im_rom_depth : integer  ;
        im_rom_width_inbit : integer 
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
        imm12     : out std_logic_vector(11 downto 0) := (others=> '0'); 
        imm20     : out std_logic_vector(19 downto 0) := (others=> '0') 
        
        ); 
end t02_Word_IM;

--R type | ADD SUB SLL SLT SLTU XOR SRL SRA OR AND | OPCODE 0110011 : f3 {000 000 001 010 011 100 101 101 110 111 }
                    -- 8_0 01+5_0 8_0 8_0 8_0  8_0 8_0 01+5_0 8_0 8_0                         --IM := []         
--B type | BEQ BNE , BLT BGE , BLTU BGEU | OPCODE 1100011 : f3 {000 001 ,100 101 , 110 111}
--I type | LB LH LW , LBU LHU | OPCODE 0000011 : f3 {000 001 010 , 100 101}
--I type | ADDI SLTI SLTIU , XORI ORI ANDI | OPCODE 0010011 : f3 {000 010 011 , 100 110 111}
--I type | SLLI SRLI SRAI  |                 OPCODE 0010011 : f3 {001 101 101} 
                                            -- IM := [5_0+shamt 5_0+shamt 01000+shamt]

--S type | SB SH SW | OPCODE 0100011 : f3 {000 001 010}





--TO DO How to use other insttruction Fence =? , Jal=? , LUI= ? look it in assembly usedge




architecture bhvrl_IM of t02_Word_IM is

signal S_opcode  : std_logic_vector(6 downto 0) := (others=>'0');

type rom is array( 0 to im_rom_depth-1 ) of std_logic_vector( RV_lvlinbit-1 downto 0 ) ;
signal Instruction_rom: rom := (

--add x3, x2, x1   
--sub x4, x0, x1  
--and x5, x2, x1  
--or  x6, x4, x1  
--xor x7, x2, x1  
--srl x8, x2, x1  
--nop  
--nop  
--X"001001b3" ,--0000_000 0_0001_ 0001_0 000_ 0001_1 011_0011 --add
--X"40100233" ,--0100000 00001 00010 000 00100 0110011        --sub
--X"001072b3" ,--0000000 00001 00010 111_ 0010_1 011_0011        --and
--X"00106333" ,--0000000 00001 00010 110 0011_0 011_0011        --or
--X"001043b3" ,--0000000 00001 00010 100 0011_1 011_0011        --xor
--X"00112433" ,--00000000000100010010010000110011        --küçüktür
--X"00000000" ,
--X"00000000" 
-----------------------------------------
--addi x0 , x0,   -2000
--addi x1 , x0,   2000  /* x1  = 1000 0x3E8 */
--slti x2 , x0,   1000  /* x2  = 3000 0xBB8 */
--sltiu x3 , x0,  1000  /* x3  = 2000 0x7D0 */
--xori x4 , x1,   1000  /* x4  = 0    0x000 */
--ori x5 , x1,   1000  /* x5  = 1000 0x3E8 */
--andi x5 , x1,   1000
--slli x5 , x1,   4
	
--X"83030013" , --X"x x x" (r0)0101 0_(f3)xxx _(rd)0000 0_001 0011
--X"7d000093" , -- 1_(op)001 0011
--X"3e802113" ,
--X"3e803193" ,
--X"3e80c213" ,
--X"3e80e293" ,
--X"3e80f293" ,
--X"00411293" ,  --X"x x x" (r0)0001 0_(f3)100 _(rd)0000 0_001 0011
--X"00000000" ,
--X"00000000" ,
--X"00000000" 
------------------------------------------------
-- I_type_dm 
-- LW : 32 BIT , LH : 16BIT , LB : 8 BIT 
--FOR DM ADRESS TAKE 31 TO 2 , 1 AND 0 BIT ARE OPERATES FOR 8 BIT  AND 6 BIT SPECIFIC LOCATION . 
--LOAD copy data in to register from memory .
--STORE copy value in register to memory

--lb x8, 0(x0)          
--lbu x9, 0(x1)         
--lh x10, 0(x2)          
--lhu x11, 6(x3)         
--lw x12, 20(x4)   
-- nop
--lb x24, 1(x8)          
--lbu x25, 1(x8)         
--lh x26, 1(x8)          
--lhu x27, 1(x8)         
--lw x28, 1(x8) 
-- nop
-- nop

--X"00000403" , --X"x x x" (r0)0000 0_(f3)000 _(rd)0100 0_000 0011
--X"0000c483" , --X"x x x" (r0)0000 1_(f3)100 _(rd)0100 1_000 0011
--X"00011503" , --X"x x x" (r0)0001 0_(f3)001 _(rd)0101 0_000 0011
--X"0061d583" , --X"x x 6" (r0)0001 1_(f3)101 _(rd)0101 1_000 0011
--X"01422603" , --X"x 1 4" (r0)0010 0_(f3)010 _(rd)0110 0_000 0011
--X"00000000" , 
--X"00120c03" , --X"x x 1" (r0)0010 0_(f3)000 _(rd)1100 0_000 0011
--X"00124c83" , --X"x x 1" (r0)0010 0_(f3)100 _(rd)1100 1_000 0011
--X"00121d03" , --X"x x 1" (r0)0010 0_(f3)001 _(rd)1101 0_000 0011
--X"00125d83" , --X"x x 1" (r0)0010 0_(f3)101 _(rd)1101 1_000 0011
--X"00122e03" , --X"x x 1" (r0)0010 0_(f3)010 _(rd)1110 0_000 0011      
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000"  

---------------------------------------
-- B_type

--addi x1, x0, 9    
--addi x2, x0, 11  
--addi x5, x0, 0 
--beq x1, x2, beq_equal
--addi x5, x5, 1
--addi x5, x5, -1
--blt x1, x2 , blt_equal_a
--bge x1 , x2 , bge_equal_a
--blt_equal_b:
--blt_equal_a:
--addi x1, x1, 4  
--addi x5, x5, 1
--bge x1, x2 , bge_equal_b
--bge_equal_b:
--bge_equal_a:
--addi x2, x2, 3  
--addi x5, x5, 1
--blt x1, x2 , blt_equal_b
--beq x1, x2, beq_equal_b
--addi x5, x5, 2 
--beq_equal_a:
--beq_equal_b:
--beq_equal:
--addi x5, x5, -1
--addi x3, x1, 10   
--addi x4, x2, 10 


--(imm11)0_(imm10:5)000 000_(r1)0 0000 (r0)0000 0_(f3)010 _(imm4:1)1110 (imm11)0_000 0011

--addi x1, x0, 11   
--addi x2, x0, 9 

--beq x1, x2, beq_equal
--addi x11, x0, 1    
--addi x12, x0, 1 
--addi x5, x0, 1 
--addi x6, x0, 1 

--sub x1, x1,  x11
--blt_equal_a:
--add x1, x1,  x11 
--addi x5, x5, 1  
--sub x2, x2,  x12 
--addi x6, x6, -1 

--bge_equal_a:
--add x2, x2,  x12 
--addi x6, x6, 1 
 
--bge x1, x2, bge_equal_a
--addi x6, x6, -1 

--blt x1 ,x2, blt_equal_a
--addi x5, x5, -1 

--beq_equal:
--addi x3, x1, 10   
--addi x4, x2, 10 
-- dummy (imm12)0_(imm10:5)000 0000_(r1)0 0010 (r0)0000 1_(f3)100 _(imm4:1)1000 (imm11)0_(opcode)110 0011   

--x"00b0_0093" ,  
--x"0090_0113" ,  
--x"0420_8063" ,  
--x"0010_0593" ,  
--x"0010_0613" ,  
--x"0010_0293" ,  
--x"0010_0313" ,  
--x"40b0_80b3" ,  
--x"00b0_80b3" ,  
--x"0012_8293" ,  
--x"40c1_0133" ,  
--x"fff3_0313" ,  
--x"00c1_0133" ,  
--x"0013_0313" ,  
--x"fe20_dce3" ,  
--x"fff3_0313" ,  
--x"fe20_c0e3" ,  
--x"fff2_8293" ,  
--NOP ,  
--NOP   

 
---- works well



--addi x1, x0, 8    
--addi x2, x0, 11 
--bne_equal:
--addi x1, x1, 2    
--addi x2, x2, 1 
--bne x1, x2, bne_equal
--addi x3, x1, 10   
--addi x4, x2, 10 

--x"00800093" ,  
--x"00b00113" ,  
--x"00208093" ,
--x"00110113" ,  
--x"fe209ce3" ,  
--X"00a08193" , 
--x"00a10213" ,  
--NOP ,    
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" , 
--X"00000000" 


--1_111 111_0 0010_ 0000 1_100_ 1111 1_110 0011


-- no update seem on falling edge
--x"00900013" , 
--x"00900013" , 
--x"00900013" ,
--NOP , 
--x"00900013" , 
--x"00900013" , 
--NOP , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" , 
--x"00900013" ,  
--x"00900013" , 
--x"00900013" , 
--x"00900013" 



------------------------------------------------------------------------------------
--addi x1 , x0,   255
--sw x1, 0(x0)   /*# Store x1 at the memory address in x2*/
--addi x2 , x0,   10
--addi x3 , x0,   128
--sh x3, 2(x0)
--sh x3, 0(x0) 
--sh x2, 1(x0)
--sb x2, 4(x0)
--sb x3, 5(x0)
--sb x2, 6(x0)
--sb x3, 7(x0)
--sb x1, 6(x0)
---- dummy (imm11:5)0000 0000_(r1)0 0010 (r0)0000 1_(f3)100 _(imm4:0)1000 0_(opcode)010 0011   
--x"0ff0_0093" ,  
--x"0010_2023" ,  
--x"00a0_0113" ,  
--x"0800_0193" ,  
--x"0030_1123" ,  
--x"0030_1023" ,  
--x"0020_10a3" ,  
--x"0020_0223" ,  
--x"0030_02a3" ,  
--x"0020_0323" ,  
--x"0030_03a3" ,  
--x"0010_0323" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000"   

----------------------


--addi x10 , x0,   255
--addi x11 , x0,   10
--addi x12 , x0,   128
--auipc x10, 0x00010
--lui x11, 0x12345 
--add x12 , x10 ,x11 

--x"0000_0000" ,  
--x"0ff0_0513" ,  
--x"00a0_0593" ,  
--x"0800_0613" ,  
--x"0001_0517" ,  
--x"1234_55b7" ,  
--x"00b5_0633" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000" ,  
--x"0000_0000"  
----------------------
--jal x5 , 2
--addi x10 , x0,   255
--addi x11 , x0,   5
--jalr x1  , x11 , 3
--addi x12 , x0,   128
--addi x12 , x0,   128
--addi x12 , x0,   128
--addi x12 , x0,   128
--addi x10 , x0,   63
--addi x10 , x0,   255
--002002ef
--0ff00513
--00500593
--003580e7
--08000613
--08000613
--08000613
--08000613
--03f00513
--0ff00513  
x"0000_0000" , 
x"000022ef" ,  
x"0ff00513" ,  
x"00500593" ,  
x"003580e7" ,  
x"08000613" ,  
x"08000613" ,  
x"08000613" ,  
x"08000613" , 
x"03f00513" ,  
x"0ff00513" ,  
x"0000_0000" ,  
x"0000_0000" , 
x"0000_0000" ,  
x"0000_0000" ,  
x"0000_0000" ,  
x"0000_0000" ,  
x"0000_0000" ,  
x"0000_0000" ,  
x"0000_0000"  










);

signal Instruction_im_in : std_logic_vector( RV_lvlinbit-1 downto 0);

begin
Instruction_im_in <= Instruction_rom( to_integer(unsigned(current_pc)) );

--- S_opcode <= Instruction_im_in( 6 downto 0 ); learn why S_opcode wont update in  b type operation




process ( current_pc ,Instruction_im_in) begin
    if (RST = '1' ) then
        opcode  <=  (others=>'0') ;
        rd      <=  (others=>'0') ;
        f3      <=  (others=>'0') ;
        rs0     <=  (others=>'0') ;
        rs1     <=  (others=>'0') ;
        f7      <=  (others=>'0') ;
    elsif (Instruction_im_in( 6 downto 0 ) = R_typeop) then
        opcode  <= Instruction_im_in( 6 downto 0 )   ;
        rd      <= Instruction_im_in( 11 downto 7 )  ;
        f3      <= Instruction_im_in( 14 downto 12 ) ;
        rs0     <= Instruction_im_in( 19 downto 15 ) ;
        rs1     <= Instruction_im_in( 24 downto 20 ) ;
        f7      <= Instruction_im_in( 31 downto 25 ) ;
    elsif( Instruction_im_in( 6 downto 0 ) = I_typeop_reg  or Instruction_im_in( 6 downto 0 ) = I_typeop_dm  )then
        opcode  <= Instruction_im_in( 6 downto 0 )  ;
        rd      <= Instruction_im_in( 11 downto 7 ) ;
        f3      <= Instruction_im_in( 14 downto 12 ) ;
        rs0     <= Instruction_im_in( 19 downto 15 ) ;
        imm12   <= Instruction_im_in( 31 downto 20 ) ; -- f7+rs2
        f7      <= Instruction_im_in( 31 downto 25 ) ;
    elsif(Instruction_im_in( 6 downto 0 ) = B_typeop)then -- signed  --1_111 111_0 0010_ 0000 1_100_ 1111 1_110 0011 
        opcode  <= Instruction_im_in( 6 downto 0 )  ;
        f3      <= Instruction_im_in( 14 downto 12 ) ;
        rs0     <= Instruction_im_in( 19 downto 15 ) ;
        rs1     <= Instruction_im_in( 24 downto 20 ) ;
        imm12   <= Instruction_im_in( 31 ) & Instruction_im_in( 7 ) & Instruction_im_in( 30 downto 25 ) & Instruction_im_in( 11 downto 8 )  ;--shift 1 bit left
    elsif(Instruction_im_in( 6 downto 0 ) = S_typeop)then
        opcode  <= Instruction_im_in( 6 downto 0 ) ;
        f3      <= Instruction_im_in( 14 downto 12 ) ;
        rs0     <= Instruction_im_in( 19 downto 15 ) ;
        rs1     <= Instruction_im_in( 24 downto 20 ) ;
        imm12   <= Instruction_im_in( 31 downto 25 ) & Instruction_im_in( 11 downto 7 ); -- f7+rd
    elsif(Instruction_im_in( 6 downto 0 ) = lui_typeop) or (Instruction_im_in( 6 downto 0 ) = auipc_typeop)then -- rd(31:12) <- imm20  --  rd<-pc+imm20
        opcode  <= Instruction_im_in( 6 downto 0 ) ;
        rd      <= Instruction_im_in( 11 downto 7 );
        imm20   <= Instruction_im_in( 31 downto 12 );
    elsif(Instruction_im_in( 6 downto 0 ) = J_typeop_l)then
        opcode  <= Instruction_im_in( 6 downto 0 ) ;
        rd      <= Instruction_im_in( 11 downto 7 );
        imm20   <= Instruction_im_in( 31 downto 12 ) ;   -- f7+rs2+rs1+f3   
    elsif(Instruction_im_in( 6 downto 0 ) = J_typeop_lr) then
        opcode  <= Instruction_im_in( 6 downto 0 ) ;
        f3      <= Instruction_im_in( 14 downto 12 ) ;
        rs0     <= Instruction_im_in( 19 downto 15 ) ;
        rs1     <= Instruction_im_in( 24 downto 20 ) ;
        imm12   <= Instruction_im_in( 31 downto 20 ) ; -- f7+r2     
--    elsif(Instruction_im_in( 6 downto 0 ) = typeop)then
--        opcode  <= Instruction_im_in( 6 downto 0 ) ;
--        f3      <= Instruction_im_in( 14 downto 12 ) ;
--        rs0     <= Instruction_im_in( 19 downto 15 ) ;
--        rs1     <= Instruction_im_in( 24 downto 20 ) ;
--        imm12     <= Instruction_im_in( 31 downto 25 ) & Instruction_im_in( 11 downto 7 ); -- f7+rd
--constant J_typeop_l     : std_logic_vector(6 downto 0) := "1101111" ;       -- rd <- pc+1 , pc<-pc+imm12
--constant J_typeop_lr    : std_logic_vector(6 downto 0) := "1100111" ;       -- rd <- pc+1 , pc<-r0+imm12 

    else
        opcode  <= Instruction_im_in( 6 downto 0 )   ;
        rd      <= Instruction_im_in( 11 downto 7 )  ;
        f3      <= Instruction_im_in( 14 downto 12 ) ;
        rs0     <= Instruction_im_in( 19 downto 15 ) ;
        rs1     <= Instruction_im_in( 24 downto 20 ) ;
        f7      <= Instruction_im_in( 31 downto 25 ) ;        
        imm12     <= X"0ff";--Instruction_im_in( 31 downto 20 ) ; -- f7 +rs2
        imm20     <= X"00fff";
    end if;
        
end process ;


end bhvrl_IM;
--Instruction_im_in = 1 111 1110 0010 0000 1100 1111 1110 0011;
  --  imm12     <= Instruction_im_in( 31 ) & Instruction_im_in( 7 ) & Instruction_im_in( 30 downto 25 ) & Instruction_im_in( 11 downto 8 )  ; 

 --1 1 111 111 1111