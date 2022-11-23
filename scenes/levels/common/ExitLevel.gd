extends Node2D

onready var room_already_entered
onready var torches = $Torches.get_children()
onready var torch_timer = $TorchTimer
onready var exit_door_timer = $ExitDoorTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	$baseLevel.connect("player_entered_level", self, "setup_exit")
	
	torch_timer.wait_time = 1.0/(torches.size() + 1)
	
	for door in $baseLevel/Doors.get_children():
		door.allow_interaction(false)
	
	for torch in torches:
		torch.turn_off()

func setup_exit():
	if room_already_entered:
		return
	exit_door_timer.start()
	torch_timer.start()
	

func _on_ExitDoorTimer_timeout():
	$Exit.open()


func _on_TorchTimer_timeout():
	var next_torch = torches.pop_back()
	if not next_torch:
		torch_timer.stop()
		return
	next_torch.turn_on()

