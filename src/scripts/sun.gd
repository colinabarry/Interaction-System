extends DirectionalLight3D


func _ready() -> void:
	shadow_enabled = Settings.sun_shadows_enabled
	directional_shadow_mode = (
		DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
		if Settings.high_fidelity_shadows_enabled
		else DirectionalLight3D.SHADOW_ORTHOGONAL
	)

	Settings.sun_shadows_toggled.connect(func(val): shadow_enabled = val)
	Settings.high_fidelity_shadows_toggled.connect(
		func(val): directional_shadow_mode = (
			DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
			if val
			else DirectionalLight3D.SHADOW_ORTHOGONAL
		)
	)
