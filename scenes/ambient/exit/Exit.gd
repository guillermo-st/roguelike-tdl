extends Area2D

onready var sprite = $AnimatedSprite


func _ready():
	sprite.play("closed")

func open():
	sprite.play("open")
	var lock = get_node_or_null("Lock")
	if lock:
		lock.queue_free()

func _on_Exit_body_entered(_body):
	SignalBus.emit_signal("zone_exited")
