extends Node2D

onready var base_level = $baseLevel
var monster_controller

# Called when the node enters the scene tree for the first time.
func _ready():
	monster_controller = get_node_or_null("MonsterController")
	if monster_controller:
		monster_controller.connect("all_monsters_defeated", base_level, "open_doors")
		base_level.connect("player_entered_level", monster_controller, "wake_monsters_up" )

