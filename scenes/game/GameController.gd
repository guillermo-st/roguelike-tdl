extends Node

var current_zone

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("take_damage", $Hud, "on_player_hit")
	SignalBus.connect("zone_exited", self, "start_new_zone_deferred")
	start_new_zone()

func start_new_zone_deferred():
	call_deferred("start_new_zone")

func start_new_zone():
	if current_zone != null:
		remove_child(current_zone)
		current_zone.queue_free()
	
	var zone_and_pos = $LevelGenerator.get_next_zone()
	current_zone = zone_and_pos[0]
	add_child(current_zone)
	$Player.global_position = zone_and_pos[1]
	$CameraController/Camera2D.global_position = $Player.global_position
