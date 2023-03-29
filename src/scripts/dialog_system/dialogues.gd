extends Node

## for testing dialog using Dialog objects instead of a config
var test_start = Dialog.new(
	["This is the starting dialog!!", "This is cool, huh?", MULT_NEXT], "start_dialog"
)


func _init():
	# inside here so all these aren't accessible
	var opt0_dead = Dialog.new(["Hey there, this is the first option!", DEAD], "1st (dead)")
	var opt1_cycle = Dialog.new(["Hey there, this is the second option!", CYCLES], "2nd (cycles)")
	var opt2 = Dialog.new(["Oh wow, the third option!", ONE_NEXT], "3rd (1 next, dead)")
	var opt3 = Dialog.new(["Holy cow! The fourth option!", ONE_NEXT], "4th (1 next, cycles)")
	var opt4 = Dialog.new(["bing bong I'm #5", MULT_NEXT], "5th (2 next)")
	var after_opt2_dead = Dialog.new(["Uh oh, I'm after option 3!", DEAD], "after 3rd (dead)")
	var after_opt3_cycle = Dialog.new(["After option 4", CYCLES], "after 4th (cycles)")
	var after_opt4_dead = Dialog.new(["After option 5", DEAD], "after 5th (dead)")
	var after_opt4_cycle = Dialog.new(["After opt five", CYCLES], "after 5th (cycles)")

	after_opt4_cycle.add_next(test_start)
	opt4.set_next([after_opt4_dead, after_opt4_cycle])
	after_opt3_cycle.add_next(test_start)
	opt3.add_next(after_opt3_cycle)
	opt2.add_next(after_opt2_dead)
	opt1_cycle.add_next(test_start)

	test_start.set_next([opt0_dead, opt1_cycle, opt2, opt3, opt4])
	test_start.using_typing = true


const DEAD = "You shouldn't see any additional options, nor should you be able to see dialog past this!"
const ONE_NEXT = "You shouldn't see any options, but clicking should show new dialog!"
const CYCLES = "Clicking should bring you back to the start dialog!"
const MULT_NEXT = "You should see options!"

