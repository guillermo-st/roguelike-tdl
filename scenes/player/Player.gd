extends KinematicBody2D

signal take_damage(damage)
signal heal(heal_amount)

export var max_speed = 500
export var acceleration = 1000
export var health = 12

var push_velocity:Vector2 = Vector2()
var motion = Vector2.ZERO
var is_attacking = false
var is_hit = false

var sword = preload("res://scenes/weapon/Sword/Sword.tscn")
var staff = preload("res://scenes/weapon/staff/Staff.tscn")
var weapons = [sword, staff]
enum {SWORD_INDEX, STAFF_INDEX}
var selected_weapon_index = SWORD_INDEX
var can_switch_weapon = true
var can_move = true

onready var blood = $Blood

onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$WeaponPivot.add_child(weapons[selected_weapon_index].instance())
	$WeaponPivot/Weapon.connect("hit_attempt_started", self, "_on_Weapon_hit_attempt_started")
	$WeaponPivot/Weapon.connect("hit_attempt_ended", self, "_on_Weapon_hit_attempt_ended")


func _physics_process(delta):
	if can_move:
		var axis = get_input_axis()
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		$WeaponPivot.rotation = mouse_direction.angle()
	
		if self.can_change_weapon():
			self.change_weapon()	
		
		self.behave_according_to_input(axis, delta)
		self.look_towards_mouse(mouse_direction)
		push_velocity = push_velocity.linear_interpolate(Vector2.ZERO,0.1)
		motion = move_and_slide((motion+push_velocity).floor())

func get_input_axis():
	var axis = Vector2.ZERO
	if !self.is_hit:	
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

func take_damage(damage = 1):
	if !is_hit:
		is_hit = true
		$HitTimer.start()
		$AnimationPlayer.play("damage")
		audio.play()
		emit_signal("take_damage",damage)
		health -= 1
		if health == 0:
			die()

func die():
	can_move = false
	$Collider.set_deferred("disabled", true)
	$WeaponPivot.call_deferred("queue_free")
	$LightOccluder2D.call_deferred("queue_free")
	$AnimatedSprite.play("die")
	blood.emitting = true

func heal(heal_amount):
	emit_signal("heal", heal_amount)
	health += heal_amount
	
	
func push(from,force):
	push_velocity = (global_position-from).normalized()*force
	$PushTimer.start()


func _on_Weapon_hit_attempt_ended():
	self.is_attacking = false

	
func get_next_weapon_index(previous_weapon_index):
	var new_weapon_index = previous_weapon_index + 1
	if previous_weapon_index == len(weapons) - 1:
		new_weapon_index = 0
	return new_weapon_index


func can_change_weapon():
	return Input.is_action_just_released("ui_weapon_switch") and self.can_switch_weapon
	

func change_weapon():
	can_switch_weapon = false
	$WeaponSwitchTimer.start()
	var previous_weapon = $WeaponPivot/Weapon
	$WeaponPivot.remove_child(previous_weapon)
	previous_weapon.queue_free()
	selected_weapon_index = get_next_weapon_index(selected_weapon_index)
	$WeaponPivot.add_child(weapons[selected_weapon_index].instance())
	$WeaponPivot/Weapon.connect("hit_attempt_started", self, "_on_Weapon_hit_attempt_started")
	$WeaponPivot/Weapon.connect("hit_attempt_ended", self, "_on_Weapon_hit_attempt_ended")
	
	
func is_idle(input_axis):
	return input_axis == Vector2.ZERO && !self.is_attacking


func behave_according_to_input(input_axis, delta):
	if self.is_idle(input_axis):
		$AnimatedSprite.play("idle")
		apply_friction(acceleration * delta)
	else:
		if !self.is_attacking:
			$AnimatedSprite.play("run")
		apply_movement(input_axis * acceleration * delta)
		

func look_towards_mouse(mouse_direction):
	if mouse_direction.x > 0 and $AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = false
		$WeaponPivot.scale.y = -$WeaponPivot.scale.y	
	elif mouse_direction.x < 0 and not $AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = true
		$WeaponPivot.scale.y = -$WeaponPivot.scale.y


func _on_WeaponSwitchTimer_timeout():
	self.can_switch_weapon = true


func _on_PushTimer_timeout():
	push_velocity = Vector2()


func _on_HitTimer_timeout():
	is_hit = false
