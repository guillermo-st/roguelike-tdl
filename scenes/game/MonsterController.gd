extends Node

signal all_monsters_defeated

onready var wakeup_timer = $MonsterWakeupTimer
onready var remaining_timer = $CheckRemainingTimer


func _on_CheckRemainingTimer_timeout():
	var monsters = get_children()
	var monsters_left = 0
	for monster in monsters:
		if monster.is_in_group("monsters"):
			monsters_left += 1
	
	if monsters_left == 0:
		emit_signal("all_monsters_defeated")

func wake_monsters_up():
	wakeup_timer.start()

func _on_MonsterWakeupTimer_timeout():
	var monsters = get_children()
	for monster in monsters:
		if monster.is_in_group("monsters"):
			monster.wake_up()


