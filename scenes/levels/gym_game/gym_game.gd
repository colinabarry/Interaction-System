extends Node3D

@onready var trainer_dialogue: DialogueSystem = $TrainerDialogue
@onready var jump_minigame: JumpMinigame = $JumpMinigame

var dialog_sequence_idx = 0


func _ready():
	trainer_dialogue.connect("dialog_sequence_changed", increment_seq_idx)


# super scuffed but whatever
func increment_seq_idx():
	dialog_sequence_idx += 1

	if dialog_sequence_idx == 1:
		trainer_dialogue.dialog_sequence.connect(
			"dead", func(): jump_minigame.level_in_progress = true
		)
