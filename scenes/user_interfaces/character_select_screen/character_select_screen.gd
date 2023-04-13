extends Node

@onready var character_container: Node = $MarginContainer/VBoxContainer/CharacterContainer

var selected_character := ""

var _modulate


func _init():
	_modulate = self.modulate
	self.modulate = Color.TRANSPARENT


func _ready():
	Global.tween_cubic_modulate(self, _modulate)

	for character in character_container.get_children():
		character.connect(
			"character_selected", func(_character: String): selected_character = _character
		)


func _on_start_game_pressed():
	if selected_character == "":
		return

	print("Starting game with character: " + selected_character)

	await Global.tween_cubic_modulate(self).finished

	# TODO: start game with selected character
