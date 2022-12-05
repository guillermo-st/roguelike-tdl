extends Node2D


var can_attack = true
var fireballScene = preload("res://scenes/actor/monsterAttacks/EnemyFireBall/EnemyFireBall.tscn")
onready var parent = get_parent()
onready var root = get_tree().get_root()
onready var fireSpawners = [$FireSpawner, $FireSpawner2, $FireSpawner3, $FireSpawner4, $FireSpawner5, $FireSpawner6, $FireSpawner7, $FireSpawner8]
onready var audio = $AttackAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_attack and parent.active:
		$AttackTimer.start()
		can_attack = false
		audio.play()
		for fireSpawner in fireSpawners:
			var fireball = fireballScene.instance()
			fireball.rotation_direction = fireSpawner.rotation
			fireball.global_position = fireSpawner.global_position
			root.add_child(fireball)


func _on_AttackTimer_timeout():
	rotate_spawners()
	can_attack = true

func rotate_spawners():
	for fireSpawner in fireSpawners:
		fireSpawner.rotate(PI / 8)
