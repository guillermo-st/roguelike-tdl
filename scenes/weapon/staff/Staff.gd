extends "res://scenes/weapon/Weapon.gd"

var weapon_position = Vector2(-35, 0)
var weapon_scale = Vector2(3, 3)
var weapon_rotation = -270
var particles = preload("res://scenes/weapon/staff/fireball/FireBall.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hit_umbral = 0.4
	self.position = weapon_position
	self.scale = weapon_scale
	self.rotation_degrees = weapon_rotation

func behave_when_hitting():
	self.elpased_hit_time = 0
	self.shoot_fireball()
	emit_signal("hit_attempt_started")
	$Pivot/AnimationPlayer.play("Attack")
	$AttackTimer.start()
	

func _on_AttackTimer_timeout():	
	emit_signal("hit_attempt_ended")
	

func shoot_fireball():
	var fireball = particles.instance()
	fireball.rotation_direction = self.get_parent().rotation
	fireball.position = $ShootSpawner.get_global_position()
	fireball.rotation = self.get_parent().rotation + PI / 2
	get_tree().get_root().add_child(fireball)
