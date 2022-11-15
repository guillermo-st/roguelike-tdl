extends CanvasLayer

onready var life_bar = $LifeBar

func on_player_hit(damage):
	life_bar.life -= damage

func revive():
	life_bar.reset()
