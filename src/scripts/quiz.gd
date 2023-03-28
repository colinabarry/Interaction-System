class_name Quiz

var score = 0

var _const_phrases = {
	"start": ["Hello sweetie:)", "Time for a QUIZ!!!"],
	"correct": ["WOOOOO THAT'S CORRECT!!"],
	"wrong": ["I'm sorry, that's incorrect"],
	"end": ["QUIZ OVER!", "You scored %s/%s!!!"],
}

var quiz_dialogs := {}

var start = Dialog.new()
var end = Dialog.new().on_before_all(setup_end)
var quiz_sequence: Dialog.Sequence


func set_or_do_nothing(target, from, property: String):
	if property in target and property in from:
		target[property] = from[property]


func _init(quiz_config: Dictionary, default_phrases: Dictionary = {}):
	for property in default_phrases:
		set_or_do_nothing(_const_phrases, default_phrases, property)

	generate_quiz(quiz_config)
	map_next()

	set_or_do_nothing(start, quiz_config.q1, "speaker")
	set_or_do_nothing(start, quiz_config.q1, "using_typing")

	quiz_sequence = (
		start.set_phrases(_const_phrases.start).add_next(quiz_dialogs.q1.question).build_sequence()
	)


func setup_end():
	for end_phrase in _const_phrases.end:
		if "%s" in end_phrase:
			end.add_phrase(end_phrase % [score, len(quiz_dialogs)])
		else:
			end.add_phrase(end_phrase)


func generate_quiz(quiz_config: Dictionary):
	for key in quiz_config:
		quiz_dialogs[key] = {}

		quiz_dialogs[key].question = Dialog.new([quiz_config[key].question])

		set_or_do_nothing(quiz_dialogs[key].question, quiz_config[key], "speaker")
		set_or_do_nothing(quiz_dialogs[key].question, quiz_config[key], "using_typing")

		quiz_dialogs[key].answers = [
			Dialog.new(_const_phrases.correct, quiz_config[key].correct).on_before_all(
				func(): score += 1
			)
		]
		for wrong_answer in quiz_config[key].wrong:
			quiz_dialogs[key].answers.push_back(Dialog.new(_const_phrases.wrong, wrong_answer))


func map_next():
	for key in quiz_dialogs:
		for answer in quiz_dialogs[key].answers:
			var next_key = "q%s" % (int(key[1]) + 1)

			answer.add_next(quiz_dialogs[next_key].question if next_key in quiz_dialogs else end)

		randomize()  # randomize the seed
		quiz_dialogs[key].answers.shuffle()

		quiz_dialogs[key].question.set_next(quiz_dialogs[key].answers)
