extends Node2D

export var hit_umbral = 0.5
export(int) var damage = 3 
var elpased_hit_time = 0

signal hit
signal hit_attempt_started
signal hit_attempt_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.elpased_hit_time += delta
	
	if self.elpased_hit_time > hit_umbral and Input.is_action_just_pressed("ui_attack"):
		self.behave_when_hitting()


func behave_when_hitting():
	self.elpased_hit_time = 0
	emit_signal("hit_attempt_started")
	$Pivot/SwordAnimationPlayer.play("SwordAttack")
	$AttackTimer.start()
	$HitBox/CollisionShape2D.disabled = false		


func hit(damage = 1):
	print("Player hit! Damage: ", damage)
	emit_signal("hit",damage)


#func _on_HitBox_body_entered(_body):
#	print("Body entered! Dealt %d points of damage" % damage)
#	if _body.has_method("hit"):
#		_body.hit(damage)
#		emit_signal("hit")


func _on_HitBox_area_entered(area):
	print("Hitbox Area entered! Dealt %d points of damage" % damage)
	if area.owner.has_method("hit"):
		area.owner.hit(damage)
		emit_signal("hit")

func _on_AttackTimer_timeout():
	$HitBox/CollisionShape2D.disabled = true
	emit_signal("hit_attempt_ended")

