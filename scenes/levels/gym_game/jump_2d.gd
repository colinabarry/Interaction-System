extends Node2D

@onready var level_1_target: Sprite2D = $BarHitArea 
@onready var level_2_target: Sprite2D = $BarHitArea2 
@onready var level_3_target: Sprite2D = $BarHitArea3 

# Called when the node enters the scene tree for the first time.
func _ready():
	level_2_target.visible = false
	level_3_target.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.minigame_progressed:
		match Global.get_jumpmini_global_diff():
			1:
				level_1_target.visible = true
				pass
			2:
				level_1_target.visible = false
				level_2_target.visible = true
				pass
			3:
				level_2_target.visible = false
				level_3_target.visible = true
				pass
	return
	
	pass
