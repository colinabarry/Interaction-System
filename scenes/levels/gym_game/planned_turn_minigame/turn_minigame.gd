class_name TurnMinigame extends Node2D

signal minigame_completed

@onready var player: Area2D = $Radial_game/Player
@onready var lil_dude: Area2D = $LilDude
@onready var bar: Sprite2D = $Bar
@onready var target: Area2D = $Target
@onready var ui_hint: Control = $UI_overlay
@onready var you_win: Button = $YouWinButton

const DECAY_FACTOR = 0.3
const MAX_DIFFICULTY = 2
const SPEED = 300

var speed: float = SPEED

var rng := RandomNumberGenerator.new()

var top_bound: float
var bottom_bound: float
var rotation_offset: float = 0
var rotation_speed: float = 90

var level_in_progress := false
var minigame_complete := false

var difficulty := 0
var moving_up := true
var colliding := false
var game_phase := false
var arrow_colliding := false


func _ready():
	Global.player_has_control = false

	you_win.visible = false

	var bar_height = bar.get_rect().size.y
	top_bound = bar.position.y - bar_height * 0.62  # please don't bother the magic numbers,
	bottom_bound = bar.position.y + bar_height * 0.62  # they're shy and don't want to be seen


func _input(event):
	if level_in_progress and event.is_action_pressed("ui_select"):
		if colliding:
			Global.tween_cubic_modulate(ui_hint).finished.connect(ui_hint.hide)
			game_phase = true
			colliding = false
		
			#player.perform_action("jump")
		if game_phase and arrow_colliding:
			level_in_progress = false
			try_increase_difficulty()
			if not minigame_complete:
				create_tween().tween_callback(setup_and_start_level).set_delay(2.5)
				

func _physics_process(delta):
	if not level_in_progress:
		return

	if game_phase:
		
		player.rotation_degrees += rotation_offset * rotation_speed * delta
		
		
		if player.rotation_degrees >= 115.0:
			rotation_offset = -1
		elif player.rotation_degrees <= -65.0:
			rotation_offset = 1
		

	elif moving_up:
		lil_dude.position.y -= speed * delta
		if lil_dude.position.y <= top_bound:
			moving_up = not moving_up
	else:
		lil_dude.position.y += speed * delta
		if lil_dude.position.y >= bottom_bound:
			moving_up = not moving_up


func _on_target_area_entered(_area: Area2D):
	colliding = true


func _on_target_area_exited(_area: Area2D):
	colliding = false

func _arrow_entered(_area: Area2D):
	arrow_colliding = true
	
func _arrow_exit(_area: Area2D):
	arrow_colliding = false

func try_increase_difficulty():
	if difficulty < MAX_DIFFICULTY:
		difficulty += 1
	else:
		win_game()


func setup_level():
	target.visible = false
	lil_dude.visible = false

	lil_dude.position = bar.position
	# determine size of target
	target.scale.y *= (1 - DECAY_FACTOR) ** difficulty  # exponential decay
	# determine placement of target within bounds of the bar
	rng.randomize()
	target.position.y = rng.randf_range(top_bound, bottom_bound - target.get_children()[0].shape.size.y * target.scale.y)  # probably fine idk

	speed *= 1 + (DECAY_FACTOR / 2) * difficulty  # arbitrary speed increase

	target.visible = true
	lil_dude.visible = true


func setup_and_start_level():
	setup_level()
	game_phase = false
	arrow_colliding = false
	colliding = false
	level_in_progress = true


func win_game():
	emit_signal("minigame_completed")
	minigame_complete = true
	you_win.visible = true
	create_tween().tween_callback(func(): Global.tween_cubic_modulate(you_win)).set_delay(1.5)
