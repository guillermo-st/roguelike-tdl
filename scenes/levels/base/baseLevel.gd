extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(_body):
	SignalBus.emit_signal("player_entered_level", $CenterAnchor.global_position)
