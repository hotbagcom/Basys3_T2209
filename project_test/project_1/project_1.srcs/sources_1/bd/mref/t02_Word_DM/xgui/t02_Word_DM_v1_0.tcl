# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "dm_depth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "dm_length" -parent ${Page_0}


}

proc update_PARAM_VALUE.dm_depth { PARAM_VALUE.dm_depth } {
	# Procedure called to update dm_depth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.dm_depth { PARAM_VALUE.dm_depth } {
	# Procedure called to validate dm_depth
	return true
}

proc update_PARAM_VALUE.dm_length { PARAM_VALUE.dm_length } {
	# Procedure called to update dm_length when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.dm_length { PARAM_VALUE.dm_length } {
	# Procedure called to validate dm_length
	return true
}


proc update_MODELPARAM_VALUE.dm_length { MODELPARAM_VALUE.dm_length PARAM_VALUE.dm_length } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.dm_length}] ${MODELPARAM_VALUE.dm_length}
}

proc update_MODELPARAM_VALUE.dm_depth { MODELPARAM_VALUE.dm_depth PARAM_VALUE.dm_depth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.dm_depth}] ${MODELPARAM_VALUE.dm_depth}
}

