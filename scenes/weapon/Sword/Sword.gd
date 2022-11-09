extends "res://scenes/weapon/Weapon.gd"

var weapon_position = Vector2(19, 20)
var weapon_scale = Vector2(3, 3)
var weapon_rotation = 16.4

		

func _ready():
	self.position = weapon_position
	self.scale = weapon_scale
	self.rotation_degrees = weapon_rotation
	
	
func _on_Area2D_body_entered(_body):
	print("HIT")
	emit_signal("hit")


func behave_when_hitting():
	self.elpased_hit_time = 0
	emit_signal("hit_attempt_started")
	$Pivot/SwordAnimationPlayer.play("SwordAttack")
	$AttackTimer.start()
	$Area2D/CollisionShape2D.disabled = false	
	
func _on_AttackTimer_timeout():
	$Area2D/CollisionShape2D.disabled = true
	emit_signal("hit_attempt_ended")
