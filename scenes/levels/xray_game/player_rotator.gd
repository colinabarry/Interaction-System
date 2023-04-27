extends HSlider

@onready var player := get_tree().current_scene.get_node("XRayMegan")


func _on_value_changed(value: float):
	player.rotation_degrees.y = value
