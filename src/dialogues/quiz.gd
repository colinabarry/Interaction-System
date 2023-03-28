@tool
extends DialogueResource


func _init():
	super("quiz")


const config = {
	"q1":
	{
		"speaker": "Mother",
		"using_typing": true,
		"question": "What does ACL stand for?",
		"correct": "Anterior Cruciate Ligament",
		"wrong":
		["Automatic Control Ligament", "Acute Collateral Ligament", "Active Condyle Ligament"]
	},
	"q2":
	{
		"question": "Which of the following activities can increase the risk of an ACL injury?",
		"correct": "Jumping with sudden stops and changes in direction",
		"wrong": ["Swimming", "Riding a bike", "Jogging at a steady pace"],
	},
	"q3":
	{
		"question": "What is one way to help prevent ACL injuries?",
		"correct": "Practicing safe jumping and landing techniques",
		"wrong":
		[
			"Skipping warm-ups before activities",
			"Wearing loose shoes during sports",
			"Ignoring pain or discomfort in the knee"
		]
	},
	"q4":
	{
		"speaker": "Father",
		"question":
		"On average, how long does it take to recover from an ACL injury after surgery?",
		"correct": "6-9 months",
		"wrong": ["2-4 weeks", "3-6 months", "1-2 years"]
	},
	"q5":
	{
		"question": "How many main ligaments are there in the knee, including the ACL?",
		"correct": "Four",
		"wrong": ["Two", "Three", "Five"]
	}
}
