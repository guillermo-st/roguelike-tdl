extends Node2D

export(String, DIR) var level_dir
export(int) var level_depth
export(int, 0, 3) var repeats

var level_height = ProjectSettings.get_setting("display/window/size/height")
var level_width = ProjectSettings.get_setting("display/window/size/width")
var level_paths = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level_paths()
	var level_grid = []
	
	for i in range(level_depth * 2):
		level_grid.append([])
		level_grid[i] = []
		for j in range(level_depth * 2):
			level_grid[i].append([])
			level_grid[i][j] = null
	
	level_grid[level_depth - 1][level_depth -1] = $InitialLevel
	for _r in range(repeats + 1):
		$InitialLevel.attach_level(level_grid, level_paths, level_depth, level_depth - 1, level_depth - 1 , null, null)
	
	for i in range(level_grid.size()):
		for j in range (level_grid.size()):
			var level = level_grid[i][j]
			if level:
				level.global_position.x = j * level_width
				level.global_position.y = i * level_height
	
	$Camera2D.global_position = $level.position


func load_level_paths():
	var dir = Directory.new()
	
	if dir.open(level_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				level_paths.append(dir.get_current_dir() + "/" + file_name)
			file_name = dir.get_next()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
