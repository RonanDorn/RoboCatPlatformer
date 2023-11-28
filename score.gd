extends CanvasLayer

func _ready():
	GlobalEvents.get_score.connect(score_update)
	
func score_update(score, best_score):
	$Label.text = "Score: " + str(score)
	$Label2.text = "BestScore: " + str(best_score)
