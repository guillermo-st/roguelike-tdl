extends CanvasLayer

signal start_game
signal game_over
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$GameOverMessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the GameOverMessageTimer has counted down.
	yield($GameOverMessageTimer, "timeout")
	$GameOverMessageTimer.stop()
	emit_signal("game_over")

func _on_PlayButton_pressed():
	$PlayButton.hide()
	$Message.hide()
	emit_signal("start_game")


func _on_GameOverMessageTimer_timeout():
	$Message.hide()
