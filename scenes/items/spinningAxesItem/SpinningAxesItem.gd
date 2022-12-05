extends "res://scenes/items/Item.gd"

onready var audio = $AudioStreamPlayer
var spinning_axes = preload("res://scenes/powerups/temporal/spinningAxes/SpinningAxes.tscn")

func affect_player():
	if player:
		remove_child(audio)
		get_parent().add_child(audio)
		audio.play()
		player.call_deferred('add_child', spinning_axes.instance())
