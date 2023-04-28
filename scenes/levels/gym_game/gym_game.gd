extends Node3D

@onready var trainer_dialogue: DialogueSystem = $TrainerDialogue
@onready var jump_minigame: JumpMinigame = $JumpMinigame
@onready var leave_button := $GameBase/Control

var dialog_sequence_idx := 0


func _ready():
	leave_button.hide()

	jump_minigame.minigame_completed.connect(
		func(): create_tween().tween_callback(show_outro).set_delay(1.5)
	)
	trainer_dialogue.connect("dialog_sequence_changed", increment_seq_idx)


func show_outro():
	trainer_dialogue.change_sequence(3)
	trainer_dialogue.dialog_sequence.connect("dead", leave_button.show)
	trainer_dialogue.show_box()
	trainer_dialogue.try_begin_dialogue()


# super scuffed but whatever
func increment_seq_idx():
	dialog_sequence_idx += 1

	if dialog_sequence_idx == 2:
		trainer_dialogue.dialog_sequence.connect(
			"dead",
			func(): (
				create_tween()
				. tween_callback(func(): jump_minigame.level_in_progress = true)
				. set_delay(0.75)
			)
		)
