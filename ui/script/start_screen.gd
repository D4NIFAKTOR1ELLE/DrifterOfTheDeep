extends CanvasLayer

func _on_start_pressed() -> void:
	Game.start_game()
	
	await UI.transition.fade_out()
	UI.control_hint.start()
	
	queue_free()
