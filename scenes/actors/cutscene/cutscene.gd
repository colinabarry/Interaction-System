class_name Cutscene
extends Node

# @export var animations: Array[String]
var animations

@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer")


func start():
	animations = animation_player.get_animation_library("").get_animation_list()
	for anim in animations:
		pass
		# print(anim)
		# player.queue(anim)


func end():
	pass
