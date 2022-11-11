extends Node2D

onready var doors = $Doors

# Called when the node enters the scene tree for the first time.
func _ready():
	for door in doors.get_children():
		door.connect("player_entered_door", self, "close_doors")

func close_doors():
	for door in doors.get_children():
		door.close()

func open_doors():
	for door in doors.get_children():
		door.open()

func seal_door(direction):
	match direction:
		"up":
			$Doors/DoorUp.seal()
		"right":
			$Doors/DoorRight.seal()
		"down":
			$Doors/DoorDown.seal()
		"left":
			$Doors/DoorLeft.seal()

func _on_Area2D_body_entered(_body):
	SignalBus.emit_signal("player_entered_level", $CenterAnchor.global_position)

func _on_Area2D_body_exited(body):
	for door in doors.get_children():
		door.should_position_player = true
