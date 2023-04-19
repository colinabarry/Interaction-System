extends Control

@onready var character_container: Node = $MarginContainer/VBoxContainer/CharacterContainer
@onready var start_game_button: Button = $MarginContainer/VBoxContainer/StartGame

const BUTTON_PATH = "MarginContainer/VBoxContainer/SelectCharacter"

var characters = {}  # DO NOT TYPE THIS; GDSCRIPT IS VERY NOT SMART
var selected_character: String

var _modulate: Color


func _init():
	_modulate = self.modulate
	self.modulate = Color.TRANSPARENT


func _ready():
	start_game_button.disabled = true
	Global.tween_cubic_modulate(self, _modulate)

	for character in character_container.get_children():
		var char_scene_path: NodePath = (
			"MarginContainer/VBoxContainer/SubViewportContainer/SubViewport/CharacterAnchor/"
			+ character.name
		)
		var character_scene: Node3D = character.get_node(char_scene_path)
		var character_animation_player: AnimationPlayer = character_scene.get_node(
			"AnimationPlayer"
		)

		var select_button: Button = character.get_node(BUTTON_PATH)

		characters[character.name] = {
			"base": character,
			"button": select_button,
			"animation_player": character_animation_player
		}

		character.connect("character_selected", _on_character_selected)
		character.connect("character_hovered", _on_character_hovered)
		character.connect("character_unhovered", _on_character_unhovered)

		characters[character.name].button.disabled = true

		character_animation_player.play("NEW_locomotion_library/idle")


func _on_character_selected(character: String):
	if selected_character != "" and selected_character != character:
		characters[selected_character].button.disabled = true
	else:
		start_game_button.disabled = false

	selected_character = character


func _on_character_hovered(character: String):
	characters[character].button.disabled = false
	characters[character].animation_player.play("NEW_locomotion_library/wave")
	characters[character].animation_player.seek(1)
	characters[character].animation_player.queue("NEW_locomotion_library/idle")


func _on_character_unhovered(character: String):
	if character != selected_character:
		characters[character].button.disabled = true


func _on_start_game_pressed():
	if selected_character == "":
		return

	print("Starting game with character: " + selected_character)

	await Global.tween_cubic_modulate(self).finished

	# TODO: start game with selected character
