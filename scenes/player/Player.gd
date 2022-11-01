extends KinematicBody2D

export var max_speed = 500
export var acceleration = 2000
var motion = Vector2.ZERO
var is_attacking = false
var weapon_position = Vector2(19, 20)
var weapon_scale = Vector2(3, 3)
var weapon_rotation = 16.4

# Called when the node enters the scene tree for the first time.
func _ready():
	$WeaponPivot/Weapon.connect("hit_attempt_started", self, "_on_Weapon_hit_attempt_started")
	$WeaponPivot/Weapon.connect("hit_attempt_ended", self, "_on_Weapon_hit_attempt_ended")
	$WeaponPivot/Weapon.position = weapon_position
	$WeaponPivot/Weapon.scale = weapon_scale
	$WeaponPivot/Weapon.rotation_degrees = weapon_rotation

func _physics_process(delta):
	var axis = get_input_axis()
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	$WeaponPivot.rotation = mouse_direction.angle()
	
	if axis == Vector2.ZERO && !self.is_attacking:
		$AnimatedSprite.play("idle")
		apply_friction(acceleration * delta)
	else:
		if !self.is_attacking:
			$AnimatedSprite.play("run")
		apply_movement(axis * acceleration * delta)
	if mouse_direction.x > 0 and $AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = false
		$WeaponPivot.scale.y = -$WeaponPivot.scale.y	
	elif mouse_direction.x < 0 and not $AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = true
		$WeaponPivot.scale.y = -$WeaponPivot.scale.y	
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

func apply_movement(an_ammount_of_acceleration):
	motion += an_ammount_of_acceleration
	motion = motion.limit_length(max_speed)


func _on_Weapon_hit_attempt_started():
	self.is_attacking = true
	$AnimatedSprite.play("hit")
	
func _on_Weapon_hit_attempt_ended():
	self.is_attacking = false
