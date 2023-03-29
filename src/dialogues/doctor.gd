extends Resource

const config := [intro, outro]

const intro = {
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

const outro = {
	"start": {
		"speaker": "Dr. Wu",
		"using_typing": true,
		"phrases": ["This is the end of the x-ray game.", "Good job!"]
	}
}
