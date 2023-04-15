extends Area3D


func _on_body_entered(body: Node3D) -> void:
	print("entered ", body.name, " child of ", body.get_parent().name)
