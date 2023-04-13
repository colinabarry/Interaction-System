extends Control

@export var character_name: String

signal character_selected(character: String)

@onready var name_label: Label = $MarginContainer/VBoxContainer/Label


func _ready():
	name_label.text = character_name


func _on_select_character_pressed():
	emit_signal("character_selected", character_name)
