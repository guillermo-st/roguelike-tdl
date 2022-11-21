extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Signals
	$Player.connect("take_damage", $Hud, "on_player_hit")
	$Hud/LifeBar.connect("dead", self, "game_over")
	$Menu.connect("start_game", self, "start_game")
	
	# Prevent the player from interacting with the game before the play button is pressed
	$Hud.hide()
	$LevelGenerator.hide()
	$Player.hide()
	

func start_game():
	$Hud.show()
	$LevelGenerator.show()
	$Player.show()
	
	# Add the player node to the game
	$Player.global_position = $LevelGenerator/InitialLevel/baseLevel/CenterAnchor.global_position
	$CameraController/Camera2D.global_position = $Player.global_position
	

func game_over():
	$Menu.show_game_over()
	yield($Menu, "game_over")
	get_tree().reload_current_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
