extends Node

@onready var cutscene: Cutscene = $Cutscene
@onready var player: NewPlayer = $Megan


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
		player.position = Vector3(-8.375, 0.066, 8.935)
		print(player.position)
		print(player.global_position)


func _on_unpaused():
	Global.capture_mouse()
