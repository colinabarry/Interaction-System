@tool
extends Node3D

enum TOD { NOON, EVENING, NIGHT }

@export var time_of_day := TOD.NOON:
	set(val):
		time_of_day = val
		_update()

@onready var environment_sky: Sky = $WorldEnvironment.environment.sky
@onready var sun: DirectionalLight3D = $Sun
@onready var moon: DirectionalLight3D = $Moon
@onready var street_light_controller: StreetLightController = $StreetLights

@onready var noon_sky := load("scenes/levels/overworld/noon_sky.tres")
@onready var evening_sky := load("scenes/levels/overworld/morning_sky.tres")
@onready var night_sky := load("scenes/levels/overworld/night_sky.tres")


func _ready() -> void:
	_update()


func _update() -> void:
	match time_of_day:
		TOD.NOON:
			sun.visible = true
			moon.visible = false
			sun.light_color = Color.WHITE
			environment_sky.sky_material = noon_sky
			sun.rotation_degrees.x = -80
			street_light_controller.all_lit = false
		TOD.EVENING:
			sun.visible = true
			moon.visible = false
			sun.light_color = Color("ff9b5a")
			environment_sky.sky_material = evening_sky
			sun.rotation_degrees.x = -161.9
			street_light_controller.all_lit = false
		TOD.NIGHT:
			sun.visible = false
			moon.visible = true
			environment_sky.sky_material = night_sky
			street_light_controller.all_lit = true
