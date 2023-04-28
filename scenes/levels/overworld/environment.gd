extends WorldEnvironment


func _ready() -> void:
	environment.sdfgi_enabled = Settings.global_illumination_enabled
	environment.ssao_enabled = Settings.ambient_occlusion_enabled
	environment.fog_enabled = Settings.fog_enabled

	Settings.global_illumination_toggled.connect(func(val): environment.sdfgi_enabled = val)
	Settings.ambient_occlusion_toggled.connect(func(val): environment.ssao_enabled = val)
	Settings.fog_toggled.connect(func(val): environment.fog_enabled = val)
