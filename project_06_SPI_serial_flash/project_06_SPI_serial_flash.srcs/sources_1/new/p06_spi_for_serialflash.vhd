----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2025 17:13:47
-- Design Name: 
-- Module Name:  - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p06_spi_for_serailflash is
    Generic (
        Xclk_freq 		: integer := 100_000_000;
        spiClk_freq 		: integer := 400_000;
        Cpol         : std_logic := '0' ;
        Cpha         : std_logic := '0'
    );
    Port ( 
        Mclk_i : in std_logic := '0' ;
        
        vect_Mi : in std_logic_vector( 7 downto 0) := (others=>'0');
        vect_Mo : out std_logic_vector( 7 downto 0) := (others=>'0');
        spiMCore_en :  in std_logic := '0' ;
        data_ready : out std_logic := '0' ;
        
        spiClk_o : out std_logic := '0' ;
        miso : in std_logic := '0' ;
        mosi : out std_logic := '0' ;
        SlvSlkt : out std_logic := '0' 
    );
end p06_spi_for_serailflash;

architecture Behavioral of p06_spi_for_serailflash is


--------Constant 
constant clk2spiClk_counter	: integer := Xclk_freq/(spiClk_freq*2);
 
--------Signal
signal reg_w	: std_logic_vector( 7 downto 0) := (others=>'0');
signal reg_r	: std_logic_vector( 7 downto 0) := (others=>'0');

signal S_spiClk_en	  : std_logic := '0';
signal S_spiClk		  : std_logic := '0';
signal S_spiClk_pre   : std_logic := '0';
signal S_spiClk_rise  : std_logic := '0';
signal S_spiClk_fall  : std_logic := '0';
signal S_c_polpha     : std_logic_vector(1 downto 0) := "00";
signal S_mosi_en      : std_logic := '0';
signal S_miso_en      : std_logic := '0';
signal S_ps_flag      : std_logic := '0';
signal S_edge_cntr    : integer range 0 to  (clk2spiClk_counter) := 0;
signal S_cntr         : integer range 0 to 15 := 0;

--------type
type T_states is ( T_IDLE , T_TRANSFER );
signal spi_state : T_states := T_IDLE ;


begin

S_c_polpha <= Cpol & Cpha ;

process ( S_c_polpha , S_spiClk_rise , S_spiClk_fall ) begin 
    case S_c_polpha is
        when "00" => 
            S_mosi_en <= S_spiClk_fall ;
            S_miso_en <= S_spiClk_rise ;
        when "01" => 
            S_mosi_en <= S_spiClk_rise ;
            S_miso_en <= S_spiClk_fall ;
        when "10" => 
            S_mosi_en <= S_spiClk_rise ;
            S_miso_en <= S_spiClk_fall ;
        when "11" => 
            S_mosi_en <= S_spiClk_fall ;
            S_miso_en <= S_spiClk_rise ;
        when others =>
    end case ;          
            
end process ;


process ( S_spiClk ) begin 
    if ( S_spiClk_pre = '0' and S_spiClk = '1' ) then
        S_spiClk_rise <= '1';
    else 
        S_spiClk_fall <= '0';
    end if ;

    if ( S_spiClk_pre = '1' and S_spiClk = '0'  ) then
        S_spiClk_fall <= '1';
    else 
        S_spiClk_rise <= '0';
    end if ;
    
end process ;


