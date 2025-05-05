# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "X_clkHz" -parent ${Page_0}
  ipgui::add_param $IPINST -name "debounce_max" -parent ${Page_0}


}

proc update_PARAM_VALUE.X_clkHz { PARAM_VALUE.X_clkHz } {
	# Procedure called to update X_clkHz when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_clkHz { PARAM_VALUE.X_clkHz } {
	# Procedure called to validate X_clkHz
	return true
}

proc update_PARAM_VALUE.debounce_max { PARAM_VALUE.debounce_max } {
	# Procedure called to update debounce_max when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.debounce_max { PARAM_VALUE.debounce_max } {
	# Procedure called to validate debounce_max
	return true
}


proc update_MODELPARAM_VALUE.X_clkHz { MODELPARAM_VALUE.X_clkHz PARAM_VALUE.X_clkHz } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_clkHz}] ${MODELPARAM_VALUE.X_clkHz}
}

proc update_MODELPARAM_VALUE.debounce_max { MODELPARAM_VALUE.debounce_max PARAM_VALUE.debounce_max } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.debounce_max}] ${MODELPARAM_VALUE.debounce_max}
}

