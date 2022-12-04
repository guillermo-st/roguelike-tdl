extends Node2D

export var lit = false
onready var fire_particles = $Particles2D
onready var light = $Light2D
onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if lit:
		turn_on()
	else:
		turn_off()

func turn_on():
	audio.play()
	lit = true
	fire_particles.emitting = true
	light.enabled = true

func turn_off():
	lit = false
	fire_particles.emitting = false
	light.enabled = false


func _on_Area2D_area_entered(area):
	turn_on()
