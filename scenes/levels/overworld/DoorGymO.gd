extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var entered = false



func _on_body_entered(body: PhysicsBody3D):
	entered = true



func _on_body_exited(body):
	entered = false


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/levels/gym_game/jump_2d.tscn")
