extends Resource

const config := [intro, options, outro]

const intro = {
	"start":
	{
		"speaker": "Dr. Wu",
		"using_typing": true,
		"phrases":
		[
			"Hi, I'm Dr. Wu. I heard you hurt your knee while walking. Don't worry, you're in good hands! It seems you might have injured your ACL, which stands for Anterior Cruciate Ligament.",
			"The ACL is one of four key ligaments in your knee and helps with stability. ACL injuries are common in sports involving jumping, quick stops, and sudden changes in direction.",
			"Learning prevention techniques is crucial, and the bright side is that ACL injuries are treatable. We'll find the best plan for your recovery.",
			"Now, let's examine your knee using our advanced x-ray machine. This will help you see your bones and ligaments and pinpoint your ACL's location.",
			"When you're ready, step up to the x-ray machine. Move the x-ray window over your body to explore your knee.",
			"Click on key features like the ACL or other ligaments to learn more about their roles and injury prevention. Good luck, and feel free to ask any questions!"
		],
	},
}

const options = {
	"start_options":
	{
		"speaker": "Dr. Wu",
		"using_typing": true,
		"next": ["overview", "importance", "treatment", "examining", "how-to"]
	},
	"overview":
	{
		"option_name": "Overview of the ACL",
		"phrases":
		[
			"The ACL, or Anterior Cruciate Ligament, is one of the four main ligaments in your knee. It plays a crucial role in stabilizing and supporting your knee joint.",
			"Injuries to the ACL can happen in various situations, especially during sports activities that involve jumping, sudden stops, or changes in direction."
		],
		"next": ["start_options"]
	},
	"importance":
	{
		"option_name": "Importance of ACL Injury Prevention",
		"phrases":
		[
			"It's essential to learn how to prevent ACL injuries and take care of your body. Proper warm-ups, muscle strengthening, and practicing safe jumping and landing techniques can reduce the risk of injuring your ACL.",
			"Remember, prevention is always better than dealing with an injury!"
		],
		"next": ["start_options"]
	},
	"treatment":
	{
		"option_name": "Treatment of ACL Injuries",
		"phrases":
		[
			"Most ACL injuries can be treated through a combination of rest, rehabilitation, and sometimes surgery. The treatment plan depends on the severity of the injury and your personal goals.",
			"It's important to work with a medical professional to devlop the best plan for your recovery."
		],
		"next": ["start_options"]
	},
	"examining":
	{
		"option_name": "X-ray Machine and Knee Anatomy",
		"phrases":
		[
			"The x-ray machine helps us visualize the bones and ligaments in your knee. By examining different parts of your knee, you can better understand the structure and the location of important components like the ACL.",
			"This knowledge can be helpful in preventing future injuries and maintaining a healthy knee."
		],
		"next": ["start_options"]
	},
	"how-to":
	{
		"option_name": "How to use the X-ray",
		"phrases":
		[
			"You can move the x-ray window over your body to explore different areas of your knee. When you find key features, like your ACL or other ligaments, click on them to learn more about their functions and important in preventing injuries.",
			"Feel free to explore and ask any questions you might have."
		],
		"next": ["start_options"]
	}
}

const outro = {
	"start":
	{
		"speaker": "Dr. Wu",
		"using_typing": true,
		"phrases":
		[
			"Great job locating your ACL! Unfortunately, based on our examination, it appears that your ACL is torn.",
			"For the next 2 to 4 weeks, our main focus will be on controlling pain and swelling, and protecting your injured knee. We'll be providing you with a knee brace, crutches, and anti-inflammatory medication to help with this.",
			"During this time, it's crucial to follow our guidance and avoid putting too much strain on the injured knee. Rest, ice, compression, and elevation will be important aspects of your initial treatment.",
			"Once we see improvement in your symptoms, you'll begin a comprehensive rehabilitation program with a physical therapist. This process will usually take 6-9 months, and your progress will be closely monitored to ensure a successful recovery.",
			"Remember, patience and consistency are key during this journey!"
		]
	}
}
