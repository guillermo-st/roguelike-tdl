extends "res://scenes/weapon/Weapon.gd"

export var damage = 3
var weapon_position = Vector2(4, 5)
var weapon_rotation = 16.4
onready var audio = $AudioStreamPlayer

		

func _ready():
	self.position = weapon_position
	self.rotation_degrees = weapon_rotation
	
	
#func _on_Area2D_body_entered(_body):
#	print("take_damage")
#	emit_signal("take_damage")
	
	
func _on_HitBox_area_entered(area):
	if area.owner and area.owner.is_in_group('monsters'):
		area.owner.take_damage(damage)


func behave_when_hitting():
	self.elapsed_hit_time = 0
	emit_signal("hit_attempt_started")
	$Pivot/SwordAnimationPlayer.play("SwordAttack")
	$AttackTimer.start()
	audio.play()
	$HitBox/CollisionShape2D.disabled = false	
	

func _on_AttackTimer_timeout():
	$HitBox/CollisionShape2D.disabled = true
	emit_signal("hit_attempt_ended")
