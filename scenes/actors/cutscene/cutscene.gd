@tool
class_name Cutscene
extends Node

const animation_player_name := "AnimPlayer"

@export var remove_player_control := true
@export var start_on_ready := false
@export var auto_queue_animations := true

var animation_player: AnimationPlayer


# when a new cutscene is instanced in the editor, it will give itself an
# AnimationPlayer outside of its own scene so you can add your animations
func _enter_tree() -> void:
	# don't create the anim player again when the game runs
	animation_player = get_node_or_null(animation_player_name)
	animation_player.animation_finished.connect(_on_AnimPlayer_animation_finished)
	if animation_player != null:
		return

	animation_player = AnimationPlayer.new()
	animation_player.name = animation_player_name
	add_child(animation_player)
	# this line is needed to make the node appear in the editor
	animation_player.set_owner(get_tree().get_edited_scene_root())


func _ready():
	if start_on_ready:
		start()


func start():
	if remove_player_control:
		Global.set_player_has_control(false)

	var animations := animation_player.get_animation_list()
	for anim in animations:
		animation_player.queue(anim)


func end():
	if remove_player_control:
		Global.set_player_has_control(true)


func _on_AnimPlayer_animation_finished(_anim_name: StringName) -> void:
	end()
