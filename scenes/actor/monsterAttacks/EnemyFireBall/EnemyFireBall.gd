extends Area2D

export var speed = 200
var velocity
var rotation_direction
var is_moving = true
var enemy_explotion_scene = preload("res://scenes/particles/EnemyExplosion.tscn")

func _ready():
	velocity = Vector2(1, 0).rotated(rotation_direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_moving:
		global_position += (velocity.normalized() * delta * speed)


func _on_EnemyFireBall_body_entered(body):
	if body.is_in_group('player'):
		body.take_damage(1)
	explode()


func _on_EnemyFireBall_area_entered(area):
	explode()

func explode():
	is_moving = false
	$EnemyFire.emitting = false
	var explotion = enemy_explotion_scene.instance()
	explotion.emitting = true
	get_parent().add_child(explotion)
	explotion.global_position = self.global_position
	queue_free()
