extends Node

signal global_illumination_toggled(val: bool)
signal ambient_occlusion_toggled(val: bool)
signal fog_toggled(val: bool)
signal sun_shadows_toggled(val: bool)
signal high_fidelity_shadows_toggled(val: bool)
signal high_fidelity_trees_toggled(val: bool)

var global_illumination_enabled := true:
	set(val):
		global_illumination_enabled = val
		global_illumination_toggled.emit(val)
var ambient_occlusion_enabled := true:
	set(val):
		ambient_occlusion_enabled = val
		ambient_occlusion_toggled.emit(val)
var fog_enabled := true:
	set(val):
		fog_enabled = val
		fog_toggled.emit(val)
var sun_shadows_enabled := true:
	set(val):
		sun_shadows_enabled = val
		sun_shadows_toggled.emit(val)
var high_fidelity_shadows_enabled := true:
	set(val):
		high_fidelity_shadows_enabled = val
		high_fidelity_shadows_toggled.emit(val)
var high_fidelity_trees_enabled := true:
	set(val):
		high_fidelity_trees_enabled = val
		high_fidelity_trees_toggled.emit(val)
