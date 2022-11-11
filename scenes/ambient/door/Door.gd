extends Node2D

signal player_entered_door

var should_position_player
var is_open
var is_sealed

# Called when the node enters the scene tree for the first time.
func _ready():
	should_position_player = true
	$Sprite.modulate.a = 0
	is_open = true
	is_sealed = false


func close():
	if is_open and not is_sealed:
		$DoorLock.global_position = self.global_position
		$Tween.interpolate_property($Sprite, "global_position", $OpenPosition.global_position, self.global_position, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT )
		$Tween.start()
		should_position_player = false
		is_open = false

func open():
	if not is_open and not is_sealed:
		$DoorLock.global_position = $OpenPosition.position
		$Tween.interpolate_property($Sprite, "global_position", self.global_position, $OpenPosition.global_position, 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_EXPO, Tween.EASE_IN_OUT )
		$Tween.start()
		is_open = true

func seal():
	is_sealed = true
	$Sprite.modulate = Color(0.3, 0.3, 0.3, 1)
	$Sprite.global_position = self.global_position
	$DoorLock.global_position = self.global_position
	$EnterArea.monitoring = false

func _on_EnterArea_body_entered(body):
	if should_position_player:
		body.global_position = $EnterPosition.global_position
	emit_signal("player_entered_door")
