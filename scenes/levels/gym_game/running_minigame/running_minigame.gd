class_name RunningMinigame extends Node2D

signal minigame_completed

@onready var player: NewPlayer = $"../Player"
@onready var lil_dude: Area2D = $LilDude
@onready var bar: Sprite2D = $Bar
@onready var target: Area2D = $Target
@onready var ui_hint: Control = $UI_overlay
@onready var you_win: Button = $YouWinButton

const DECAY_FACTOR = 0.3
#const MAX_DIFFICULTY = 2
const GRAVITY = 200
const JUMP = 75
const MAX_SCORE = 100

var grav: float = GRAVITY
var jump: float = JUMP

var velocity := 0.0		#
var target_pos := 0.0	#jump destination per second
var score : float = 0

var rng := RandomNumberGenerator.new()

var top_bound: float
var bottom_bound: float


var level_in_progress := false
var minigame_complete := false

var difficulty := 0
var moving_down := true
var colliding := false


func _ready():
	Global.player_has_control = false

	you_win.visible = false

	var bar_height = bar.get_rect().size.y
	top_bound = bar.position.y - bar_height * 0.62  # please don't bother the magic numbers,
	bottom_bound = bar.position.y + bar_height * 0.62  # they're shy and don't want to be seen


func _input(event):
	if level_in_progress and event.is_action_pressed("ui_select"):
		velocity += jump;
			
func _physics_process(delta):
	if not level_in_progress:
		return
	target_pos = grav * delta + (velocity * delta * -1)
	velocity = velocity - (velocity * delta)
	velocity = clamp(velocity, 0, 300)
	#print("Velocity ", velocity)
	#print("Target Pos ", target_pos)
	#if lil_dude.position.y <= bottom_bound:
	lil_dude.position.y = clamp(lil_dude.position.y + target_pos, top_bound, bottom_bound) 
		
	if colliding:
		score += delta * 5
		if score >= MAX_SCORE:
			Global.tween_cubic_modulate(ui_hint).finished.connect(ui_hint.hide)
			level_in_progress = false
			score = 0
			create_tween().tween_callback(setup_and_start_level).set_delay(2.5)
	$RunningProgress.value = score;
	

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
	target.scale.y *= (1 - DECAY_FACTOR) ** difficulty  # exponential decay
	# determine placement of target within bounds of the bar
	rng.randomize()
	target.position.y = rng.randf_range(top_bound, bottom_bound - target.get_children()[0].shape.size.y * target.scale.y)  # probably fine idk

	grav *= 1 + (DECAY_FACTOR / 2) * difficulty  # arbitrary grav inrease

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


func _on_texture_progress_bar_value_changed(value):
	pass # Replace with function body.
