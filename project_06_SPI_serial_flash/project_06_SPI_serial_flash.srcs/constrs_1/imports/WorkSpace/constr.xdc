# Clock related constraints
create_clock -period 10.000 -name CLK_top -waveform {0.000 5.000} [get_ports CLK_top]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_top]
set_property PACKAGE_PIN W5 [get_ports CLK_top]


#Basys3



#spi _ serial Flash pins
set_property IOSTANDARD LVCMOS33 [get_ports {CS}]

set_property IOSTANDARD LVCMOS33 [get_ports {SI}]
set_property IOSTANDARD LVCMOS33 [get_ports {SO}]
set_property PACKAGE_PIN K19 [get_ports {CS}]

set_property PACKAGE_PIN D18 [get_ports {SI}]
set_property PACKAGE_PIN D19 [get_ports {SO}]


#set_ property IO STANDARD LVCMOS33 [get_ ports {SCK}]#set_ property PACKAGE _PIN C11 [get_ ports {SCK}]----------------------  component STARTUPE2



set_property IOSTANDARD LVCMOS33 [get_ports {BTN_top[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_top[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_top[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_top[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTN_top[4]}]
set_property PACKAGE_PIN U18 [get_ports {BTN_top[0]}]
set_property PACKAGE_PIN U17 [get_ports {BTN_top[1]}]
set_property PACKAGE_PIN T18 [get_ports {BTN_top[2]}]
set_property PACKAGE_PIN T17 [get_ports {BTN_top[3]}]
set_property PACKAGE_PIN W19 [get_ports {BTN_top[4]}]
# center
#down
#up
#right
#left



set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_top[15]}]
set_property PACKAGE_PIN V17 [get_ports {SW_top[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW_top[1]}]
set_property PACKAGE_PIN W16 [get_ports {SW_top[2]}]
set_property PACKAGE_PIN W17 [get_ports {SW_top[3]}]
set_property PACKAGE_PIN W15 [get_ports {SW_top[4]}]
set_property PACKAGE_PIN V15 [get_ports {SW_top[5]}]
set_property PACKAGE_PIN W14 [get_ports {SW_top[6]}]
set_property PACKAGE_PIN W13 [get_ports {SW_top[7]}]
set_property PACKAGE_PIN V2 [get_ports {SW_top[8]}]
set_property PACKAGE_PIN T3 [get_ports {SW_top[9]}]
set_property PACKAGE_PIN T2 [get_ports {SW_top[10]}]
set_property PACKAGE_PIN R3 [get_ports {SW_top[11]}]
set_property PACKAGE_PIN W2 [get_ports {SW_top[12]}]
set_property PACKAGE_PIN U1 [get_ports {SW_top[13]}]
set_property PACKAGE_PIN T1 [get_ports {SW_top[14]}]
set_property PACKAGE_PIN R2 [get_ports {SW_top[15]}]




#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT4_top[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT4_top[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT4_top[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT4_top[3]}]
#set_property PACKAGE_PIN U2 [get_ports {SEGMENT4_top[0]}]
#set_property PACKAGE_PIN U4 [get_ports {SEGMENT4_top[1]}]
#set_property PACKAGE_PIN V4 [get_ports {SEGMENT4_top[2]}]
#set_property PACKAGE_PIN W4 [get_ports {SEGMENT4_top[3]}]



#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {SEGMENT7_top[7]}]
#set_property PACKAGE_PIN V7 [get_ports {SEGMENT7_top[0]}]
#set_property PACKAGE_PIN U7 [get_ports {SEGMENT7_top[1]}]
#set_property PACKAGE_PIN V5 [get_ports {SEGMENT7_top[2]}]
#set_property PACKAGE_PIN U5 [get_ports {SEGMENT7_top[3]}]
#set_property PACKAGE_PIN V8 [get_ports {SEGMENT7_top[4]}]
#set_property PACKAGE_PIN U8 [get_ports {SEGMENT7_top[5]}]
#set_property PACKAGE_PIN W6 [get_ports {SEGMENT7_top[6]}]
#set_property PACKAGE_PIN W7 [get_ports {SEGMENT7_top[7]}]
## C A
## C B
## C C
## C D
## C E
## C F
## C G
## C p



set_property PACKAGE_PIN U16 [get_ports {LED_top[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED_top[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED_top[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED_top[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED_top[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED_top[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED_top[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED_top[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED_top[8]}]
set_property PACKAGE_PIN V3 [get_ports {LED_top[9]}]
set_property PACKAGE_PIN W3 [get_ports {LED_top[10]}]
set_property PACKAGE_PIN U3 [get_ports {LED_top[11]}]
set_property PACKAGE_PIN P3 [get_ports {LED_top[12]}]
set_property PACKAGE_PIN N3 [get_ports {LED_top[13]}]
set_property PACKAGE_PIN P1 [get_ports {LED_top[14]}]
set_property PACKAGE_PIN L1 [get_ports {LED_top[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_top[15]}]



