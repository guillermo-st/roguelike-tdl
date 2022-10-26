extends Node2D

export var hit_umbral = 0.25
var elpased_hit_time = 0
var is_flipped = false

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
	var rotation_factor = 1
	if self.is_flipped:
		rotation_factor = -1
	emit_signal("hit_attempt_started")
	$Pivot.rotate(0.6 * PI * rotation_factor)
		
	var timer = Timer.new()
	timer.set_wait_time(0.1)
	timer.set_one_shot(true)
		
	self.add_child(timer)
	timer.start()
	$Area2D/CollisionShape2D.disabled = false		
	yield(timer, "timeout")
		
	$Area2D/CollisionShape2D.disabled = true
	$Pivot.rotate(-0.6 * PI * rotation_factor)
	timer.queue_free()
	emit_signal("hit_attempt_ended")
	

func flip_horizontally():
	self.is_flipped = !self.is_flipped
	self.position.x = -self.position.x
	$Area2D/CollisionShape2D.position.x = -$Area2D/CollisionShape2D.position.x
	$Pivot/Sprite.flip_h = self.position.x < 0
	$Pivot/Sprite.rotation = -$Pivot/Sprite.rotation

func _on_Area2D_body_entered(_body):
	print("HIT")
	emit_signal("hit")
