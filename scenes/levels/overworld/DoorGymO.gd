extends Area3D

var entered = false


func _on_body_entered(body: PhysicsBody3D):
	if body.is_in_group("player"):
		entered = true
		#print("entered")


func _on_body_exited(body):
	if body.is_in_group("player"):
		#print("exited")
		entered = false


func _process(_delta):
	if entered:
		if Global.progress_state >= Global.PROGRESS_STATE.HOSPITAL_COMPLETED:
			if Input.is_action_just_pressed("input_interact"):
				Global.set_progress_state(Global.PROGRESS_STATE.GYM_ENTERED)
				get_tree().change_scene_to_file("res://scenes/levels/gym_game/jumpbar_mini.tscn")
