@tool
extends DialogueSystem

var active_sequence := 0

func _on_seq_cold():
    super()
    active_sequence += 1
    active_sequence %= 4
    print("CHANGING SEQUENCE")
    change_sequence(active_sequence)
