@tool
extends DialogueSystem

func _ready():
    super()

    dialogs["p-t-1"].connect("after_all", )  # player falls down, blows out ACL
    dialogs["p-t-2"].connect("after_all", )  # player calls for help
    dialogs["p-d-2"].connect("after_all", )  # transition to doctor
