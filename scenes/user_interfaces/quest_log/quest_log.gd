extends Node

@onready var quest_log = $Log

var log_texts = {
	Global.PROGRESS_STATE.GAME_STARTED: "",
	Global.PROGRESS_STATE.HOSPITAL_ENTERED: "",
	Global.PROGRESS_STATE.HOSPITAL_COMPLETED: "Make your way over to the gym",
	Global.PROGRESS_STATE.GYM_ENTERED: "",
	Global.PROGRESS_STATE.GYM_COMPLETED: "Time to go home!",
	Global.PROGRESS_STATE.HOME_ENTERED: "",
	Global.PROGRESS_STATE.HOME_COMPLETED: "Woohoo you did it!",
	Global.PROGRESS_STATE.GAME_COMPLETED: "Why are you still here?",
}


func _ready():
	quest_log.text = log_texts[Global.progress_state]
	quest_log["hide" if quest_log.text == "" else "show"].call()
	Global.progress_advanced.connect(on_progress_advanced)


func on_progress_advanced(state: Global.PROGRESS_STATE):
	quest_log.text = log_texts[state]
	quest_log["hide" if quest_log.text == "" else "show"].call()
