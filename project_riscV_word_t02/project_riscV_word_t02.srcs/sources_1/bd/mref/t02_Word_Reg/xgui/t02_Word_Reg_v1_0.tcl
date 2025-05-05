# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ram_depth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ram_length" -parent ${Page_0}


}

proc update_PARAM_VALUE.ram_depth { PARAM_VALUE.ram_depth } {
	# Procedure called to update ram_depth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ram_depth { PARAM_VALUE.ram_depth } {
	# Procedure called to validate ram_depth
	return true
}

proc update_PARAM_VALUE.ram_length { PARAM_VALUE.ram_length } {
	# Procedure called to update ram_length when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ram_length { PARAM_VALUE.ram_length } {
	# Procedure called to validate ram_length
	return true
}


proc update_MODELPARAM_VALUE.ram_length { MODELPARAM_VALUE.ram_length PARAM_VALUE.ram_length } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ram_length}] ${MODELPARAM_VALUE.ram_length}
}

proc update_MODELPARAM_VALUE.ram_depth { MODELPARAM_VALUE.ram_depth PARAM_VALUE.ram_depth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ram_depth}] ${MODELPARAM_VALUE.ram_depth}
}

