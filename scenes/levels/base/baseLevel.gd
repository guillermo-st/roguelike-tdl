extends Node2D


onready var rng = RandomNumberGenerator.new()
const directions = ["up", "left", "down", "right"]
var attached_levels = {}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

# Attaches a random level, chosen from level_paths, to one of this level's free cardinal directions.
# Then it tells that instance to attach_level() too, with a decremented remaining_depth.
# If the level was fully attached to begin with, then it calls attach_level() on one of the levels that isn't the caller
# and without decrementing remaining_depth.
func attach_level(level_paths, remaining_depth, from_dir, from_level):
	attached_levels[from_dir] = from_level
	if remaining_depth == 0:
		return
	
	var next_dir = get_next_dir([from_dir])
	if self.is_fully_attached():
		attached_levels[next_dir].attach_level(level_paths, remaining_depth, get_opposite_dir(next_dir), self)
		return
	
	var next_level_index = rng.randi_range(0, level_paths.size() - 1)
	var next_level_path = load(level_paths[next_level_index])
	var next_level = next_level_path.instance()
	get_parent().add_child(next_level)
	
	attached_levels[next_dir] = next_level
	print("Attaching level " + level_paths[next_level_index] + " at direction " + next_dir)
	next_level.attach_level(level_paths, remaining_depth - 1, get_opposite_dir(next_dir), self)
	
# Returns wheter this level is attached to other 4 levels in all of its directions or not.
func is_fully_attached():
	return attached_levels.has("up") and attached_levels.has("down") and attached_levels.has("right") and attached_levels.has("left")

# Returns the random next free direction that is not present in the 'excluded' array parameter.
func get_next_dir(excluded=Array()):
	var possible_dirs = directions.duplicate()
	for dir in excluded:
			possible_dirs.erase(dir)
	
	var next_dir_index = rng.randi_range(0, possible_dirs.size() - 1)
	return possible_dirs[next_dir_index]

func get_opposite_dir(dir):
	if dir == "up":
		return "down"
	elif dir == "right":
		return "left"
	elif dir == "down":
		return "up"
	elif dir == "left":
		return "right"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
