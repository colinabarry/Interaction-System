extends Node

@onready var cutscene: Cutscene = $Cutscene


func _ready():
	Global.capture_mouse()
	Global.player_has_control = true

	Global.unpaused.connect(_on_unpaused)

	# if Global.progress_state == Global.PROGRESS_STATE.GAME_STARTED:
	# 	cutscene.start()


func _on_unpaused():
	Global.capture_mouse()
