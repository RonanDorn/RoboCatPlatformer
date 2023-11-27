extends Node

var score = 0

var high_jump	 = false
var double_jump	 = false
var wall_jump	 = false
var mob_jump	 = false

func _ready():
	GlobalEvents.coin_picked.connect(score_up)
	
func score_up():
	score += 5

func skill_activated(skill_name):
	skill_name = true
