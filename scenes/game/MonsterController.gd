extends Node

signal all_monsters_defeated

var monsters_left 

# Called when the node enters the scene tree for the first time.
func _ready():
	var monsters = get_children()
	monsters_left = monsters.size()
	for monster in monsters:
		monster.connect("monster_died", self, "decrease_monsters_left")

func decrease_monsters_left():
	monsters_left -= 1
	if monsters_left == 0:
		emit_signal("all_monsters_defeated")
		self.queue_free()

func wake_monsters_up():
	var monsters = get_children()
	for monster in monsters:
		if monster.is_in_group("monsters"):
			monster.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
