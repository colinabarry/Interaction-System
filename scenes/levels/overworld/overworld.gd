extends Node

@onready var cutscene: Cutscene = $Cutscene
@onready var cutscene_player = cutscene.get_node("Megan")
@onready var player: NewPlayer = $Megan
@onready var leave_gym_anchor := $Foliage/Bush_15
@onready var xray_game := preload("res://scenes/levels/xray_game/xray_game.tscn")
@onready var tod := $TimeOfDay


func _ready():
	Global.capture_mouse()
	Global.player_has_control = true

	Global.unpaused.connect(_on_unpaused)
	Global.transition_rect.fade_in()

	# I dislike this whole chain here but I mean it works
	if Global.progress_state == Global.PROGRESS_STATE.GAME_STARTED:
		cutscene_player.visible = true
		tod.time_of_day = tod.TOD.NOON
		cutscene.start()
	else:
		cutscene_player.visible = false

	if Global.progress_state == Global.PROGRESS_STATE.HOSPITAL_COMPLETED:
		tod.time_of_day = tod.TOD.EVENING
	if Global.progress_state == Global.PROGRESS_STATE.GYM_COMPLETED:
		tod.time_of_day = tod.TOD.NIGHT
		player.position = Vector3(-2.597, 1.151, 12.884)
		player.rotation.y = 2 * PI
		player.camera_origin.rotation_degrees = Vector3(9, 369, 0)


func _on_unpaused():
	Global.capture_mouse()


func _on_anim_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_game":
		get_tree().change_scene_to_packed(xray_game)
