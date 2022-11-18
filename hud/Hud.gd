extends CanvasLayer

onready var life_bar = $LifeBar

func on_player_hit(damage):
	life_bar.life -= damage
	

func on_player_heal(heal_amount):
	if not (life_bar.life + heal_amount > life_bar.max_life):
		life_bar.life += heal_amount


func revive():
	life_bar.reset()
