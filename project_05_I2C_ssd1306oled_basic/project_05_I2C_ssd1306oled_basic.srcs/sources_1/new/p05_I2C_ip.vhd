----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2025 18:49:02
-- Design Name: 
-- Module Name: p05_I2C_ip - Behavioral_I2C_ip
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

entity p05_I2C_ip is
    Generic (
        mainCristal : integer := 100_000_000 ;
        spiCom_speedTYPE : std_logic_vector(1 downto 0) := "01"
    );
    Port ( 
        Xclk : in std_logic := '0'; --system clk
        
        btn_triger : in std_logic := '0';--temporarry solution 
        
        --request4moduls : inout std_logic ;   actiavated for multi device mode 
        --module_bus : inout std_logic_vector(7 downto 0)  ;
        Serial_Clk : out std_logic := '1'; --400kbps(kilo bit per second) 
        Serial_Com : inout std_logic:= '1';
        valid_transfer : out std_logic := '0' 
           
    );
               
end p05_I2C_ip;



architecture Behavioral_I2C_ip of p05_I2C_ip is


-------------------------types----------------------

type state_types is ( READY , START , COMMAND ,ACK , DATA , ACK2 , STOP);
type INNFO8x8 is  array(0 to 7) of std_logic_vector(7 downto 0)  ;


----------------------constant----------------------




