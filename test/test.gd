class_name TestConstants extends GutTest

## Hello World
##
## TODO: more detailed description of the types
## of tests that are performed here
##
## Author(s): Alex Bosco

# TODO: assign player from the node within the overworld scene
#		rather than creating a duplicate player

# const OVERWORLD_SCENE_PATH = "res://scenes/levels/overworld/overworld.tscn"

# var overworld = preload(OVERWORLD_SCENE_PATH).instantiate()  # debugging view
var sender = InputSender.new(Input)


func _cleanup():
	sender.release_all()
	sender.clear()


# func before_all():
# 	Global.add_child(overworld)  #!dbg


func after_each():
	_cleanup()
