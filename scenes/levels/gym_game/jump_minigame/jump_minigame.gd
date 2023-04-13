class_name JumpMinigame extends Node2D

@onready var player: Player = $"../Player"
@onready var lil_dude: Area2D = $LilDude
@onready var bar: Sprite2D = $Bar
@onready var target: Area2D = $Target
@onready var you_win: Button = $YouWinButton

const DECAY_FACTOR = 0.3
const MAX_DIFFICULTY = 2
const SPEED = 300

var top_bound: float
var bottom_bound: float

var level_in_progress := false
var minigame_complete := false

var difficulty := 0
var moving_up := true
var colliding := false


func _ready():
	Global.player_has_control = false

	you_win.visible = false

	var bar_height = bar.get_rect().size.y
	top_bound = bar.position.y - bar_height * 0.62  # please don't bother the magic numbers,
	bottom_bound = bar.position.y + bar_height * 0.62  # they're shy and don't want to be seen


func _input(event):
	if level_in_progress and event.is_action_pressed("ui_select"):
		if colliding:
			level_in_progress = false
			player.perform_action("jump")

			try_increase_difficulty()
			if not minigame_complete:
				create_tween().tween_callback(setup_and_start_level).set_delay(2.5)


func _physics_process(delta):
	if not level_in_progress:
		return

	if moving_up:
		lil_dude.position.y -= SPEED * delta
		if lil_dude.position.y <= top_bound:
			moving_up = not moving_up
	else:
		lil_dude.position.y += SPEED * delta
		if lil_dude.position.y >= bottom_bound:
			moving_up = not moving_up


func _on_target_area_entered(_area: Area2D):
	colliding = true


func _on_target_area_exited(_area: Area2D):
	colliding = false


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
	# TODO: determine placement of target within bounds of the bar

	target.visible = true
	lil_dude.visible = true


func setup_and_start_level():
	setup_level()
	level_in_progress = true


func win_game():
	minigame_complete = true
	you_win.visible = true
