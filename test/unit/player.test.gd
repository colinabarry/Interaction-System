extends GutTest

## Unit tests for the Player class
##
## TODO: more detailed description of the types
## of tests that are performed here
##
## Author(s): Alex Bosco

# TODO: assign player from the node within the overworld scene
#		rather than creating a duplicate player

const OVERWORLD_SCENE_PATH = "res://scenes/levels/overworld/test_world.tscn"

var overworld = preload(OVERWORLD_SCENE_PATH).instantiate()  # debugging view
var sender = InputSender.new(Input)


func _cleanup():
	sender.release_all()
	sender.clear()


func before_all():
	Global.add_child(overworld)  #!dbg
	gut.p("Player:Unit->START\n", 2)


func after_all():
	gut.p("Player:Unit->END\n", 2)


func after_each():
	gut.p("Cleanup Inputs", 2)
	_cleanup()


const dir_map = {
	"-x": "left",
	"+x": "right",
	"-y": null,
	"+y": "jump",
	"-z": "backward",
	"+z": "forward",
}
var assert_map = {"-": assert_gt, "+": assert_lt}


func assert_move(dir: String, hold_for_s := 2.0, wait_s := 2.5) -> void:
	var player = overworld.get_node("Player") as Player

	var prev_pos = player.position[dir[1]]
	sender.action_down("move_" + dir_map[dir]).hold_for(hold_for_s).wait(wait_s)
	await sender
	var new_pos = player.position[dir[1]]

	assert_map[dir[0]].call(new_pos, prev_pos)


func test_move_left():
	assert_move("-x")


func test_move_right():
	assert_move("+x")


func test_move_forward():
	assert_move("+z")


func test_move_backward():
	assert_move("-z")


func test_move_jump():
	assert_move("+y")
