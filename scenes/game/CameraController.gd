extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("player_entered_level", self, "move_camera")



func move_camera(target_position):
	$Tween.interpolate_property($Camera2D, "global_position", $Camera2D.global_position, target_position, 0.75, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
