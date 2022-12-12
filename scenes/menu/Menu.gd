extends CanvasLayer

signal start_game
signal game_over
signal quit

onready var menu_music = $MenuMusic
	
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
	$QuitButton.hide()
	menu_music.stop()
	emit_signal("start_game")


func _on_GameOverMessageTimer_timeout():
	$Message.hide()


func _on_QuitButton_pressed():
	emit_signal("quit")
