extends Node3D

@export var character_name: String
# @export var character: NodePath

signal character_selected(character: NodePath)

@onready var name_label: Label = $Control/MarginContainer/VBoxContainer/Label
@onready var character_anchor: Node3D = $CharacterAnchor


func _ready():
	name_label.text = character_name
	# character_anchor.add_child(get_node(character))


# func _on_button_pressed():
	# emit_signal("character_selected", character)
