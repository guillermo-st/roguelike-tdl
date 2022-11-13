extends Area2D

export var speed = 200
export var damage = 2
var rotation_direction
var velocity
var explosion_particles = preload("res://scenes/particles/Explosion.tscn")
var is_moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(1, 0).rotated(rotation_direction);

func _physics_process(delta):
	if is_moving:
		global_position += (velocity.normalized() * delta * speed)


func explode():
	is_moving = false
	$Fire.emitting = false
	var explotion = explosion_particles.instance()
	explotion.emitting = true
	get_parent().add_child(explotion)
	explotion.global_position = self.global_position
	queue_free()


func _on_FireBall_body_entered(body):
	explode()
	

func _on_FireBall_area_entered(area):
	area.owner.take_damage(damage)
	explode()
