extends TextureRect

var blur_amount := 2.0
var options_fade_time := 0.1

@onready var pause_options := $CenterContainer/PauseOptions
@onready var graphics_options := $CenterContainer/GraphicsOptions

@onready var graphics_options_buttons := graphics_options.get_children().filter(
	func(child): return child is CheckButton
)


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	Settings.global_illumination_enabled = graphics_options_buttons[0].button_pressed
	Settings.ambient_occlusion_enabled = graphics_options_buttons[1].button_pressed
	Settings.fog_enabled = graphics_options_buttons[2].button_pressed
	Settings.sun_shadows_enabled = graphics_options_buttons[3].button_pressed
	Settings.high_fidelity_shadows_enabled = graphics_options_buttons[4].button_pressed
	Settings.high_fidelity_trees_enabled = graphics_options_buttons[5].button_pressed


func show_menu() -> void:
	Global.show_mouse()

	graphics_options.visible = false
	pause_options.visible = true
	graphics_options.modulate = Color.TRANSPARENT
	pause_options.modulate = Color.WHITE

	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	visible = true
	# fade menu in
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	# blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", blur_amount, 0.25)


func hide_menu() -> void:
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	# fade menu out
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	# un-blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", 0.0, 0.25)

	await tween.finished
	visible = false


func _on_resume_pressed() -> void:
	Global.resume()


func _on_options_pressed():
	graphics_options.modulate = Color.TRANSPARENT
	graphics_options.visible = true
	await Global.tween_cubic_modulate(pause_options, Color.TRANSPARENT, options_fade_time).finished
	await Global.tween_cubic_modulate(graphics_options, Color.WHITE, options_fade_time).finished
	pause_options.visible = false


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/user_interfaces/start_menu/start_menu.tscn")
	Global.resume()  # TODO: GIVE MOUSE CONTROL BACK


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_global_illumination_toggled(button_pressed: bool):
	Settings.global_illumination_enabled = button_pressed


func _on_ambient_occlusion_toggled(button_pressed: bool) -> void:
	Settings.ambient_occlusion_enabled = button_pressed


func _on_fog_toggled(button_pressed: bool) -> void:
	Settings.fog_enabled = button_pressed


func _on_sun_shadows_toggled(button_pressed: bool):
	Settings.sun_shadows_enabled = button_pressed


func _on_high_fidelity_shadows_toggled(button_pressed: bool):
	Settings.high_fidelity_shadows_enabled = button_pressed


func _on_high_fidelity_trees_toggled(button_pressed: bool):
	Settings.high_fidelity_trees_enabled = button_pressed


func _on_back_pressed():
	pause_options.modulate = Color.TRANSPARENT
	pause_options.visible = true
	await (
		Global.tween_cubic_modulate(graphics_options, Color.TRANSPARENT, options_fade_time).finished
	)
	await Global.tween_cubic_modulate(pause_options, Color.WHITE, options_fade_time).finished
	graphics_options.visible = false
