extends KinematicBody2D

signal monster_died

export var speed = 40
var velocity = Vector2.ZERO
var target
var target_in_sight = false
var WALL_COLLISION_LAYER = 128
var active = false

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


func _on_axis_changed(axis:Vector2):
	var direction = axis.angle()
	if direction:
		sprite.playing = true
		if abs(axis.x) > abs(axis.y):
			if axis.x > 0:
				sprite.animation = "Right"
#				sprite.rotation = direction
			else:
				sprite.animation = "Left"
#				sprite.rotation = direction - PI
		else:
			if axis.y > 0:
				sprite.animation = "Down"
#				sprite.rotation = direction - PI/2
			else:
				sprite.animation = "Up"
#				sprite.rotation = direction + PI/2
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

func sight_check():
	if target:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, target.position, [self], WALL_COLLISION_LAYER)
		if sight_check:
			target_in_sight = false
		else:
			target_in_sight = true
