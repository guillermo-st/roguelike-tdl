extends Node2D

export(String, DIR) var level_dir
export(int, 2, 100) var level_depth
export(int, 0, 3) var repeats

onready var rng = RandomNumberGenerator.new()
var level_height = ProjectSettings.get_setting("display/window/size/height")
var level_width = ProjectSettings.get_setting("display/window/size/width")
var level_paths = Array()
var level_grid = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level_paths()
	
	for i in range(level_depth * 2):
		level_grid.append([])
		level_grid[i] = []
		for j in range(level_depth * 2):
			level_grid[i].append([])
			level_grid[i][j] = null
	
	level_grid[level_depth - 1][level_depth -1] = $InitialLevel
	for _r in range(repeats + 1):
		fill_level_grid(level_depth - 1, level_depth - 1)
	
	place_levels()
	
	$Camera2D.global_position = $level.position

#loads all strings representing the levels to be selected into a list.
func load_level_paths():
	var dir = Directory.new()
	
	if dir.open(level_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				level_paths.append(dir.get_current_dir() + "/" + file_name)
			file_name = dir.get_next()

#Fill the level grid with randomly chosen level instances, starting from the (x,y) position and growing in branches
#The direction in which these level branches grow is also chosen randomly
func fill_level_grid(x, y):
	rng.randomize()
	var remaining_depth = level_depth
	var previous_x = null
	var previous_y = null
	
	while remaining_depth > 0:
		var next_index = get_next_dir(x, y, previous_x, previous_y)
		while is_out_of_bounds(next_index[0], next_index[1]):
			next_index = get_next_dir(x, y , previous_x, previous_y)
			
		previous_x = x
		previous_y = y
		x = next_index[0]
		y = next_index[1]

		if is_fully_attached(x, y) or level_grid[x][y] != null:
			continue
	
		var next_level_path_index = rng.randi_range(0, level_paths.size() - 1)
		var next_level_path = load(level_paths[next_level_path_index])
		var next_level = next_level_path.instance()
		add_child(next_level)
		level_grid[x][y] = next_level
		
		remaining_depth -= 1

#Take the levels from the level_grid and position them in the world
func place_levels():
	for i in range(level_grid.size() - 1):
		for j in range (level_grid.size() -1):
			var level = level_grid[i][j]
			if level:
				level.global_position.x = j * level_width
				level.global_position.y = i * level_height

#Returns wheter this level is attached to other 4 levels in all of its directions or not.
func is_fully_attached(index_x, index_y):
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

#returns wheter the chosen (x,y) index is out of bounds in the matrix
func is_out_of_bounds(x, y):
	return x < 0 or y < 0 or x >= (2 * level_depth -1) or y >= (2 * level_depth - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
