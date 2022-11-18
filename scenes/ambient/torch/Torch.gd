extends Node2D

onready var fire_particles = $Particles2D
onready var light = $Light2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func turn_on():
	fire_particles.emitting = true
	light.enabled = true

func turn_off():
	fire_particles.emitting = false
	light.enabled = false
