@tool
class_name Cutscene
extends Node

var animations
var animation_player: AnimationPlayer


# when a new cutscene is instanced in the editor, it will give itself an
# AnimationPlayer outside of its own scene so you can add your animations
func _enter_tree() -> void:
	animation_player = AnimationPlayer.new()
	animation_player.name = "AnimPlayer"
	add_child(animation_player)
	# this line is needed to make the node appear in the editor
	animation_player.set_owner(get_tree().get_edited_scene_root())


func start():
	animations = animation_player.get_animation_list()
	for anim in animations:
		print(anim)


func end():
	pass
