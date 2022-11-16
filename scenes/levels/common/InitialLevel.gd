extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for door in $baseLevel/Doors.get_children():
		door.allow_interaction(false)
		door.should_position_player = false
