extends Node

@onready var cutscene: Cutscene = $Cutscene
@onready var player: NewPlayer = $Megan
@onready var leave_gym_anchor := $Foliage/Bush_15


func _ready():
	print("overworld")
	Global.capture_mouse()
	Global.player_has_control = true

	Global.unpaused.connect(_on_unpaused)
	Global.transition_rect.fade_in()

	if Global.progress_state == Global.PROGRESS_STATE.GAME_STARTED:
		pass
	# 	cutscene.start()
	elif Global.progress_state == Global.PROGRESS_STATE.GYM_COMPLETED:
		player.position = leave_gym_anchor.position


func _on_unpaused():
	Global.capture_mouse()
