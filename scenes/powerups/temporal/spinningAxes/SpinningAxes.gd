extends Node2D

var speed = 2.5


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotation += delta * speed


func _on_Area2D_body_entered(body):
	body.take_damage(1)


func _on_Timer_timeout():
	queue_free()
