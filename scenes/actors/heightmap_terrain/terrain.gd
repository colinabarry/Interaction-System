@tool
class_name HeightmapTerrain
extends MeshInstance3D

signal export_val_changed

@export var albedo_texture: CompressedTexture2D:
# set(val): i_give_up("albedo_texture", val)
	set(val):
		albedo_texture = val
		export_val_changed.emit()
@export var heightmap_texture: CompressedTexture2D:
	# set = i_give_up
	set(val):
		heightmap_texture = val
		export_val_changed.emit()
@export_range(1.0, 500.0, 1.0) var chunk_size := 80.0:
	# set = i_give_up
	set(val):
		chunk_size = val
		export_val_changed.emit()
@export_range(0.0, 50, 0.01) var height_multiplier := 15.0:
	# set = i_give_up
	set(val):
		height_multiplier = val
		export_val_changed.emit()
@export_range(0.01, 0.5) var collision_shape_size_multiplier := 0.1:
	# set = i_give_up
	set(val):
		collision_shape_size_multiplier = val
		export_val_changed.emit()

# var export_properties = {}

# EVEN THIS SUCKS ASS BC THEY DONT JUST PROVIDE THE PROPERTY NAME FOR NO DAMN REASON
# func i_give_up(property: StringName, value: Variant):
# 	export_properties[property] = value
# 	export_val_changed.emit()

# func __get(property: StringName):
# 	return export_properties[property]

# func _set(_property, _value):
# 	print("hm")

# 	return false

# not listed in the docs or anywhere online. Godot 4.0 be like
# const PROPERTY_USAGE_EXPORT_VARIABLE = 4102

# SEO for this link sucks balls, found it on accident after I stopped explicitly looking for it lmao
# https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enumerations
# var export_properties = {
# 	"albedo_texture": {
# 		"property": {
# 			"name": "/albedo_texture",
# 			"type": ,
# 			"usage": PROPERTY_USAGE_EXPORT_VARIABLE,
# 			"hint": PROPERTY_HINT_RESOURCE_TYPE,
# 			"hint_string": ""
# 		},
# 		"value": null
# 	}
# }

# func get_exported(property: String):
# 	return export_properties[property].value

# var export_properties: Array[Dictionary]

# func _init():
# 	export_properties = get_property_list().filter(
# 		func(prop): return prop.usage == PROPERTY_USAGE_EXPORT_VARIABLE
# 	)

# 	for property in export_properties:
# 		property.name.insert(0, "/")  # shitty engine magic

# func _get_property_list():
# 	return export_properties

# # 	print(get_property_list())

# ## Give _set enough time to actually set the value before emitting the signal
# func emit_later():
# 	# stupid GDScript thinks Signals don't have an emit method if you try to pass it as
# 	# a first-class function ffs
# 	create_tween().tween_callback(func(): export_val_changed.emit()).set_delay(0.01)
# 	print("8==D emission complete")

# # some of the sexiest formatting I've ever seen (it's gone, rip)
# func _set(property, _value):
# 	# var prop_in_list = get_property_list().filter(func(prop): return prop.name == property)
# 	# if prop_in_list.size() > 0 and prop_in_list[0].usage == PROPERTY_USAGE_EXPORT_VARIABLE:
# 	if property.begins_with("/"):
# 		emit_later()
# 	print("hmmm")
# 	return false  # tells engine to set normally

# func _get_property_list():
# 	# var properties = get_property_list().filter(func(prop): return prop.usage == PROPERTY_USAGE_EXPORT_VARIABLE)
# 	# for property in properties:
# 	# 	property

# 	return []

# # NVM LMAO
#==================================================================#
#==== ALTERNATIVE WAY OF DOING IT, MIGHT BE MORE PERFORMANT??? ====#

# only need to comment out `_set` ABOVE and uncomment everything til
# your comment below for the alt version

# # GDScript doesn't have Sets ffs
# var export_properties := {}

# # should only run when you click on the node in the scene tree and the editor loads
# # the node inspector
# func _get_property_list():
# 	var _export_properties = get_property_list().filter(
# 		func(prop): return prop.usage == PROPERTY_USAGE_EXPORT_VARIABLE
# 	)

# 	for property in _export_properties:
# 		export_properties[property.name] = true  # the value is meaningless, GDScript needs Sets

# 	return []  # don't actually add any additional properties to the list

# func _set(property, _value):
# 	if property in export_properties: # obviously a much more performant op lol
# 		emit_later()

# 	return false  # tells engine to set normally

# ALEX: hey you like to do this kinda stuff... if you feel like it, we should ^
# spend a little time and generalize this ____________________________________|
# it just emits a signal when you change the value in the editor
# so it can call an update function because it's a tool script

@onready var collision_shape: CollisionShape3D = $StaticBody/CollisionShape

var image := Image.new()
var shape := HeightMapShape3D.new()


func update() -> void:
	collision_shape.shape = shape
	mesh.size = Vector2(chunk_size, chunk_size)

	update_terrain(height_multiplier, collision_shape_size_multiplier)


func update_terrain(_height_multiplier: float, _collision_shape_size_multiplier: float) -> void:
	material_override.set("shader_parameter/height_multiplier", _height_multiplier)
	material_override.set("shader_parameter/albedo", albedo_texture)
	material_override.set("shader_parameter/heightmap", heightmap_texture)

	image.load(heightmap_texture.resource_path)
	image.convert(Image.FORMAT_RF)
	image.resize(
		image.get_width() * _collision_shape_size_multiplier,
		image.get_height() * _collision_shape_size_multiplier
	)

	var data := image.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *= _height_multiplier

	shape.map_width = image.get_width()
	shape.map_depth = image.get_height()
	shape.map_data = data

	var scale_multiplier = chunk_size / float(image.get_width())
	collision_shape.scale = Vector3(scale_multiplier, 1, scale_multiplier)


func _on_export_val_changed() -> void:
	update()
