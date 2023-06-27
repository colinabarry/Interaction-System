class_name BalanceMinigame extends Node2D

signal minigame_completed

@onready var player: NewPlayer = $"../Player"
@onready var lil_dude: Area2D = $LilDude
@onready var bar: Sprite2D = $Bar
@onready var target: Area2D = $Target
@onready var ui_hint: Control = $UI_overlay
@onready var you_win: Button = $YouWinButton

const DECAY_FACTOR = 0.3
#const MAX_DIFFICULTY = 2
const SPEED = 500
const MAX_SCORE = 100

var speed: float = SPEED
var score: float = 0

var rng := RandomNumberGenerator.new()

var left_bound: float
var right_bound: float

var level_in_progress := false
var minigame_complete := false

var difficulty := 0
var moving_right := true
var colliding := false


func _ready():
	Global.player_has_control = false

	you_win.visible = false

	var bar_height = bar.get_rect().size.y
	right_bound = bar.position.x - bar_height * 1.25964  # please don't bother the magic numbers,
	left_bound = bar.position.x + bar_height * 1.3 # they're shy and don't want to be seen


func _input(event):
	if level_in_progress:
		if event.is_action_pressed("move_left"):
			moving_right = false;	
		elif event.is_action_pressed("move_right"):
			moving_right = true;	
		

#updates
func _physics_process(delta):
	print(score)
	if not level_in_progress:
		return

	if moving_right:
		lil_dude.position.x += speed * delta
		if lil_dude.position.x >= left_bound:
			moving_right = not moving_right
	else:
		lil_dude.position.x -= speed * delta
		if lil_dude.position.x <= right_bound:
			moving_right = not moving_right
	if colliding:
		score += delta * 5
		if score >= MAX_SCORE:
			Global.tween_cubic_modulate(ui_hint).finished.connect(ui_hint.hide)
			level_in_progress = false
			score = 0
			create_tween().tween_callback(setup_and_start_level).set_delay(2.5)
	$RadialProgress.value = score;


func _on_target_area_entered(_area: Area2D):
	colliding = true


func _on_target_area_exited(_area: Area2D):
	colliding = false

"""
func try_increase_difficulty():
	if difficulty < MAX_DIFFICULTY:
		difficulty += 1
	else:
		win_game()
"""

func setup_level():
	target.visible = false
	lil_dude.visible = false

	lil_dude.position = bar.position
	# determine size of target
	target.scale.x *= (1 - DECAY_FACTOR) ** difficulty  # exponential decay
	# determine placement of target within bounds of the bar
	rng.randomize()
	target.position.x = rng.randf_range(left_bound, right_bound - target.get_children()[0].shape.size.x * target.scale.x)  # probably fine idk

	speed *= 1 + (DECAY_FACTOR / 2) * difficulty  # arbitrary speed increase

	target.visible = true
	lil_dude.visible = true


func setup_and_start_level():
	setup_level()
	level_in_progress = true


func win_game():
	emit_signal("minigame_completed")
	minigame_complete = true
	you_win.visible = true
	create_tween().tween_callback(func(): Global.tween_cubic_modulate(you_win)).set_delay(1.5)

