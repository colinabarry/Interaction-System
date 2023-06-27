extends Label

var score = 0
var can_score = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mob_screen_exited():
	if can_score:
		score += 1
		text = "Score: %s" % score

func _disable_scoring():
	can_score = false
