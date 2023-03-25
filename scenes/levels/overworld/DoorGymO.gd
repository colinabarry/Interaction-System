extends Area3D


var entered = false



func _on_body_entered(body: PhysicsBody3D):
	if body.is_in_group("player"):
		entered = true
		print("entered")
	

func _on_body_exited(body):
	if body.is_in_group("player"):
		print("exited")
		entered = false


func _process(delta):
	if entered:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://scenes/actors/game_base/game_base.tscn")
