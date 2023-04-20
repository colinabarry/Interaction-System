class_name SceneSwitcher extends Area3D

@export var destination_scene: PackedScene
@export var threshold_state := Global.PROGRESS_STATE.GAME_COMPLETED
## The state the game will be set to upon entering this scene
@export var enter_state := Global.PROGRESS_STATE.GAME_STARTED

var can_switch := false

@onready var hint: Hint = $Hint


func _ready() -> void:
	hint.start_hint_timer(0, "")


func _input(_event: InputEvent) -> void:
	if not can_switch:
		return

	if Input.is_action_just_pressed("input_interact"):
		if Global.progress_state >= threshold_state:
			Global.set_progress_state(enter_state)
			Global.transition_rect.fade_out()
			await Global.transition_rect.faded_out
			get_tree().change_scene_to_packed(destination_scene)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_switch = true
		hint.text = "Press E"


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_switch = false
		hint.text = ""
