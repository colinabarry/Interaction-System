extends Node

## for testing dialog using Dialog objects instead of a config
var test_start = Dialog.new(
	["This is the starting dialog!!", "This is cool, huh?", MULT_NEXT], "start_dialog"
)


func _init():
	# inside here so all these aren't accessible
	var opt0_dead = Dialog.new(["Hey there, this is the first option!", DEAD], "1st (dead)")
	var opt1_cycle = Dialog.new(["Hey there, this is the second option!", CYCLES], "2nd (cycles)")
	var opt2 = Dialog.new(["Oh wow, the third option!", ONE_NEXT], "3rd (1 next, dead)")
	var opt3 = Dialog.new(["Holy cow! The fourth option!", ONE_NEXT], "4th (1 next, cycles)")
	var opt4 = Dialog.new(["bing bong I'm #5", MULT_NEXT], "5th (2 next)")
	var after_opt2_dead = Dialog.new(["Uh oh, I'm after option 3!", DEAD], "after 3rd (dead)")
	var after_opt3_cycle = Dialog.new(["After option 4", CYCLES], "after 4th (cycles)")
	var after_opt4_dead = Dialog.new(["After option 5", DEAD], "after 5th (dead)")
	var after_opt4_cycle = Dialog.new(["After opt five", CYCLES], "after 5th (cycles)")

	after_opt4_cycle.add_next(test_start)
	opt4.set_next([after_opt4_dead, after_opt4_cycle])
	after_opt3_cycle.add_next(test_start)
	opt3.add_next(after_opt3_cycle)
	opt2.add_next(after_opt2_dead)
	opt1_cycle.add_next(test_start)

	test_start.set_next([opt0_dead, opt1_cycle, opt2, opt3, opt4])
	test_start.using_typing = true


const DEAD = "You shouldn't see any additional options, nor should you be able to see dialog past this!"
const ONE_NEXT = "You shouldn't see any options, but clicking should show new dialog!"
const CYCLES = "Clicking should bring you back to the start dialog!"
const MULT_NEXT = "You should see options!"

const test_config = {
	"start":
	{
		"using_typing": true,  # this will propagate to all proceeding Dialogs
		"base": ["This is the starting dialog!!", "This is cool, huh?", MULT_NEXT],
		"next": ["opt0_dead", "opt1_cycle", "opt2", "opt3", "opt4"],
	},
	"opt0_dead":
	{
		"base": ["Hey there, this is the first option!", DEAD],
		"option_name": "1st (dead)",
		"next": [],
	},
	"opt1_cycle":
	{
		"base": ["Hey there, this is the second option!", CYCLES],
		"option_name": "2nd (cycles)",
		"next": ["start"],
	},
	"opt2":
	{
		"base": ["Oh wow, the third option!", ONE_NEXT],
		"option_name": "3rd (1 next, dead)",
		"next": ["after_opt2_dead"],
	},
	"opt3":
	{
		"base": ["Holy cow! The fourth option!", ONE_NEXT],
		"option_name": "4th (1 next, cycles)",
		"next": ["after_opt3_cycle"],
	},
	"opt4":
	{
		"base": ["bing bong I'm #5", MULT_NEXT],
		"option_name": "5th (2 next)",
		"next": ["after_opt4_dead", "after_opt4_cycle"],
	},
	"after_opt2_dead":
	{
		"base": ["Uh oh, I'm after option 3!", DEAD],
		"option_name": "after 3rd (dead)",
		"next": [],
	},
	"after_opt3_cycle":
	{
		"base": ["After option 4", CYCLES],
		"option_name": "after 4th (cycles)",
		"next": ["start"],
	},
	"after_opt4_dead":
	{
		"base": ["After option 5", DEAD],
		"option_name": "after 5th (dead)",
		"next": [],
	},
	"after_opt4_cycle":
	{
		"base": ["After opt five", CYCLES],
		"option_name": "after 5th (cycles)",
		"next": ["start"],
	},
}
