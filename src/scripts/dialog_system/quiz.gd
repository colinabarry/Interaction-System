class_name Quiz
## A convenience implementation for creating dialogues as quizzes.
##
## [Quiz] utilizes [Dialog] and [Dialog.Sequence], alongside a uniquely shaped
## configuration [Dictionary], to simplify the process of creating dialogue-based
## quizzes. In addition to a configuration, a [Quiz] constructor can accept a second
## [Dictionary] where you can define the phrases for the start and end [Dialog]s
## as well as boilerplate responses for choosing a "correct" or "wrong" answer.
## [br][br]Quiz configurations must only have top-level-keys in the form [code]qx[/code]
## where 'x' is a number greater than 0. The key [code]q1[/code] will always be the first question.
## Answers will be shown in a random order every time the quiz is generated. You may provide
## a [code]speaker[/code] or [code]using_typing[/code] property in any question to function
## as would be expected from a [Dialog.Sequence] configuration.
## [br][br]Configuration example:
##		[codeblock]
##		const config := {
##		    "q1": {
##		        "speaker": "Mother",
##		        "using_typing": true,
##		        "question": "What is 2+2?",
##		        "correct": 4,
##		        "wrong": [3, 5, 21]
##		    }
##		}
##		[/codeblock]
## [br][br]The values provided for the "question", "correct", and "wrong" properties must be castable
## as [String]. "wrong" must be an array. "question" will be displayed in your "dialogue" [Node] while
## "correct" and "wrong" will be displayed together as options for the generated "question" [Dialog].
## [br]If you want to add custom dialogue to display after clicking a given answer, simply add a [Dictionary]
## in place of the answer as so:
##		[codeblock]
##		const config := {
##		    "q1": {
##		        ...,
##		        "correct": {
##		            "option": 4,
##		            "phrases": ["The answer is 4 because 2 two times is 4."]
##		        },
##		        "wrong": [3, {
##		            "option": 5,
##		            "phrases": ["The actual answer is 4."]
##		        }, 21]
##		    }
##		}
##		[/codeblock]
## [br] Note that you may mix in [Dictionary]s for your answers as desired and that anything defined in the
## "phrases" property will be displayed [b]after[/b] the boilerplate response, if provided.

## [Dialog]-specific properties that should be applied from the provided configuration.
## [br]These are properties that may propagate between [Dialog]s as defined in [Dialog] and [Dialog.Sequence].
const PROPAGATED_PROPERTIES = ["speaker", "using_typing"]

# the default phrases for the `start` and `end` Dialogs, as well as the
# "correct" and "wrong" answer cases
var _const_phrases := {
	"start": ["Hello sweetie:)", "Time for a QUIZ!!!"],
	"correct": ["WOOOOO THAT'S CORRECT!!"],
	"wrong": ["I'm sorry, that's incorrect"],
	"end": ["QUIZ OVER!", "You scored %s/%s!!!"],
}

# the head of the quiz's Sequence
var _start = Dialog.new()
# the end of the quiz's Sequence
var _end = Dialog.new().on_before_all(_setup_end)

## The total number of questions answered correctly.
var score := 0
## A map of the Dialogs generated from the supplied quiz configuration.
## [br]Shape:
##      [codeblock]
##		var dialogs := {
##		    "q1": {
##		        "question": Dialog,
##		        "answers": Array[Dialog]
##		    }
##		}
var dialogs := {}
## The final [Dialog.Sequence] representing the quiz.
var sequence: Dialog.Sequence


# helper function to check for and set existing properties between two objects
func _set_or_do_nothing(target: Variant, from: Variant, property: Variant) -> void:
	if property is Array:
		for _property in property:
			_set_or_do_nothing(target, from, _property)

		return

	if property in target and property in from:
		target[property] = from[property]


func _init(quiz_config: Dictionary, default_phrases := {}) -> void:
	_set_or_do_nothing(_const_phrases, default_phrases, default_phrases.keys())

	_generate_quiz(quiz_config)
	_map_next()

	_set_or_do_nothing(_start, quiz_config.q1, PROPAGATED_PROPERTIES)

	sequence = (
		_start.set_phrases(_const_phrases.start).add_next(dialogs.q1.question).build_sequence()
	)


# once the quiz is complete, populate the end Dialog's phrases as appropriate
func _setup_end() -> void:
	for end_phrase in _const_phrases.end:
		if "%s" in end_phrase:
			_end.add_phrase(end_phrase % [score, len(dialogs)])
		else:
			_end.add_phrase(end_phrase)


# create the Dialog for an answer while handling differently shaped definitions in the config
func _create_answer_dialog(answer: Variant, is_correct := false) -> Dialog:
	var dialog: Dialog
	var key := "correct" if is_correct else "wrong"

	match typeof(answer):
		TYPE_STRING:
			dialog = Dialog.new(_const_phrases[key], answer)
		TYPE_DICTIONARY:
			dialog = Dialog.new(_const_phrases[key] + answer.phrases, answer.option)

	assert(
		dialog != null,
		(
			"No overload available for method _create_answer_dialog for the provided arguments. Argument `answer` is of type %s."
			% typeof(answer)
		)
	)

	return dialog


# use the quiz config to generate a map of Dialogs in quiz_dialogs
func _generate_quiz(quiz_config: Dictionary) -> void:
	for key in quiz_config:
		dialogs[key] = {}

		dialogs[key].question = Dialog.new([quiz_config[key].question])

		_set_or_do_nothing(dialogs[key].question, quiz_config[key], PROPAGATED_PROPERTIES)

		dialogs[key].answers = []

		dialogs[key].answers.push_back(
			_create_answer_dialog(quiz_config[key].correct, true).on_before_all(func(): score += 1)
		)

		for wrong_answer in quiz_config[key].wrong:
			dialogs[key].answers.push_back(_create_answer_dialog(wrong_answer, false))


# after we've generated the Dialogs, use the quiz_config to map their `next_dialogs` references as appropriate
func _map_next() -> void:
	for key in dialogs:
		for answer in dialogs[key].answers:
			var next_key = "q%s" % (int(key[1]) + 1)

			answer.add_next(dialogs[next_key].question if next_key in dialogs else _end)

		randomize()  # randomize the seed
		dialogs[key].answers.shuffle()

		dialogs[key].question.set_next(dialogs[key].answers)
