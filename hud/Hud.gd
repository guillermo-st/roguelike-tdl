extends CanvasLayer

onready var life_bar = $LifeBar
onready var anim = $AnimationPlayer
onready var trans_tween = $TransitionTween

func on_player_hit(damage):
	life_bar.life -= damage

func revive():
	life_bar.reset()

func transition_black():
	anim.play("transition")


func transition_clear():
	anim.play_backwards("transition")
