extends Node2D

export(String, DIR) var level_dir
export(int) var level_depth

var level_height = ProjectSettings.get_setting("display/window/size/height")
var level_width = ProjectSettings.get_setting("display/window/size/width")

var level_paths = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level_paths()
	$baseLevel.attach_level(level_paths, level_depth, "none", self)

func load_level_paths():
	var dir = Directory.new()
	
	if dir.open(level_dir) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				level_paths.append(dir.get_current_dir() + file_name)
			file_name = dir.get_next()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
