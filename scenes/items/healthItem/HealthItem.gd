extends "res://scenes/items/Item.gd"

onready var audio = $AudioStreamPlayer

func affect_player():
	if player:
		remove_child(audio)
		get_parent().add_child(audio)
		audio.play()
		player.heal(1)
