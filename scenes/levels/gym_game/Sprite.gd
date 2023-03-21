class_name JumpBar

extends Sprite2D

var speed = 400
var angular_speed = PI - 1
var move_up = true
var move_at_all = true


func _input(event):
	if event.is_action_pressed("ui_select"):
		#here determine whether you stopped it at a good position or not
		if move_at_all == true:
			if position.y > 160 and position.y < 240:
				move_at_all = false

	elif event.is_action_pressed("ui_up"):
		if move_at_all == false:
			move_at_all = true


func _process(delta):
	# if not move_at_all:
	# 	return

	# position.y += (-1 if move_up else 1) * angular_speed + delta

	# if move_up:
	# 	if position.y > 90 and position.y < 110:
	# 		move_up = false
	# else:
	# 	if position.y > 290 and position.y < 310:
	# 		move_up = true

	var direction = 1

	if move_at_all == true:
		if move_up == true:
			position.y -= angular_speed + direction * delta
			if position.y > 90 and position.y < 110:
				move_up = false
		elif move_up == false:
			position.y += angular_speed + direction * delta
			if position.y > 290 and position.y < 310:
				move_up = true

	print(position.y)
	#rotation += angular_speed * direction * delta
