extends "res://scenes/actor/monster/Monster.gd"

var directions = [Vector2(1, -1), Vector2(-1, -1), Vector2(-1, 1), Vector2(1, 1)]

onready var slime_path = load(filename)
onready var rng = RandomNumberGenerator.new()
onready var anim = $Pivot/Sprite

#determines how many times the slime will split before finally dying for good.
export var splits = 2
#determines how many slimes are spawned on death.
export var slime_birth_count = 2

var current_dir = Vector2(0, 0)

func _ready():
	rng.randomize()

func wake_up():
	.wake_up()
	current_dir = get_random_dir(false)

# gets a random direction for the slime. if should_remove = true, also pops it 
# from the list of possible dirs
func get_random_dir(should_remove):
	var dir_index = rng.randi_range(0, directions.size() - 1)
	var dir = directions[dir_index]
	if should_remove:
		directions.erase(dir)
	return dir

func process_as_monster(delta):
	decide_animation(current_dir)
	if active:
		var collision = move_and_collide(current_dir * speed * delta)
		if collision:
			current_dir = current_dir.bounce(collision.normal)
	

func decide_animation(current_dir):
	if not active:
		anim.play("idle")
	else:
		anim.play("run")
		if current_dir.x >= 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
		

func death():
	if splits > 0:
		create_children_slime(slime_birth_count)
	.death()

#TODO: also decrease the child's health. We need to decouple health from lifebar first.
# creates children slime and sets their parameters. slime_count should be <= 4
func create_children_slime(slime_count):
	var children = Array()
	while slime_count > 0:
		var child = slime_path.instance()
		child.splits = self.splits - 1
		child.scale = self.scale * 0.5
		child.speed = self.speed * 1.5
		children.append(child)
		slime_count -= 1
	call_deferred("spawn_children_slime", children)


func spawn_children_slime(children):
	for child in children:
		get_parent().add_child(child)
		child.global_position = global_position
		child.wake_up()
		child.current_dir = get_random_dir(true)
	
