extends DirectionalLight3D


func _physics_process(_delta: float) -> void:
	self.rotate_x(0.001)
