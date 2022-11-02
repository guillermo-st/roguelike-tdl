extends "res://scenes/weapon/Weapon.gd"

var weapon_position = Vector2(-35, 10)
var weapon_scale = Vector2(3, 3)
var weapon_rotation = 90


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hit_umbral = 0.4
	self.position = weapon_position
	self.scale = weapon_scale
	self.rotation_degrees = weapon_rotation

func behave_when_hitting():
	self.elpased_hit_time = 0
	emit_signal("hit_attempt_started")
	$Pivot/AnimationPlayer.play("Attack")
	$AttackTimer.start()

func _on_AttackTimer_timeout():
	emit_signal("hit_attempt_ended")
	$Pivot/AnimationPlayer.play("Re")
	
