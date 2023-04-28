extends Resource

const config = [intro, jump_intro, jump, outro]

# const intro = {
# 	"start":
# 	{
# 		"speaker": "Trainer Berry",
# 		"using_typing": true,
# 		"phrases":
# 		[
# 			"Hey there, I'm Trainer Berry, your physical therapist. I heard you're recovering from an ACL injury. Welcome to the gym, where we'll help you get back on track!",
# 			"Rehabilitation is crucial for regaining strength and mobility in your knee. We'll work together to develop a personalized program designed just for you.",
# 			"Our primary goals will be to reduce pain, improve range of motion, and strengthen your leg muscles to better support your knee joint.",
# 			"Throughout your rehab journey, we'll focus on exercises that target your quadriceps, hamstrings, and core muscles. It's important to be patient and consistent with your progress.",
# 			"Before we begin, let's do a quick assessment of your current knee function. This will help us tailor the exercises to your specific needs and monitor your improvement.",
# 			"Now, let's get started with some gentle warm-ups and stretches. Remember, it's essential to communicate any discomfort or concerns during your sessions. We're here to support you every step of the way!"
# 		]
# 	}
# }

const intro = {
	"start":
	{
		"speaker": "Trainer Berry",
		"using_typing": true,
		"phrases":
		[
			"Hey there, I'm Trainer Berry, your physical therapist. I heard you're recovering from an ACL injury. Welcome to the gym, where we'll help you get back on track!",
			"Rehabilitation is crucial for regaining strength and mobility in your knee. We'll work together to develop a personalized program designed just for you.",
			"We'll start with gentle exercises to improve your knee's range of motion and activate the muscles around the joint. As you progress, we'll introduce more challenging exercises to build strength, improve balance, and restore stability.",
			"In the later stages of your rehab, we'll focus on functional movements and sport-specific exercises to prepare you for a safe return to your pre-injury activities.",
			"Throughout the process, we'll regularly assess your progress and adjust your rehabilitation program as needed. It's essential to communicate openly about your symptoms and follow the prescribed exercises and guidelines.",
			"Together, we'll work towards a successful recovery, and I'll be here to support and guide you every step of the way.",
			"Now, let's get started..."
		]
	}
}

const jump_intro = {
    "start":
    {
        "speaker": "Trainer Berry",
        "using_typing": true,
        "phrases":
        [
            "You've been making some great progress so far! I think we're ready to move on to the next stage of your rehab.",
        ]
    }
}

const jump = {
	"start":
	{
		"speaker": "Trainer Berry",
		"using_typing": true,
		"phrases":
		[
			"Alright kid, now it's time for jump training.",
			"This little bar on the side will show you when to jump.",
			"You must do your best to maintain an appropriate posture and only jump when you're putting the least strain on your body.",
			"Of course, jumping isn't the concern. How you land from your jump is what causes injury, which is why we want to make sure you're always prepared with proper posture."
		]
	}
}

const outro = {
	"start":
	{
		"speaker": "Trainer Berry",
		"using_typing": true,
		"phrases":
		[
			"Great job today! You've made a lot of progress, and I'm proud of you.",
			"Remember to keep up the good work and stay consistent with your rehab. I'll see you next time!"
		]
	}
}
