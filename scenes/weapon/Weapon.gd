extends Node2D

export var hit_umbral = 0.5
var elapsed_hit_time = 1

signal take_damage
signal hit_attempt_started
signal hit_attempt_ended

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.elapsed_hit_time += delta
	
	if self.elapsed_hit_time > hit_umbral and Input.is_action_just_pressed("ui_attack"):
		self.behave_when_hitting()


func behave_when_hitting():
	pass

