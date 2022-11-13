extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.global_position = $LevelGenerator/InitialLevel/baseLevel/CenterAnchor.global_position
	$Player.connect("hit", $Hud, "on_player_hit")
	$CameraController/Camera2D.global_position = $Player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
