extends GutTest

## Unit tests for the Player class
##
## TODO: more detailed description of the types
## of tests that are performed here
##
## Author(s): Alex Bosco

# TODO: assign player from the node within the overworld scene
#		rather than creating a duplicate player

const OVERWORLD_SCENE_PATH = "res://scenes/levels/overworld/overworld.tscn"
const PLAYER_SCENE_PATH = "res://scenes/actors/characters/player/player.tscn"

var overworld = preload(OVERWORLD_SCENE_PATH).instantiate()
var player = preload(PLAYER_SCENE_PATH).instantiate()  # w/ overworld this creates a dup player
var sender = InputSender.new(player)


func _cleanup():
	sender.release_all()
	sender.clear()


func before_all():
	Global.add_child(overworld)
	Global.add_child(player)
	gut.p("Player:Unit->START\n", 2)


func after_all():
	gut.p("Player:Unit->END\n", 2)


func after_each():
	gut.p("Cleanup Inputs", 2)
	_cleanup()


const dirMap = {
	"-x": "left",
	"+x": "right",
	"-y": null,
	"+y": "jump",
	"-z": "backward",
	"+z": "forward",
}


func assert_move(dir: String, hold_for_s := 1.0, wait_s := 1.5) -> void:
	var prev_pos = player.position[dir[1]]
	sender.action_down("move_" + dirMap[dir]).hold_for(hold_for_s).wait(wait_s)
	await sender
	var new_pos = player.position[dir[1]]

	(assert_gt if dir[0] == "-" else assert_lt).call(new_pos, prev_pos)


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
