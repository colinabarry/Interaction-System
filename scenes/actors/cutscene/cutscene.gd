@tool
class_name Cutscene extends Node

## A node to create cutscenes
##
## Instance this node in the editor. It will create an
## AnimationPlayer as a child of itself. Use the AnimationPlayer to create as
## many animations as desired, which will be played in sequence.

signal cutscene_ended(cutscene_name: String)

const animation_player_name := "AnimPlayer"

@export var dialog_boxes: Array[DialogueSystem] = []
@export var remove_player_control := true
@export var start_on_ready := false
@export var using_camera := false
@export var fade_out_in_when_finished := false
# @export var start_delay := 0.0  # TODO: implement this
# @export var auto_queue_animations := true # TODO: Implement "false"

var animation_player: AnimationPlayer
var camera: Camera3D

@onready var transition_rect := Global.transition_rect


func _enter_tree() -> void:
	# don't create the anim player again when the game runs
	animation_player = get_node_or_null(animation_player_name)
	if animation_player != null:
		return

	# don't create the anim player inside the cutscene scene
	if get_tree().get_edited_scene_root().is_in_group("cutscene"):
		return

	_create_anim_player()


func _ready():
	animation_player.animation_finished.connect(_on_AnimPlayer_animation_finished)

	if start_on_ready:
		start()

	if using_camera:
		camera = get_children().filter(func(child): return child is Camera3D).front()
		if Global.progress_state == Global.PROGRESS_STATE.GAME_STARTED:
			camera.current = true
			pass


## Starts the cutscene. Removes player control (if applicable) and plays animation queue.
func start():
	if remove_player_control:
		Global.player_has_control = false

	var animations := animation_player.get_animation_list()

	for anim in animations:
		animation_player.queue(anim)


## Called when the animation queue is finished.
func end():
	cutscene_ended.emit(name)
	if remove_player_control:
		Global.player_has_control = true

	if fade_out_in_when_finished:
		transition_rect.fade_out()

		await transition_rect.faded_out
		if using_camera:
			camera.current = false
		transition_rect.fade_in()

	else:
		if using_camera:
			camera.current = false


func pause_animation():
	animation_player.pause()


func resume_animation():
	animation_player.play()


func fade_out():
	transition_rect.fade_out(0.1)


func fade_in():
	transition_rect.fade_in()


func _create_anim_player() -> void:
	animation_player = AnimationPlayer.new()
	animation_player.name = animation_player_name
	add_child(animation_player)
	# this line is needed to make the node appear in the editor
	animation_player.set_owner(get_tree().get_edited_scene_root())


func _on_AnimPlayer_animation_finished(_anim_name: StringName) -> void:
	end()
