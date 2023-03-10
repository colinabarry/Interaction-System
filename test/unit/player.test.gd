extends GutTest

## Unit tests for the Player class
##
## TODO: more detailed description of the types
## of tests that are performed here
##
## Author(s): Alex Bosco


class MockUser:
	var InputSender
	var _sender

	func _init(input_sender):
		InputSender = input_sender

	func set_sender(player: Player):
		_sender = InputSender.new(player)

	func cleanup():
		_sender.release_all()
		_sender.clear()
		_sender = null

	func move(name: String, hold_for_s: float = 0, wait_s: float = 0):
		_sender.action_down("move_" + name).hold_for(hold_for_s).wait(wait_s)
		await _sender


# only way to scope InputSender inside the class?
var mock_user = MockUser.new(InputSender)


func create_player():
	var player = Player.new()
	add_child_autofree(player)

	mock_user.set_sender(player)

	return player


func before_all():
	gut.p("Player:Unit->START\n", 2)


func after_all():
	gut.p("Player:Unit->END\n", 2)


func after_each():
	gut.p("Cleanup Inputs", 2)
	mock_user.cleanup()


func assert_move(player, dir: String, hold_for_s := 0.25, wait_s := 0.5):
	var vec_comp: String
	match dir:
		"left", "right":
			vec_comp = "x"
		"forward", "backward":
			vec_comp = "z"
		_:
			vec_comp = "y"

	var prev_pos = player.position[vec_comp]
	mock_user.move(dir, hold_for_s, wait_s)
	var new_pos = player.position[vec_comp]

	var assert_fn
	match dir:
		"left", "forward":
			assert_fn = assert_lt
		"right", "backward", "jump":
			assert_fn = assert_gt
		_:
			gut.p("\n**INVALID DIRECTION NAME**\n", 2)
			assert_false(true)  # fail the test
			return

	assert_fn.call(new_pos, prev_pos)


func test_move_left():
	var player = create_player()
	assert_move(player, "left")


func test_move_right():
	var player = create_player()
	assert_move(player, "right")


func test_move_forward():
	var player = create_player()
	assert_move(player, "forward")


func test_move_backward():
	var player = create_player()
	assert_move(player, "backward")


func test_move_jump():
	var player = create_player()
	assert_move(player, "jump")
