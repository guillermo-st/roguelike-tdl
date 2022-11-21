extends CanvasLayer

onready var life_bar = $LifeBar
onready var score = 0

func on_player_hit(damage):
	life_bar.life -= damage
	

func on_player_heal(heal_amount):
	if not (life_bar.life + heal_amount > life_bar.max_life):
		life_bar.life += heal_amount
	else:
		life_bar.life = life_bar.max_life


func revive():
	life_bar.reset()
	
	
func update_score(value):
	score += value
	$ScoreLabel.text = str(score)
