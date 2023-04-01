extends Sprite3D

var dialog_sequence: Dialog.Sequence
var is_visible := false

@onready var dialogue = $Texture/MarginContainer/Text
@onready var next_phrase_timer = $NextPhraseTimer


func _init():
	dialog_sequence = Dialog.Sequence.build(Dialogues.test_bubble_config, "start", {
		"allow_typing": false,
	})


func _ready():
	modulate = Color.TRANSPARENT
	hide()
	# texture = $SpeechBubble/Texture.get_texture()


func _on_next_phrase_timer_timeout():
	handle_next_phrase()


func show_dialogue():
	var wait_time = 2
	next_phrase_timer.one_shot = true
	next_phrase_timer.wait_time = wait_time

	(
		dialog_sequence
		. after_each.connect(func():
			if dialog_sequence.dialog == dialog_sequence._head and dialog_sequence.dialog.phrase_idx == 0:
				next_phrase_timer.start(wait_time + tween_time)
			elif dialog_sequence.still_talking():
				next_phrase_timer.start()
			else:
				next_phrase_timer.start(4)
			)
	)

	show_bubble()

var tween_time := 1
func hide_bubble():
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	await tween.tween_property(self, "modulate", Color.TRANSPARENT, tween_time).finished

	hide()
	is_visible = false
	dialogue.text = ""


func show_bubble():
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	show()
	if dialog_sequence.cold:
		dialogue.text = dialog_sequence.begin_dialog()
	await tween.tween_property(self, "modulate", Color.WHITE, tween_time).finished

	is_visible = true


func handle_next_phrase():
	var active_text = dialog_sequence.next()

	if dialog_sequence.dead:
		hide_bubble()
		dialog_sequence.reset()
	else:
		dialogue.text = active_text
