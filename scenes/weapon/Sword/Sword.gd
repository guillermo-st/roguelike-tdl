extends "res://scenes/weapon/Weapon.gd"

var weapon_position = Vector2(19, 20)
var weapon_scale = Vector2(3, 3)
var weapon_rotation = 16.4


func _ready():
	self.position = weapon_position
	self.scale = weapon_scale
	self.rotation_degrees = weapon_rotation
