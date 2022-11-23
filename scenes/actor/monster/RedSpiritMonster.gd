extends "res://scenes/actor/monster/Monster.gd"

const MAX_LIGHT_INTENSITY = 0.7

onready var light = $Light2D
onready var particles = $Particles2D

func wake_up():
	.wake_up()
	light.enabled = true
	particles.emitting = true
	
	$LightTween.interpolate_property(light, "energy", 0, MAX_LIGHT_INTENSITY, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN)
	$LightTween.start()
