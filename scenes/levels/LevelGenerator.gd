extends Node2D

export(String, DIR) var level_dir
export(int, 2, 100) var level_depth
export(int, 0, 3) var repeats

onready var rng = RandomNumberGenerator.new()

var initial_level_path = preload("res://scenes/levels/common/InitialLevel.tscn")
var exit_level_path = preload("res://scenes/levels/common/ExitLevel.tscn")
var level_height = ProjectSettings.get_setting("display/window/size/height")
var level_width = ProjectSettings.get_setting("display/window/size/width")
var level_paths = []
var current_zone_number = 1

var current_zone_position = Vector2(0,0)
var next_zone_position = Vector2(level_width * level_depth * 5, 0)

func get_next_zone():
	load_level_paths()
	var zone_and_pos =  generate_zone()
	current_zone_number += 1
	return zone_and_pos

func generate_zone():
	var grid = new_grid()
	var zone = Node2D.new()
	add_child(zone)
	
	var initial_level = initial_level_path.instance()
	zone.add_child(initial_level)
	grid[level_depth - 1][level_depth -1] = initial_level
	
	for _r in range(repeats + 1):
		fill_level_grid(grid, zone, level_depth - 1, level_depth - 1)
		
	place_levels(grid, zone)
	var initial_pos = initial_level.get_node("baseLevel/CenterAnchor").global_position
	remove_child(zone)
	return [zone, initial_pos]

#loads all strings representing the levels to be selected into a list.
func load_level_paths():
	level_paths = Array()
	var dir = Directory.new()
	
	if dir.open(level_dir + "/" + str(current_zone_number) + "/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				level_paths.append(dir.get_current_dir() + "/" + file_name)
			file_name = dir.get_next()

#Fill the level grid with randomly chosen level instances, starting from the (x,y) position and growing in branches
#The direction in which these level branches grow is also chosen randomly
func fill_level_grid(grid, zone, start_x, start_y):
	rng.randomize()
	var remaining_depth = level_depth
	var x = start_x
	var y = start_y
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

		if is_fully_attached(grid, x, y) or grid[x][y] != null:
			continue
	
		var next_level_path_index = rng.randi_range(0, level_paths.size() - 1)
		var next_level_path = load(level_paths[next_level_path_index])
		var next_level = next_level_path.instance()
		zone.add_child(next_level)
		grid[x][y] = next_level
		
		remaining_depth -= 1


#Take the levels from the level_grid and position them in the world
func place_levels(grid, zone):
	generate_exit_level(grid, zone)
	for i in range(grid.size() - 1):
		for j in range (grid.size() -1):
			var level = grid[i][j]
			if level:
				configure_doors(grid, level, j, i)
				level.global_position.x = zone.global_position.x + j * level_width
				level.global_position.y = zone.global_position.y + i * level_height
	

func generate_exit_level(grid, zone):
	var possible_positions = []
	for i in range (grid.size() - 1):
		for j in range (grid.size() - 1):
			if grid[j][i]:
				if adjacent_level_count(grid, j, i) <= 2:
					possible_positions.append([j, i])
	

	var selected_position_index = rng.randi_range(0, possible_positions.size() - 1)
	var selected_x = possible_positions[selected_position_index][0]
	var selected_y = possible_positions[selected_position_index][1]
	
	var next_dir = get_next_dir(selected_x, selected_y, selected_x, selected_y)
	while(grid[next_dir[0]][next_dir[1]] != null or is_out_of_bounds(next_dir[0], next_dir[1])):
		next_dir = get_next_dir(selected_x, selected_y, selected_x, selected_y)
		
	var exit_x = next_dir[0]
	var exit_y = next_dir[1]
	var exit_level = exit_level_path.instance()
	grid[exit_x][exit_y] = exit_level
	zone.add_child(exit_level)

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
	
func new_grid():
	var grid = Array()
	for i in range(level_depth * 2 + 1):
		grid.append(Array())
		grid[i] = Array()
		for j in range(level_depth * 2 + 1):
			grid[i].append(Array())
			grid[i][j] = null
	
	return grid

#seal the level doors that lead to nowhere
func configure_doors(grid, level, x, y):
	if level:
		if not grid[y][x-1]:
			level.get_node("baseLevel").seal_door("left")
		if not grid[y][x+1]:
			level.get_node("baseLevel").seal_door("right")
		if not grid[y-1][x]:
			level.get_node("baseLevel").seal_door("up")
		if not grid[y+1][x]:
			level.get_node("baseLevel").seal_door("down")

func adjacent_level_count(grid, x, y):
	var adjacents = 0
	if grid[x][y+1]:
		adjacents += 1
	if grid[x][y-1]:
		adjacents += 1
	if grid[x+1][y]:
		adjacents += 1
	if grid[x-1][y]:
		adjacents += 1
	return adjacents

#Returns wheter this level is attached to other 4 levels in all of its directions or not.
func is_fully_attached(grid, index_x, index_y):
	var up = grid[index_x][index_y + 1]
	var left = grid[index_x - 1][index_y]
	var down = grid[index_x][index_y - 1]
	var right = grid[index_x + 1][index_y]
	
	return up and left and down and right

func debug_grid(grid):
	var grid_string = ""
	for i in range(grid.size() - 1):
		for j in range (grid.size() -1):
			if grid[i][j] != null:
				grid_string += "[ X ]"
			else:
				grid_string += "[   ]"
		grid_string += "\n"
	
	print(grid_string)
