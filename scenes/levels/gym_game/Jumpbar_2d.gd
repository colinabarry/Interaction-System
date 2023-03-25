extends Sprite2D

var speed = 400
var angular_speed = PI - 1
var move_up = true
var move_at_all = true
var difficulty
var mini_in_prog

func _ready():
	Global.set_player_has_control(false)
	Global.set_is_in_minigame(true)
	Global.set_correct_input_jumpgame(true)

	mini_in_prog = true
	difficulty = 1
	pass

func _input(event):
	if not mini_in_prog:
		return
	
	if event.is_action_pressed("ui_select"):
		#here determine whether you stopped it at a good position or not
		if move_at_all:
			match difficulty:
				1:
					if position.y > 140 and position.y < 240:
						move_at_all = false
						Global.set_correct_input_jumpgame(false)
				2:
					if position.y > 160 and position.y < 220:
						move_at_all = false
						Global.set_correct_input_jumpgame(false)
				3:
					if position.y > 180 and position.y < 200:
						move_at_all = false
						Global.set_correct_input_jumpgame(false)
	elif event.is_action_pressed("ui_up"):
		if not move_at_all:
			change_difficulty()
			Global.set_correct_input_jumpgame(true)
			move_at_all = true

func change_difficulty():
	match difficulty:
		1:
			difficulty = 2
			Global.set_jumpmini_global_diff(difficulty)
		2:
			difficulty = 3
			Global.set_jumpmini_global_diff(difficulty)
		3:
			end_mini()	
	pass

func end_mini():
	mini_in_prog = false
	pass

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
