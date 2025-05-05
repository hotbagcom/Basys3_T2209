----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2025 10:14:55
-- Design Name: 
-- Module Name: p06_serialflash_cntrlREG - Behavioral_serialflash_cntrlREG
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

entity p06_serialflash_cntrlREG is
    Port ( 
        Mclk_i : in std_logic := '0' ;
        vect_McRegi : in std_logic_vector( 7 downto 0) ;
        vect_McREGo : out std_logic_vector( 7 downto 0) := (others=>'0');
        spiMCore_en :  out std_logic := '0' ;
        data_ready : in std_logic := '0' ;
        external_triger_btn : in std_logic_vector( 4 downto 0) := "00000" 
        
        
        
    );
end p06_serialflash_cntrlREG;

architecture Behavioral_serialflash_cntrlREG of p06_serialflash_cntrlREG is


Signal S_spiMCore_en : std_logic := '0';


signal command1read : std_logic_vector(7 downto 0) :=  X"03";
signal read_Comnd_cntr : integer range 0 to 3 := 0 ; -- bu status gibi kullanýlýyor . commant1 command 2 adress 1 adress2 adress3 dummy gibi deðerler eklenebilinir . 
signal MemAdr_onSerialflash : std_logic_vector(23 downto 0) :=  X"000000";
signal memadr0 : std_logic_vector(7 downto 0) :=  X"00";
signal memadr1 : std_logic_vector(7 downto 0) :=  X"00";
signal memadr2 : std_logic_vector(7 downto 0) :=  X"00";
signal package_length : integer range 0 to 12 :=  0;
signal S_data_ready : std_logic :=  '0';
signal willbereaden : std_logic :=  '0';
signal S_external_triger_btn : std_logic_vector( 4 downto 0)  := "00000" ;

signal last_command : std_logic_vector( 7 downto 0) ;
signal registr :  std_logic_vector(7 downto 0) :=  X"00";


constant oneinslv : std_logic_vector(3 downto 0) := X"1" ;

begin

process ( external_triger_btn  ) begin 
    if (  rising_edge(external_triger_btn(0))  ) then
        package_length <= 1 ;
    end if ;
end process ;


process(   external_triger_btn , S_data_ready , vect_McRegi , package_length) begin 
    
    if ( rising_edge(external_triger_btn(1)) or (( package_length > 0 or vect_McRegi = X"00"  )and  S_data_ready = '1') ) then
        
        package_length <= package_length -1 ;
            case read_Comnd_cntr is
                when   0 =>
                    package_length <= 4;
                    vect_McREGo <= command1read ;
                    last_command <= command1read ;
                    read_Comnd_cntr <= 1;
                when   1 =>
                    read_Comnd_cntr <= 2;
                    vect_McREGo <= MemAdr_onSerialflash( 23 downto 16);
                when   2 =>
                    read_Comnd_cntr <= 3;
                    vect_McREGo <= MemAdr_onSerialflash( 15 downto 8);
                when   3 =>
                    read_Comnd_cntr <= 0;
                    vect_McREGo <= MemAdr_onSerialflash( 7 downto 0);
                when   others =>
                
            end case ;   
            
        end if ;
        
        

end process ;



process( data_ready , last_command) begin 

    if ( rising_edge(data_ready)) then 
        S_data_ready <= '1' ;
        if (package_length = 1 and last_command = command1read )then
            registr <= vect_McRegi;
            package_length <= 0;
            S_data_ready <= '0' ;
        elsif (package_length = 0 and last_command = command1read  ) then  
            last_command <= X"00" ;
            MemAdr_onSerialflash <= std_logic_vector(     unsigned(MemAdr_onSerialflash)+ unsigned( oneinslv  )     );
        end if ;
    end if ;

   
end process ;








end Behavioral_serialflash_cntrlREG;