process ( Mclk_i ) begin
    if ( rising_edge(Mclk_i) )then
        data_ready <= '0';
        S_spiClk_pre <= S_spiClk ;
        
        case  (spi_state) is
            
            when T_IDLE =>
                SlvSlkt     <= '1';
                mosi        <= '0';
                data_ready  <= '0';
                S_spiClk_en <= '0';
                S_cntr      <=  0 ;
                
                if ( Cpol = '0') then 
                    spiClk_o <= '0' ;
                else
                    spiClk_o <= '1' ;
                end if ;
                
                if (spiMCore_en = '1' ) then 
                    spi_state   <= T_TRANSFER ;
                    S_spiClk_en <= '1' ;
                    reg_r       <= X"00";
                    reg_w       <= vect_Mi;
                    mosi        <= vect_Mi(7);
                end if ;
                
            when T_TRANSFER =>
                
                SlvSlkt <= '0';
                mosi    <= reg_w(7);
                
                if ( Cpha = '1' ) then
                    if ( S_cntr=0 )then
                        spiClk_o <= S_spiClk;
                    
                        if ( S_miso_en = '1' ) then
                            reg_r(0) <= miso ;
                            reg_r( 7 downto 1 ) <= reg_r( 6 downto 0 ) ;
                            S_cntr <= S_cntr + 1 ;
                            S_ps_flag <= '1';
                        end if ;
                    
                    elsif ( S_cntr=8 ) then
                    
                        if ( S_ps_flag = '1' ) then
                            data_ready  <= '0';
                            S_ps_flag <= '0';
                        end if ;
                        vect_Mo  <= reg_r ;
                        if ( S_mosi_en = '1' ) then
                            if ( spiMCore_en = '1' ) then
                                reg_w <= vect_Mi ;
                                mosi <= vect_Mi(7) ;
                                spiClk_o <= S_spiClk;
                                S_cntr <= 0; 
                            else
                                spi_state   <= T_IDLE ;
                                SlvSlkt     <= '1';
                            end if ;
                        end if ;
                    
                    elsif ( S_cntr=9 ) then
                    
                        if ( spiMCore_en = '1' ) then
                                spi_state   <= T_IDLE ;
                                SlvSlkt     <= '1';
                        end if ;                
                            
                    else                  
                        spiClk_o <= S_spiClk;
                        if ( spiMCore_en = '1' ) then
                            reg_r(0) <= miso ;
                            reg_r( 7 downto 1 ) <= reg_r( 6 downto 0 ) ;
                            S_cntr <= S_cntr + 1 ;
                        end if ;
                        if ( spiMCore_en = '1' ) then
                            mosi <= reg_w(7);
                            reg_w( 7 downto 1 ) <= reg_w( 6 downto 0 );
                        end if ;
                    
                    end if ;
                    
                else --Cpha = '0' 
                    if ( S_cntr=0 )then
                        spiClk_o <= S_spiClk;
                    
                        if ( S_miso_en = '1' ) then
                            reg_r(0) <= miso ;
                            reg_r( 7 downto 1 ) <= reg_r( 6 downto 0 ) ;
                            S_cntr <= S_cntr + 1 ;
                            S_ps_flag <= '1';
                        end if ;
                    
                    elsif ( S_cntr=8 ) then
                    
                        if ( S_ps_flag = '1' ) then
                            data_ready  <= '1';
                            S_ps_flag <= '0';
                        end if ;
                        vect_Mo  <= reg_r ;
                        spiClk_o <= S_spiClk;
                        if ( S_mosi_en = '1' ) then
                            if ( spiMCore_en = '1' ) then
                                reg_w <= vect_Mi ;
                                mosi <= vect_Mi(7) ;
                                S_cntr <= 0; 
                            else
                                S_cntr <= S_cntr + 1 ;
                            end if ;
                            if ( spiMCore_en = '1' ) then
                                spi_state   <= T_IDLE ;
                                SlvSlkt     <= '1';
                            end if ;  
                        end if ;  
                    elsif ( S_cntr=9 ) then
                    
                        if ( spiMCore_en = '1' ) then
                                spi_state   <= T_IDLE ;
                                SlvSlkt     <= '1';
                        end if ;                
                            
                    else                  
                        spiClk_o <= S_spiClk;
                        if ( spiMCore_en = '1' ) then
                            reg_r(0) <= miso ;
                            reg_r( 7 downto 1 ) <= reg_r( 6 downto 0 ) ;
                            S_cntr <= S_cntr + 1 ;
                        end if ;
                        if ( spiMCore_en = '1' ) then
                            reg_w( 7 downto 1 ) <= reg_w( 6 downto 0 );
                        end if ;
                    
                    end if ;
                
                end if ;
                
                
            when OTHERS =>
            
        end case ;

    end if ;--ernd of rising edge of Master clk

end process ;
   




process ( Mclk_i ) begin 
    if ( rising_edge(Mclk_i) ) then 
        if ( S_spiClk_en = '1' ) then 
            if (S_edge_cntr   = clk2spiClk_counter-1 ) then
                S_spiClk <= not S_spiClk ;
                S_edge_cntr <= 0;
            else 
                S_edge_cntr <= S_edge_cntr + 1 ;
            end if ;
        else
        S_edge_cntr <= 0;
            if ( Cpol = '0' ) then
                S_spiClk <= '0' ;
            else
                S_spiClk <= '0' ;
            end if ;
        end if;
    end if ;

end process ;





end Behavioral;
