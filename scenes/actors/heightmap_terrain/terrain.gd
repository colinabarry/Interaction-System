@tool
class_name HeightmapTerrain
extends MeshInstance3D

@export var image_path: String
# @export var image: Image
@export var chunk_size := 2.0
@export var height_multiplier := 1.0
@export var collision_shape_size_multiplier := 0.1

@onready var collision_shape: CollisionShape3D = $StaticBody/CollisionShape

var image = Image.new()
var shape = HeightMapShape3D.new()


func _process(_delta: float) -> void:
	collision_shape.shape = shape
	mesh.size = Vector2(chunk_size, chunk_size)

	update_terrain(height_multiplier, collision_shape_size_multiplier)


func update_terrain(_height_multiplier: float, _collision_shape_size_multiplier: float) -> void:
	material_override.set("shader_parameter/height_multiplier", _height_multiplier)

	image.load(image_path)
	image.convert(Image.FORMAT_RF)
	image.resize(
		image.get_width() * _collision_shape_size_multiplier,
		image.get_height() * _collision_shape_size_multiplier
	)

	var data = image.get_data().to_float32_array()
	for i in range(0, data.size()):
		data[i] *= _height_multiplier

	shape.map_width = image.get_width()
	shape.map_depth = image.get_height()
	shape.map_data = data

	var scale_multiplier = chunk_size / float(image.get_width())
	collision_shape.scale = Vector3(scale_multiplier, 1, scale_multiplier)