const quiz_configll = {
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

const hm_test = {
	"start":
	{
		"speaker": "deez",
		"using_typing": true,
		"phrases": ["Hello there mr monkey man"],
		"next": ["opt1"]
	},
	"opt1": {"phrases": ["hmmmm idk man", "uhhh yes you do man"], "next": ["opt2", "opt3"]},
	"opt2": {"phrases": ["uh ohhhh"], "option_name": "ded"},
	"opt3": {"phrases": ["oh ohoh ohoh"], "option_name": "lop", "next": ["start"]}
}

const test_config = {
	"start":
	{
		"speaker": "Melanie Ford",
		"using_typing": true,  # this will propagate to all proceeding Dialogs
		"phrases": ["This is the starting dialog!!", "This is cool, huh?", MULT_NEXT],
		"next": ["opt0_dead", "opt1_cycle", "opt2", "opt3", "opt4"],
	},
	"opt0_dead":
	{
		"phrases": ["Hey there, this is the first option!", DEAD],
		"option_name": "1st (dead)",
		"next": [],
	},
	"opt1_cycle":
	{
		"phrases": ["Hey there, this is the second option!", CYCLES],
		"option_name": "2nd (cycles)",
		"next": ["start"],
	},
	"opt2":
	{
		"phrases": ["Oh wow, the third option!", ONE_NEXT],
		"option_name": "3rd (1 next, dead)",
		"next": ["after_opt2_dead"],
	},
	"opt3":
	{
		"phrases": ["Holy cow! The fourth option!", ONE_NEXT],
		"option_name": "4th (1 next, cycles)",
		"next": ["after_opt3_cycle"],
	},
	"opt4":
	{
		"speaker": "Dr. Wu",
		"phrases": ["bing bong I'm #5", MULT_NEXT],
		"option_name": "5th (2 next)",
		"next": ["after_opt4_dead", "after_opt4_cycle"],
	},
	"after_opt2_dead":
	{
		"phrases": ["Uh oh, I'm after option 3!", DEAD],
		"option_name": "after 3rd (dead)",
		"next": [],
	},
	"after_opt3_cycle":
	{
		"phrases": ["After option 4", CYCLES],
		"option_name": "after 4th (cycles)",
		"next": ["start"],
	},
	"after_opt4_dead":
	{
		"phrases": ["After option 5", DEAD],
		"option_name": "after 5th (dead)",
		"next": [],
	},
	"after_opt4_cycle":
	{
		"phrases": ["After opt five", CYCLES],
		"option_name": "after 5th (cycles)",
		"next": ["start"],
	},
}

const test_bubble_config = {
	"start":
	{
		"phrases":
		[
			"Hello",
			"This is a test",
			"REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
		],
	}
}

const doctor = {
	"start":
	{
		"speaker": "Dr. Wu",
		"using_typing": true,
		"phrases":
		[
			"Hello there! I'm Dr. Wu. I heard you injured you knee while jumping. I'm sorry to hear that, but you've come to the right place.",
			"It sounds like you might have hurt your ACL, which stands for Anterior Cruciate Ligament. The ACL is one of the four main ligaments in your knee, and it helps to stabilize and support your knee joint.",
			"Injuries to the ACL are pretty common, especially in sports that involve jumping, quick stops, and changes in direction. It's important to learn how to prevent these injuries and take care of your body.",
			"The good news is that most ACL injuries can be treated, and we're going to figure out the best plan for you.",
			"Now, lets take a closer look at your knee using our state-of-the-art x-ray machine. This machine will allow you to see your bones and ligaments, so you can better understand the structure of your knee and the location of your ACL.",
			"When you're ready, please step up to the x-ray machine.",
			"You'll be able to move the x-ray window over your body to examine different parts of your knee. When you find key features, like your ACL or other ligaments, click on them to learn more about their functions and important in preventing injuries.",
			"Good luck, and if you have any questions, don't hesitate to ask!"
		],
		"next": ["options"]
	},
	"options": {"next": ["overview", "importance", "treatment", "examining", "how-to"]},
	"overview":
	{
		"option_name": "Overview of the ACL",
		"phrases":
		[
			"The ACL, or Anterior Cruciate Ligament, is one of the four main ligaments in your knee. It plays a crucial role in stabilizing and supporting your knee joint.",
			"Injuries to the ACL can happen in various situations, especially during sports activities that involve jumping, sudden stops, or changes in direction."
		],
		"next": ["options"]
	},
	"importance":
	{
		"option_name": "Importance of ACL Injury Prevention",
		"phrases":
		[
			"It's essential to learn how to prevent ACL injuries and take care of your body. Proper warm-ups, muscle strengthening, and practicing safe jumping and landing techniques can reduce the risk of injuring your ACL.",
			"Remember, prevention is always better than dealing with an injury!"
		],
		"next": ["options"]
	},
	"treatment":
	{
		"option_name": "Treatment of ACL Injuries",
		"phrases":
		[
			"Most ACL injuries can be treated through a combination of rest, rehabilitation, and sometimes surgery. The treatment plan depends on the severity of the injury and your personal goals.",
			"It's important to work with a medical professional to devlop the best plan for your recovery."
		],
		"next": ["options"]
	},
	"examining":
	{
		"option_name": "X-ray Machine and Knee Anatomy",
		"phrases":
		[
			"The x-ray machine helps us visualize the bones and ligaments in your knee. By examining different parts of your knee, you can better understand the structure and the location of important components like the ACL.",
			"This knowledge can be helpful in preventing future injuries and maintaining a healthy knee."
		],
		"next": ["options"]
	},
	"how-to":
	{
		"option_name": "How to use the X-ray",
		"phrases":
		[
			"You can move the x-ray window over your body to explore different areas of your knee. When you find key features, like your ACL or other ligaments, click on them to learn more about their functions and important in preventing injuries.",
			"Feel free to explore and ask any questions you might have."
		],
		"next": ["options"]
	}
}
