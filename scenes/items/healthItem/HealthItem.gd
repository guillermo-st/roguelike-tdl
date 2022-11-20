extends "res://scenes/items/Item.gd"


func affect_player():
	if player:
		player.heal(1)
