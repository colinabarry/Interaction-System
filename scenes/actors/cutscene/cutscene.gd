@tool
class_name Cutscene
extends Node

## A node to create cutscenes
##
## Drag-and-drop to instance this node in the editor. It will create an
## AnimationPlayer as a child of itself. Use the AnimationPlayer to create as
## many animations as desired, which will be played in sequence.

signal cutscene_ended(cutscene_name: String)

const animation_player_name := "AnimPlayer"

@export var remove_player_control := true
@export var start_on_ready := false
@export var start_delay := 0.0  # TODO: implement this
# @export var auto_queue_animations := true # TODO: Implement "false"

var animation_player: AnimationPlayer


func _enter_tree() -> void:
	# FIXME: if you open the scene itself, this triggers - big no no
	# don't create the anim player again when the game runs
	animation_player = get_node_or_null(animation_player_name)
	if animation_player != null:
		return

	animation_player = AnimationPlayer.new()
	animation_player.name = animation_player_name
	add_child(animation_player)
	# this line is needed to make the node appear in the editor
	animation_player.set_owner(get_tree().get_edited_scene_root())
	# animation_player.animation_finished.connect(_on_AnimPlayer_animation_finished)


func _ready():
	animation_player.animation_finished.connect(_on_AnimPlayer_animation_finished)

	if start_on_ready:
		start()


## Starts the cutscene. Removes player control (if applicable) and plays animation queue.
func start():
	if remove_player_control:
		Global.player_has_control = false

	var animations := animation_player.get_animation_list()

	if animations.size() == 1:
		animation_player.play(animations[0])
	else:
		for anim in animations:
			animation_player.queue(anim)


## Called when the animation queue is finished.
func end():
	cutscene_ended.emit(name)
	if remove_player_control:
		Global.player_has_control = true


func _on_AnimPlayer_animation_finished(_anim_name: StringName) -> void:
	end()
