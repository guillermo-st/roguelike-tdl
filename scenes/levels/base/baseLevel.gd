extends Node2D

onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Attaches a random level, chosen from level_paths, to one of this level's free cardinal directions.
# Then it tells that instance to attach_level() too, with a decremented remaining_depth.
# If the level was fully attached to begin with, then it calls attach_level() on one of the levels that isn't the caller
# and without decrementing remaining_depth.
func attach_level(level_grid, level_paths, remaining_depth, index_x, index_y, previous_index_x, previous_index_y):
	rng.randomize()
	if remaining_depth == 0:
		return
	
	var next_index = get_next_dir(index_x, index_y, previous_index_x, previous_index_y)
	var next_x = next_index[0]
	var next_y = next_index[1]
	
	if self.is_fully_attached(level_grid, index_x, index_y):
		level_grid[next_x][next_y].attach_level(level_grid, level_paths, remaining_depth, next_x, next_y, index_x, index_y)
		return
	
	while level_grid[next_x][next_y] != null:
		next_index = get_next_dir(index_x, index_y, previous_index_x, previous_index_y)
		next_x = next_index[0]
		next_y = next_index[1]
	
	var next_level_path_index = rng.randi_range(0, level_paths.size() - 1)
	var next_level_path = load(level_paths[next_level_path_index])
	var next_level = next_level_path.instance()
	get_parent().get_parent().add_child(next_level)
	
	next_level.attach_level(level_grid, level_paths, remaining_depth - 1, next_x, next_y, index_x, index_y)


# Returns wheter this level is attached to other 4 levels in all of its directions or not.
func is_fully_attached(level_grid, index_x, index_y):
	var up = level_grid[index_x][index_y + 1]
	var left = level_grid[index_x - 1][index_y]
	var down = level_grid[index_x][index_y - 1]
	var right = level_grid[index_x + 1][index_y]
	
	return up and left and down and right

# Returns the random next indexes that are not equal to the previous level's.
func get_next_dir(index_x, index_y, previous_index_x, previous_index_y):
	var possible_dirs = Array()
	possible_dirs.append([index_x + 1, index_y])
	possible_dirs.append([index_x - 1, index_y])
	possible_dirs.append([index_x, index_y + 1])
	possible_dirs.append([index_x, index_y - 1])
	
	for dir in possible_dirs:
		if dir == [previous_index_x, previous_index_y]:
			possible_dirs.erase(dir)
	
	var next_dir_index = rng.randi_range(0, possible_dirs.size() - 1)
	return possible_dirs[next_dir_index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
