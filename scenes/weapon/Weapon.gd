extends Node2D

export var hit_umbral = 0.5
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
	$Area2D/CollisionShape2D.disabled = false		


func _on_Area2D_body_entered(_body):
	print("HIT")
	emit_signal("hit")


func _on_AttackTimer_timeout():
	$Area2D/CollisionShape2D.disabled = true
	emit_signal("hit_attempt_ended")

