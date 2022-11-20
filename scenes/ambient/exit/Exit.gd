extends Area2D

onready var sprite = $AnimatedSprite
onready var lock = $Lock


func _ready():
	sprite.play("closed")

func open():
	sprite.play("open")
	lock.queue_free()

func _on_Exit_body_entered(_body):
	SignalBus.emit_signal("zone_exited")