----------------------signals-----------------------
signal I2C_state : state_types := READY ;
signal final_package_bfr_ack : std_logic := '0';
signal S_Serial_Clk : std_logic := '0';
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
signal init_lowsimple : INNFO8x8 := 
(
"01111000", --ID(6 downto 0) + R_W*
"00100001", --Set Memory Addressing Mode 
--[  0010_00xx ---> {00(Horizontal)} , {01(Vertical)} , {10()Page adressigmode,"RESET"} , {11(Invalid) ]
"00000000" , -- Starting colum adress
"00000111" , -- Stoping colum adress
"00100010", -- Set Page Addressing Mode 
"00000000" , -- Starting Page adress
"00000000" , -- Stoping PAge adress
"01000000"  --Start data transmission command
);


----------------------variable-----------------------
shared variable  spiPeriode_limit : integer := 250 ;

shared variable  spiPeriode_count : integer range 0 to 1000 := 1 ;
--shared variable  INNFO8x8_tracker1 : integer  range 0 to 7 := 0 ;
--shared variable  INNFO8x8_tracker2 : std_logic_vector(7 downto 0) := X"00" ;
 

begin




--Generate_Spi_clock :
--process ( Xclk ) begin
--    if ( I2C_state /= READY ) then
--        if ( spiPeriode_count = spiPeriode_limit ) then
--            S_Serial_Clk <= not S_Serial_Clk ;
--            spiPeriode_count := 0 ;
--        else 
--            spiPeriode_count := spiPeriode_count + 1 ;
--        end if ;
--    end if ; 
        
--end process ;



--Output_triger_to_initiate_program :
--process (  btn_triger ) begin 

--    if ( falling_edge(btn_triger) ) then
--        I2C_state <= START ; 
--        S_Serial_Clk <= '1' ;  
--        final_package_bfr_ack <= '0';
--    end if;
    
--end process ;


--Produce_SDA_low_to_START_program : 
--process ( Xclk ) begin
--    if ( I2C_state = START ) then
--        Serial_Com <= '0' ;
--        I2C_state <= COMMAND ;
--        --INNFO8x8_tracker2 := X"00"; 
--        --INNFO8x8_tracker1 := 0 ;
--    end if ;     
--end process ;

--Begin_to_send_initial_commands : 
--process ( S_Serial_Clk ) begin 
--    if ( falling_edge(S_Serial_Clk) ) then
--        if ( I2C_state = COMMAND ) then
--            for INNFO8x8_tracker1 in 0 to 7  loop
--                valid_transfer <= '0' ;
--                for INNFO8x8_tracker2 in 0 to 7  loop
--  Serial_Com <= init_lowsimple(INNFO8x8_tracker1)( INNFO8x8_tracker2 );
--                    if ( INNFO8x8_tracker1 = 7 and INNFO8x8_tracker2 = 7 ) then
--                        final_package_bfr_ack <= '1';
--                    end if ;
--                end loop ; 
--                --sended an one packege wait for acknowledge 
--                I2C_state <= ACK ;
--            end loop ; 
--        end if;
--    end if ; 
--end process  ; 

--Check_the_command_received_by_slave :
--process ( S_Serial_Clk ) begin 
--    if ( rising_edge(S_Serial_Clk) ) then
--        if ( I2C_state = ACK ) then
--            if ( Serial_Com = '0' ) then
--                if ( final_package_bfr_ack = '1' ) then
--                    I2C_state <= DATA ;
--                    final_package_bfr_ack <= '0' ;
--                else 
--                    I2C_state <= COMMAND ;
--                end if;
--                valid_transfer <= '1';
--            end if ;
--        end if;
--    end if ; 
--end process  ; 

--process ( S_Serial_Clk ) begin 
--    if ( falling_edge(S_Serial_Clk) ) then
--        if ( I2C_state = DATA ) then
--            for INNFO8x8_tracker1 in 0 to 7  loop
--                valid_transfer <= '0' ;
--                for INNFO8x8_tracker2 in 0 to 7  loop
--  Serial_Com <= smile_WteethNhead(INNFO8x8_tracker1)( INNFO8x8_tracker2 );
--                    if ( INNFO8x8_tracker1 = 7 and INNFO8x8_tracker2 = 7 ) then
--                        final_package_bfr_ack <= '1';
--                    end if ;
--                end loop ; 
--                --sended an one packege wait for acknowledge 
--                I2C_state <= ACK2 ;
--            end loop ; 
--        end if;
--    end if ; 
--end process  ; 

--Check_the_data_received_by_slave :
--process ( S_Serial_Clk ) begin 
--    if ( rising_edge(S_Serial_Clk) ) then
--        if ( I2C_state = ACK2 ) then
--            if ( Serial_Com = '0' ) then
--                if ( final_package_bfr_ack = '1' ) then
--                    I2C_state <= STOP ;
--                    final_package_bfr_ack <= '0' ;
--                else 
--                    I2C_state <= DATA ;
--                end if;     
--                valid_transfer <= '1';
--            end if ;
--        end if;
--    end if ; 
--end process  ; 


--Produce_SDA_high_to_STOP_program :
--process ( S_Serial_Clk ) begin 
--    if ( falling_edge(S_Serial_Clk) ) then
--        if ( I2C_state = STOP ) then
--            I2C_state <= READY ;
--            Serial_Com <= '1' ;
--            S_Serial_Clk <= '1' ;  
--            spiPeriode_count := 0 ;
--        end if;
--    end if ; 
--end process  ; 


--process (S_Serial_Clk) begin 
--    Serial_Clk <= S_Serial_Clk ; 
--end process ;


-----------------------------------------------------------------
process ( Xclk ) begin
    if ( I2C_state /= READY ) then
        
    
        if ( spiPeriode_count = spiPeriode_limit ) then
            S_Serial_Clk <= not S_Serial_Clk ;
            spiPeriode_count := 0 ;
        else 
            spiPeriode_count := spiPeriode_count + 1 ;
        end if ;
        
    
    end if ; 
        
end process ;

process (  btn_triger ) begin 

    if ( falling_edge(btn_triger) ) then
        --I2C_state <= START ; 
        S_Serial_Clk <= '1' ;  
        Serial_Com <= '0' ;
        I2C_state <= COMMAND ;
        final_package_bfr_ack <= '0';
    end if;
    
end process ;

process ( S_Serial_Clk ) begin 
    if ( falling_edge(S_Serial_Clk) ) then
        if ( I2C_state = COMMAND ) then
            for INNFO8x8_tracker1 in 0 to 7  loop
                valid_transfer <= '0' ;
                for INNFO8x8_tracker2 in 0 to 7  loop
  Serial_Com <= init_lowsimple(INNFO8x8_tracker1)( INNFO8x8_tracker2 );
                    if ( INNFO8x8_tracker1 = 7 and INNFO8x8_tracker2 = 7 ) then
                        final_package_bfr_ack <= '1';
                    end if ;
                end loop ; 
                --sended an one packege wait for acknowledge 
                I2C_state <= ACK ;
            end loop ; 
        elsif ( I2C_state = DATA ) then
            for INNFO8x8_tracker1 in 0 to 7  loop
                valid_transfer <= '0' ;
                for INNFO8x8_tracker2 in 0 to 7  loop
  Serial_Com <= smile_WteethNhead(INNFO8x8_tracker1)( INNFO8x8_tracker2 );
                    if ( INNFO8x8_tracker1 = 7 and INNFO8x8_tracker2 = 7 ) then
                        final_package_bfr_ack <= '1';
                    end if ;
                end loop ; 
                --sended an one packege wait for acknowledge 
                I2C_state <= ACK2 ;
            end loop ; 
        elsif ( I2C_state = STOP ) then
            I2C_state <= READY ;
            Serial_Com <= '1' ;
            S_Serial_Clk <= '1' ;  
            spiPeriode_count := 0 ;
        end if;
    end if;
end process  ; 


process ( S_Serial_Clk ) begin    
    if ( rising_edge(S_Serial_Clk) ) then
    Serial_Com <= 'Z' ;
        if ( I2C_state = ACK ) then
            if ( Serial_Com = '0' ) then
                if ( final_package_bfr_ack = '1' ) then
                    I2C_state <= DATA ;
                    final_package_bfr_ack <= '0' ;
                else 
                    I2C_state <= COMMAND ;
                end if;
                valid_transfer <= '1';
            end if ;
        elsif ( I2C_state = ACK2 ) then
            if ( Serial_Com = '0' ) then
                if ( final_package_bfr_ack = '1' ) then
                    I2C_state <= STOP ;
                    final_package_bfr_ack <= '0' ;
                else 
                    I2C_state <= DATA ;
                end if;     
                valid_transfer <= '1';
            end if ;
        end if;
    end if ; 
end process  ; 





end Behavioral_I2C_ip;
