# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "im_rom_depth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "im_rom_width_inbit" -parent ${Page_0}


}

proc update_PARAM_VALUE.im_rom_depth { PARAM_VALUE.im_rom_depth } {
	# Procedure called to update im_rom_depth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.im_rom_depth { PARAM_VALUE.im_rom_depth } {
	# Procedure called to validate im_rom_depth
	return true
}

proc update_PARAM_VALUE.im_rom_width_inbit { PARAM_VALUE.im_rom_width_inbit } {
	# Procedure called to update im_rom_width_inbit when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.im_rom_width_inbit { PARAM_VALUE.im_rom_width_inbit } {
	# Procedure called to validate im_rom_width_inbit
	return true
}


proc update_MODELPARAM_VALUE.im_rom_depth { MODELPARAM_VALUE.im_rom_depth PARAM_VALUE.im_rom_depth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.im_rom_depth}] ${MODELPARAM_VALUE.im_rom_depth}
}

proc update_MODELPARAM_VALUE.im_rom_width_inbit { MODELPARAM_VALUE.im_rom_width_inbit PARAM_VALUE.im_rom_width_inbit } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.im_rom_width_inbit}] ${MODELPARAM_VALUE.im_rom_width_inbit}
}

