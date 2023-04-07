extends Resource

const config := [standard, easy, medium, hard]

const standard := {
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

const easy := {
	"q1":
	{
		"speaker": "Mother",
		"using_typing": true,
		"question": "What does ACL stand for?",
		"correct": "Anterior Cruciate Ligament",
		"wrong":
		["Anterior Collateral Ligament", "Anterior Crucial Ligament", "Anterior Cross Ligament"]
	},
	"q2":
	{
		"question": "Which of these is NOT a recommended way to prevent ACL injuries?",
		"correct": "Ignoring warm-ups before activities",
		"wrong":
		[
			"Practicing safe jumping and landing techniques",
			"Strengthening leg muscles",
			"Wearing proper footwear"
		]
	},
	"q3":
	{
		"question": "What is the primary function of the ACL in the knee?",
		"correct": "Stabilizing and supporting the knee joint",
		"wrong":
		[
			"Provide flexibility",
			"Allowing rotation of the knee",
			"Connecting the thigh bone to the shin bone"
		]
	},
	"q4":
	{
		"speaker": "Father",
		"question": "Which sport has a higher risk of ACL injuries?",
		"correct": "Basketball",
		"wrong": ["Swimming", "Cycling", "Table tennis"]
	},
	"q5":
	{
		"question": "What type of movement can increase the risk of an ACL injury?",
		"correct": "Sudden stops and changes in direction",
		"wrong": ["Stretching", "Walking", "Climbing stairs"]
	}
}

const medium := {
	"q1":
	{
		"speaker": "Mother",
		"using_typing": true,
		"question": "In which direction does the ACL primarily prevent excessive movement?",
		"correct": "Forward",
		"wrong": ["Backward", "Sideways", "Upward"]
	},
	"q2":
	{
		"question": "How can you reduce the risk of an ACL injury?",
		"correct": "Strengthening leg muscles and practicing proper techniques",
		"wrong":
		["Wearing knee braces constantly", "Avoiding sports altogether", "Running on hard surfaces"]
	},
	"q3":
	{
		"question": "Which of these is a common symptom of an ACL injury?",
		"correct": "Popping sound at the time of injury",
		"wrong":
		[
			"Gradual pain in the knee over several days",
			"Numbness in the foot",
			"Inability to move the ankle"
		]
	},
	"q4":
	{
		"speaker": "Father",
		"question": "Which gender is generally more prone to ACL injuries in sports?",
		"correct": "Female athletes",
		"wrong": ["Male athletes", "No difference between genders", "It depends on the sport"]
	},
	"q5":
	{
		"question": "What is a common surgical procedure for repairing a torn ACL?",
		"correct": "ACL reconstruction",
		"wrong": ["Arthroscopy", "Meniscectomy", "Knee replacement"]
	}
}

const hard := {
	"q1":
	{
		"speaker": "Mother",
		"using_typing": true,
		"question":
		"Which of the following factors can increase the risk of non-contact ACL injuries during jumping or landing?",
		"correct": "Narrow stance during landing",
		"wrong": ["Weak core muscles", "Wearing shoes with good traction", "Overtraining"]
	},
	"q2":
	{
		"question":
		"Which muscle group is most important to strengthen in order to protect the ACL?",
		"correct": "Hamstrings",
		"wrong": ["Quadriceps", "Calves", "Hip flexors"]
	},
	"q3":
	{
		"question": "What is the name of the specific test used to check for an ACL tear?",
		"correct": "Lachman test",
		"wrong": ["McMurray test", "Thomas test", "Apley's test"]
	},
	"q4":
	{
		"speaker": "Father",
		"question":
		"What is the primary reason why female athletes have a higher risk of ACL injuries compared to male athletes?",
		"correct": "All of the above",
		"wrong":
		["Hormonal differences", "Anatomical differences", "Differences in muscle strength"]
	},
	"q5":
	{
		"question": "Which of the following bones does the ACL connect in the knee?",
		"correct": "Femur and tibia",
		"wrong": ["Tibia and fibula", "Femur and patella", "Patella and tibia"]
	}
}
