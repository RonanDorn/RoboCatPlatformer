extends Node

var score		: int	 = 0
var best_score	: int	 = 0

var skills : Dictionary = { "high_jump"	 : false, 
							"double_jump": false,
							"wall_jump"	 : false,
							"mob_jump"	 : false}

func _ready():
	GlobalEvents.coin_picked.connect(score_up)
	GlobalEvents.player_dead.connect(score_down)
	GlobalEvents.active_skill.connect(skill_activated)
	
func score_up():
	score += 5
	if score > best_score:
		best_score = score
	GlobalEvents.get_score.emit(score, best_score)

func score_down():
	score -= 2
	GlobalEvents.get_score.emit(score, best_score)

func skill_activated(skill_name):
	if skills.has(skill_name):
		skills[str(skill_name)] = true
