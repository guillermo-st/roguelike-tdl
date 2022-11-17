extends Node2D

onready var room_already_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	$ExitDoorTimer.start()
	$baseLevel.connect("player_entered_level", self, "setup_exit")
	for door in $baseLevel/Doors.get_children():
		door.allow_interaction(false)

func setup_exit():
	if room_already_entered:
		return
	$ExitDoorTimer.start()
	

func _on_ExitDoorTimer_timeout():
	$Exit.open()
