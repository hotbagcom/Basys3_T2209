----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2025 08:59:51
-- Design Name: 
-- Module Name: p05_oled1306 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p05_oled1306 is
    Port (
    
        btn_triger : in std_logic := '0';--temporarry solution 
        en_com : out std_logic := '0';-- 1 activates com 
        adrr_1306_d1 :out  std_logic_vector(6 downto 0) := "0111100";
        R_W       : out std_logic := '0';  --1 reads 0 writes
        data_wr   : out     std_logic_vector(7 downto 0); --data to write to slave
        busy      : in    std_logic := '0';     --indicates transaction in progress
        data_rd   : in    std_logic_vector(7 downto 0) --data read from slave

    );
end p05_oled1306;

architecture Behavioral of p05_oled1306 is
 
type INNFO8x8 is  array(0 to 7) of std_logic_vector(7 downto 0)  ;


signal init_lowsimple : INNFO8x8 := 
(
"00100001", --Set Memory Addressing Mode 
--[  0010_00xx ---> {00(Horizontal)} , {01(Vertical)} , {10()Page adressigmode,"RESET"} , {11(Invalid) ]
"00000000" , -- Starting colum adress
"00000111" , -- Stoping colum adress
"00100010", -- Set Page Addressing Mode 
"00000000" , -- Starting Page adress
"00000000" , -- Stoping PAge adress
"01000000" , --Start data transmission command
"00000000" --dummy
);


signal  smile_WteethNhead : INNFO8x8 := ---after first test todo make a 8to8 ram and receive it from another block , produce another module to sent data to this modul to display pixcel art    and neutolize ACK2
(
"00011000" ,
"01010010" ,
"11100110" ,
"10100000" ,
"10100000" ,
"11100110" ,
"01010010" ,
"00011000" 

);


shared variable cntrC : integer range 0 to 10 := 0; 

shared variable cntrD : integer range 0 to 10 := 0; 
signal busy_cntr : integer range 0 to 63 := 0 ;


signal one : std_logic_vector(7 downto 0) := X"01"; 
signal sizeof_package : std_logic_vector(7 downto 0) := "00001000"; 


begin


process ( btn_triger  , busy ) begin 


    if ( falling_edge(btn_triger) or ( busy_cntr>0 and  busy= '0')  ) then 
        en_com <='1';
        busy_cntr <= busy_cntr +1 ;
        if (btn_triger = '0' ) then
            if ( cntrC < 7 ) then--could be lower and equal
                data_wr <= init_lowsimple(cntrC); 
                cntrC := cntrC +1 ;
            elsif ( cntrD < 7 ) then--could be lower and equal
                data_wr <= smile_WteethNhead(cntrD); 
                cntrD := cntrD +1 ;
            else 
                en_com <='0';
                busy_cntr <= 0;
                cntrC := 0;
                cntrD := 0;
                --bu iki satıc comb gözüküyormuş shared variable olarak çevirilebilinir 
                init_lowsimple(1) <= std_logic_vector ( unsigned(init_lowsimple(2)) + unsigned(one) );
                init_lowsimple(2) <= std_logic_vector ( unsigned(init_lowsimple(2)) + unsigned(sizeof_package) );
                
                if (init_lowsimple(2) = "0111111" ) then 
                    init_lowsimple(1) <="00000000" ;
                    init_lowsimple(2) <="00000111" ;
                    init_lowsimple(4) <= std_logic_vector ( unsigned(init_lowsimple(4)) + unsigned(one) ) ;
                    init_lowsimple(5) <= std_logic_vector ( unsigned(init_lowsimple(5)) + unsigned(one) ) ;
                    if (init_lowsimple(4) = "00000111" ) then 
                        init_lowsimple(4) <= "0000000" ;
                        init_lowsimple(5) <= "0000000" ;
                        
                    end if ;
                end if ;
                
            end if ;
        end if ;
  
    end if ;
    
end process ;

end Behavioral;
