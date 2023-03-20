@tool
class_name HeightmapTerrain
extends MeshInstance3D

signal export_val_changed

@export var texture: CompressedTexture2D:
	set(val):
		texture = val
		export_val_changed.emit()
@export var chunk_size := 80.0:
	set(val):
		chunk_size = val
		export_val_changed.emit()
@export var height_multiplier := 15.0:
	set(val):
		height_multiplier = val
		export_val_changed.emit()
@export_range(0.01, 0.5) var collision_shape_size_multiplier := 0.1:
	set(val):
		collision_shape_size_multiplier = val
		export_val_changed.emit()
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
	material_override.set("shader_parameter/albedo", texture)
	material_override.set("shader_parameter/heightmap", texture)

	image.load(texture.resource_path)
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
