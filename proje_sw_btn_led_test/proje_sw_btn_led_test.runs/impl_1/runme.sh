#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=C:/Users/arify/Prog_4_user/Xlixv20_1/Vitis/2020.1/bin;C:/Users/arify/Prog_4_user/Xlixv20_1/Vivado/2020.1/ids_lite/ISE/bin/nt64;C:/Users/arify/Prog_4_user/Xlixv20_1/Vivado/2020.1/ids_lite/ISE/lib/nt64:C:/Users/arify/Prog_4_user/Xlixv20_1/Vivado/2020.1/bin
else
  PATH=C:/Users/arify/Prog_4_user/Xlixv20_1/Vitis/2020.1/bin;C:/Users/arify/Prog_4_user/Xlixv20_1/Vivado/2020.1/ids_lite/ISE/bin/nt64;C:/Users/arify/Prog_4_user/Xlixv20_1/Vivado/2020.1/ids_lite/ISE/lib/nt64:C:/Users/arify/Prog_4_user/Xlixv20_1/Vivado/2020.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='C:/Users/arify/WorkSpace/Basys3_T2209/proje_sw_btn_led_test/proje_sw_btn_led_test.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log test_module.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source test_module.tcl -notrace


