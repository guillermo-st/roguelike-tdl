extends "res://scenes/actor/monster/Monster.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 80


func decide_animation(movement_axis):
	if movement_axis == Vector2.ZERO:
		sprite.animation = "Idle"
	else:
		sprite.animation = "Run"
		if movement_axis.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true


func process_as_monster(delta):
	if active:
		move_and_slide(velocity)
		sight_check()
		
func _on_axis_changed(axis:Vector2):
	var direction = axis.angle()
	if direction:
		var space_state = get_world_2d().direct_space_state
		var wall_check = space_state.intersect_ray(global_position, global_position + (axis * speed), [self], WALL_COLLISION_LAYER)
		if wall_check:
			axis = -axis
		decide_animation(axis)
	velocity = axis * speed
