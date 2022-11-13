extends KinematicBody2D

signal revive

export var speed = 40
var disabled = false setget set_disabled
var velocity = Vector2.ZERO
var target
var target_in_sight = false
var WALL_COLLISION_LAYER = 128

onready var life_bar:TextureProgress = $Pivot/LifeBar
onready var tween:Tween = $Tween
onready var sprite = $Pivot/Sprite
onready var start_pos = global_position

func hit(damage):
	life_bar.value -= damage
	hit_fx()
	if !life_bar.value:
		death()


func _physics_process(delta):
	move_and_slide(velocity)
	sight_check()


func revive():
	if disabled:
		emit_signal("revive")
		life_bar.value = life_bar.max_value
		global_position = start_pos
		sprite.scale = Vector2.ONE
		self.disabled = false


func set_disabled(v):
	disabled = v
	visible = !v
	if disabled:
		_on_axis_changed(Vector2.ZERO)
	$Shape.set_deferred("disabled",v)
	$AreaHitBox/Shape.set_deferred("disabled",v)
	$Sight/CollisionShape2D.set_deferred("disabled", v)


func hit_fx():
	tween.interpolate_property(sprite,"scale",Vector2(2,2),Vector2.ONE,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.interpolate_property(sprite,"modulate",Color(50,50,50),Color.white,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$SndHit.play()
	tween.start()


func death():
	tween.interpolate_property(sprite,"scale",Vector2(2,2),Vector2.ZERO,0.2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.start()
	yield(tween,"tween_all_completed")
	self.disabled = true


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
	body.hit()
	body.push(global_position,150)


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
