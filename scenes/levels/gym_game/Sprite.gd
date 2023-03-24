extends Sprite2D

var speed = 400
var angular_speed = PI - 1
var move_up = true
var move_at_all = true

func _ready():
	Global.set_player_has_control(false)
	Global.set_is_in_minigame(true)
	Global.set_correct_input_jumpgame(true)
	pass

func _input(event):
	if event.is_action_pressed("ui_select"):
		#here determine whether you stopped it at a good position or not
		if move_at_all:
			if position.y > 160 and position.y < 240:
				move_at_all = false
				Global.set_correct_input_jumpgame(false)
	elif event.is_action_pressed("ui_up"):
		if not move_at_all:
			Global.set_correct_input_jumpgame(true)
			move_at_all = true


func _process(delta):
	var direction = 1

	if move_at_all:
		#Global.set_player_has_control(true)
		if move_up:
			position.y -= angular_speed + direction * delta
			if position.y > 40 and position.y < 60:
				move_up = false
		elif not move_up:
			#Global.set_player_has_control(false)
			position.y += angular_speed + direction * delta
			if position.y > 290 and position.y < 310:
				move_up = true

	print(position.y)
	#rotation += angular_speed * direction * delta
