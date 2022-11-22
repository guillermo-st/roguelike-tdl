extends "res://scenes/items/Item.gd"


var spinning_axes = preload("res://scenes/powerups/temporal/spinningAxes/SpinningAxes.tscn")

func affect_player():
	if player:
		player.call_deferred('add_child', spinning_axes.instance())
