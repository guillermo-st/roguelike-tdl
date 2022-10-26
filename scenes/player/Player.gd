extends KinematicBody2D

export var max_speed = 500
export var acceleration = 2000
var motion = Vector2.ZERO
var is_attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var axis = get_input_axis()
	
	if axis == Vector2.ZERO && !self.is_attacking:
		$AnimatedSprite.play("idle")
		apply_friction(acceleration * delta)
	else:
		if !self.is_attacking:
			$AnimatedSprite.play("run")		
		if axis.x < 0 and $Weapon.position.x > 0:
			$AnimatedSprite.flip_h = true
			$Weapon.flip_horizontally()
			$Weapon.rotation = -$Weapon.rotation			
		elif axis.x > 0 and $Weapon.position.x < 0:
			$AnimatedSprite.flip_h = false
			$Weapon.flip_horizontally()
			$Weapon.rotation = -$Weapon.rotation
		apply_movement(axis * acceleration * delta)
	motion = move_and_slide(motion)

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()
	

func apply_friction(an_amount_of_friction):
	if motion.length() > an_amount_of_friction:
		motion -= motion.normalized() * an_amount_of_friction
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(max_speed)




func _on_Weapon_hit_attempt_started():
	self.is_attacking = true
	$AnimatedSprite.play("hit")
	


func _on_Weapon_hit_attempt_ended():
	self.is_attacking = false
