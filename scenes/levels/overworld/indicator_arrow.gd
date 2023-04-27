@tool
extends Node3D

@export var show_on_progress_state := Global.PROGRESS_STATE.GAME_STARTED
@export var move_scale := 0.02
@export var speed_scale := 2

var arrow_offset := 0

@onready var sprite: Sprite3D = $Sprite3D


func _ready() -> void:
	sprite.visible = Global.progress_state == show_on_progress_state


func _physics_process(_delta) -> void:
	arrow_offset += speed_scale
	arrow_offset = arrow_offset % 360
	sprite.position.y += sin(deg_to_rad(arrow_offset)) * move_scale
