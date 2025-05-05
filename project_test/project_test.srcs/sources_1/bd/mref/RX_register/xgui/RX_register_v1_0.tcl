# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "X_clk" -parent ${Page_0}
  ipgui::add_param $IPINST -name "baudrate" -parent ${Page_0}


}

proc update_PARAM_VALUE.X_clk { PARAM_VALUE.X_clk } {
	# Procedure called to update X_clk when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_clk { PARAM_VALUE.X_clk } {
	# Procedure called to validate X_clk
	return true
}

proc update_PARAM_VALUE.baudrate { PARAM_VALUE.baudrate } {
	# Procedure called to update baudrate when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.baudrate { PARAM_VALUE.baudrate } {
	# Procedure called to validate baudrate
	return true
}


proc update_MODELPARAM_VALUE.X_clk { MODELPARAM_VALUE.X_clk PARAM_VALUE.X_clk } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_clk}] ${MODELPARAM_VALUE.X_clk}
}

proc update_MODELPARAM_VALUE.baudrate { MODELPARAM_VALUE.baudrate PARAM_VALUE.baudrate } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.baudrate}] ${MODELPARAM_VALUE.baudrate}
}

