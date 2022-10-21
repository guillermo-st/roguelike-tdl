extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attach_level(level_paths, remaining_depth, from_dir, from_level):
	$baseLevel.attach_level(level_paths, remaining_depth, from_dir, from_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
