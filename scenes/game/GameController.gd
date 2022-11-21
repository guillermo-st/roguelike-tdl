extends Node

var current_zone
var auxiliary_player_pos = Vector2(-32, -32)

onready var hud = $Hud
onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("take_damage", $Hud, "on_player_hit")
	SignalBus.connect("zone_exited", self, "start_new_zone_deferred")
	start_new_zone()

func start_new_zone_deferred():
	call_deferred("start_new_zone")

func start_new_zone():
	
	if current_zone != null:
		hud.transition_black()
		yield(hud.get_node("AnimationPlayer"), "animation_finished")
		remove_child(current_zone)
		current_zone.queue_free()
	
	player.global_position = auxiliary_player_pos
	
	var zone_and_pos = $LevelGenerator.get_next_zone()
	current_zone = zone_and_pos[0]
	add_child(current_zone)
	
	player.global_position = zone_and_pos[1]
	$CameraController/Camera2D.global_position = player.global_position
	
	hud.transition_clear()
