extends Control

@onready var label := $MarginContainer/VBoxContainer/Label

signal character_selected(character: String)
signal character_hovered(character: String)
signal character_unhovered(character: String)


func _ready():
	label.text = name


func _on_select_character_pressed():
	emit_signal("character_selected", name)


func _on_v_box_container_mouse_entered():
	emit_signal("character_hovered", name)


func _on_v_box_container_mouse_exited():
	emit_signal("character_unhovered", name)
