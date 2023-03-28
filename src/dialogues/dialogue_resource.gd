class_name DialogueResource extends Resource


func _init(_resource_name: String):
	if Engine.is_editor_hint():
		var res := load("res://src/dialogues/%s.gd" % _resource_name)
		ResourceSaver.save(res, "res://assets/dialogues/%s.tres" % _resource_name)
