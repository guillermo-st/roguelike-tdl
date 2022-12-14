extends Area2D

onready var sprite = $AnimatedSprite
onready var audio = $AudioStreamPlayer

func _ready():
	sprite.play("closed")

func open():
	audio.play()
	sprite.play("open")
	var lock = get_node_or_null("Lock")
	if lock:
		lock.queue_free()

func _on_Exit_body_entered(_body):
	$CollisionShape2D.set_deferred("monitoring", false)
	SignalBus.emit_signal("zone_exited")
