extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemAnimationPlayer.play("Idle")


func _on_Area2D_body_entered(player):
	self.player = player
	self.affect_player()
	self.queue_free()

#ABSTRACT
func affect_player():
	pass
