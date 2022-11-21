extends KinematicBody2D

signal monster_died

export var speed = 40
var velocity = Vector2.ZERO
var target
var target_in_sight = false
var WALL_COLLISION_LAYER = 128
var active = false
var score_value = 10

onready var hud = get_tree().get_root().get_node("GameController/Hud")
onready var life_bar:TextureProgress = $Pivot/LifeBar
onready var tween:Tween = $Tween
onready var sprite = $Pivot/Sprite
onready var start_pos = global_position

func take_damage(damage):
	life_bar.value -= damage
	hit_fx()
	if !life_bar.value:
		death()


func _physics_process(delta):
	if active:
		if target and target_in_sight:
			move_towards_target()
		move_and_slide(velocity)
		sight_check()

func hit_fx():
	tween.interpolate_property(sprite,"scale",Vector2(2,2),Vector2.ONE,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.interpolate_property(sprite,"modulate",Color(50,50,50),Color.white,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$SndHit.play()
	tween.start()


func death():
	$AreaHitBox.monitoring = false
	emit_signal("monster_died")
	tween.interpolate_property(sprite,"scale",Vector2(2,2),Vector2.ZERO,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	
	remove_child(tween)
	sprite.add_child(tween)
	$Pivot.remove_child(sprite)
	get_parent().add_child(sprite)
	sprite.global_position = $Pivot.global_position
	tween.start()
	queue_free()
	hud.update_score(score_value)


func _on_axis_changed(axis:Vector2):
	if not target_in_sight:
		var direction = axis.angle()
		if direction:
			sprite.playing = true
			decide_animation(axis)
		else:
			sprite.playing = false
		velocity = axis*speed
	

func _on_AreaHitBox_body_entered(body):
	body.take_damage()
	body.push(global_position,75)

func _on_Sight_body_entered(body):
	target = body

func _on_Sight_body_exited(body):
	target = null
	target_in_sight = false


func sight_check():
	if target:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(global_position, target.position, [self], WALL_COLLISION_LAYER)
		target_in_sight = not sight_check
		


func move_towards_target():
	sprite.playing = true
	var target_axis = (target.global_position - self.global_position).normalized()
	decide_animation(target_axis)
	velocity =  target_axis * speed


func decide_animation(movement_axis):
	if abs(movement_axis.x) > abs(movement_axis.y):
		if movement_axis.x > 0:
			sprite.animation = "Right"
		else:
			sprite.animation = "Left"
	else:
		if movement_axis.y > 0:
			sprite.animation = "Down"
		else:
			sprite.animation = "Up"
