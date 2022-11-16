extends Node

signal all_monsters_defeated

onready var wakeup_timer = $MonsterWakeupTimer
var monsters_left = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var monsters = get_children()
	for monster in monsters:
		if monster.is_in_group("monsters"):
			monsters_left += 1
			monster.connect("monster_died", self, "decrease_monsters_left")

func decrease_monsters_left():
	monsters_left -= 1
	if monsters_left == 0:
		emit_signal("all_monsters_defeated")
		self.queue_free()

func wake_monsters_up():
	wakeup_timer.start()

func _on_MonsterWakeupTimer_timeout():
	var monsters = get_children()
	for monster in monsters:
		if monster.is_in_group("monsters"):
			monster.active = true
