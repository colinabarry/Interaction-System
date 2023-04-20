extends Node

@onready var cutscene: Cutscene = $Cutscene
@onready var player: NewPlayer = $Megan
@onready var leave_gym_anchor := $Foliage/Bush_15
@onready var xray_game := preload("res://scenes/levels/xray_game/xray_game.tscn")


func _ready():
	print("overworld")
	Global.capture_mouse()
	Global.player_has_control = true

	Global.unpaused.connect(_on_unpaused)
	Global.transition_rect.fade_in()

	print(Global.progress_state)

	if Global.progress_state == Global.PROGRESS_STATE.GAME_STARTED:
		# pass
		cutscene.start()
	elif Global.progress_state == Global.PROGRESS_STATE.GYM_COMPLETED:
		player.position = Vector3(-8.994, 1.15, -6.16)
		player.rotation.y = PI


func _on_unpaused():
	Global.capture_mouse()


func _on_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_game":
		get_tree().change_scene_to_packed(xray_game)
