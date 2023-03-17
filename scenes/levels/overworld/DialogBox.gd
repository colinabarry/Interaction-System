extends Control

const DEAD = "You shouldn't see any additional options, nor should you be able to see dialog past this!"
const ONE_NEXT = "You shouldn't see any options, but clicking should show new dialog!"
const CYCLES = "Clicking should bring you back to the start dialog!"
const MULT_NEXT = "You should see options!"

var dialogue_config = {
	"start":
	{
		"base": ["This is the starting dialog!!", "This is cool, huh?", MULT_NEXT],
		"option_name": "Starting Dialog",
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

var start_dialog = Dialog.new(
	["This is the starting dialog!!", "This is cool, huh?", MULT_NEXT], "start_dialog"
)
var opt0_dead = Dialog.new(["Hey there, this is the first option!", DEAD], "1st (dead)")
var opt1_cycle = Dialog.new(["Hey there, this is the second option!", CYCLES], "2nd (cycles)")
var opt2 = Dialog.new(["Oh wow, the third option!", ONE_NEXT], "3rd (1 next, dead)")
var opt3 = Dialog.new(["Holy cow! The fourth option!", ONE_NEXT], "4th (1 next, cycles)")
var opt4 = Dialog.new(["bing bong I'm #5", MULT_NEXT], "5th (2 next)")
var after_opt2_dead = Dialog.new(["Uh oh, I'm after option 3!", DEAD], "after 3rd (dead)")
var after_opt3_cycle = Dialog.new(["After option 4", CYCLES], "after 4th (cycles)")
var after_opt4_dead = Dialog.new(["After option 5", DEAD], "after 5th (dead)")
var after_opt4_cycle = Dialog.new(["After opt five", CYCLES], "after 5th (cycles)")

var dialog_sequence: Dialog.Sequence

@onready var dialog_options = get_node("%DialogOptions")
@onready var dialog_text = get_node("%DialogText")


func _init():
	after_opt4_cycle.add_next(start_dialog)
	opt4.set_next([after_opt4_dead, after_opt4_cycle])
	after_opt3_cycle.add_next(start_dialog)
	opt3.add_next(after_opt3_cycle)
	opt2.add_next(after_opt2_dead)
	opt1_cycle.add_next(start_dialog)

	start_dialog.set_next([opt0_dead, opt1_cycle, opt2, opt3, opt4])

	dialog_sequence = start_dialog.build_sequence()
	# dialog_sequence = Dialog.Sequence.build(dialogue_config, "start")


func _ready():
	dialog_text.text = dialog_sequence.next()


func _on_dialog_options_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return

	dialog_options.clear()
	dialog_text.text = dialog_sequence.next(index)


func _on_rich_text_label_gui_input(event: InputEvent):
	#TEMP
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		dialog_sequence.set_dialog(start_dialog)
	elif (
		not event is InputEventMouseButton
		or event.button_index != MOUSE_BUTTON_LEFT
		or not event.pressed
	):
		return

	var active_text = dialog_sequence.next()

	if not dialog_sequence.dead:
		dialog_text.text = active_text
	else:
		dialog_text.text = "DEAD SEQUENCE"
		# TODO: remove dialog display

	if (
		not dialog_sequence.still_talking
		and dialog_sequence.has_options()
		and dialog_options.get_item_count() == 0
	):
		for option_name in dialog_sequence.get_option_names():
			dialog_options.add_item(option_name)
