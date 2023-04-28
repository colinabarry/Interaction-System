extends Resource

const config = [first, second]

const first := {
	"start":
	{
		"speaker": "Narrator",
		"using_typing": true,
		"phrases":
		[
			"The player is enjoying a peaceful jog in the park, taking in the sights and sounds around them."
		],
		"next": ["p_t_1"]
	},
	"p_t_1":
	{
		"speaker": "Player (thinking)",
		"phrases": ["It's such a beautiful day! I'm glad I decided to go for a walk."],
		"next": []
	},
}

const second := {
	"start":
	{
		"speaker": "Player (dialogue)",
		"phrases": ["Ouch! My knee! What just happened?"],
		"next": ["n_post_tear"]
	},
	"n_post_tear":
	{
		"speaker": "Narrator",
		"phrases":
		[
			"The player hears a loud popping sound accompanied by a sudden, sharp pain in their knee, which could be a sign of an ACL injury."
		],
		"next": ["p_t_2"]
	},
	"p_t_2":
	{
		"speaker": "Player (thinking)",
		"phrases": ["I can barely walk. I need to call for help."],
		"next": ["p_d_2"]
	},
	"p_d_2":
	{"speaker": "Player (dialogue)", "phrases": ["I need to call my parents and get to a doctor."]},
}
