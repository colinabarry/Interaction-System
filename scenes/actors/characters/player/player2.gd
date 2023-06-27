extends CharacterBody3D

#How fast the player moves in meters per second
@export var speed = 14
#The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

signal hit

func _physics_process(delta):
	#We create a local variable to store the input direction
	var direction = Vector3.ZERO
	
	#We check for each move input and update the direction accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_forward"):
		direction.z += -1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		
	#Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#Vertical Velocity
	if not is_on_floor(): #If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	#Moving the Character
	velocity = target_velocity
	move_and_slide()
	
signal player_dead

func die():
	hit.emit()
	player_dead.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
