extends Node

var current_zone
var auxiliary_player_pos = Vector2(-5000, -5000)

onready var hud = $Hud
onready var player = $Player
onready var zone_number = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Signals
	$Player.connect("take_damage", $Hud, "on_player_hit")
	$Player.connect("heal", $Hud, "on_player_heal")
	$Hud/LifeBar.connect("dead", self, "game_over")
	$Menu.connect("start_game", self, "start_game")
	SignalBus.connect("zone_exited", self, "start_new_zone_deferred")
	
	# Prevent the player from interacting with the game before the play button is pressed
	$Hud.hide()
	$Player.hide()
	

func start_game():
	$Hud.show()
	$Player.show()
	$Background.queue_free()
	start_new_zone()
	
func game_over():
	$Menu.show_game_over()
	yield($Menu, "game_over")
	hud.transition_black()
	yield(hud.get_node("AnimationPlayer"), "animation_finished")
	get_tree().reload_current_scene()

func start_new_zone_deferred():
	call_deferred("start_new_zone")

func start_new_zone():
	player.global_position = auxiliary_player_pos
	zone_number += 1
	hud.update_score(zone_number)
	
	if current_zone != null:
		hud.transition_black()
		yield(hud.get_node("AnimationPlayer"), "animation_finished")
		remove_child(current_zone)
		current_zone.queue_free()

	
	var zone_and_pos = $LevelGenerator.get_next_zone()
	current_zone = zone_and_pos[0]
	add_child(current_zone)
	
	player.global_position = zone_and_pos[1]
	$CameraController/Camera2D.global_position = zone_and_pos[1]
	hud.transition_clear()
