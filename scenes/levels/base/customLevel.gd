extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attach_level(level_grid, level_paths, remaining_depth, index_x, index_y, previous_index_x, previous_index_y):
	level_grid[index_x][index_y] = self
	$baseLevel.attach_level(level_grid, level_paths, remaining_depth, index_x, index_y, previous_index_x, previous_index_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
