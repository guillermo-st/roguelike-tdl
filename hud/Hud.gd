extends CanvasLayer

onready var life_bar = $LifeBar
onready var score = 0

func on_player_hit(damage):
	life_bar.life -= damage

func revive():
	life_bar.reset()
	
	
func update_score(value):
	score += value
	$ScoreLabel.text = str(score)
