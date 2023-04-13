extends Node

@onready var cutscene: Cutscene = $Cutscene


func _ready():
	Global.capture_mouse()
	Global.player_has_control = true
	Global.set_is_in_minigame(false)

	Global.unpaused.connect(_on_unpaused)

	if Global.progress_state == Global.PROGRESS_STATE.GAME_STARTED:
		cutscene.start()
<<<<<<< Updated upstream
		pass
=======
		# pass
>>>>>>> Stashed changes


func _on_unpaused():
	Global.capture_mouse()
