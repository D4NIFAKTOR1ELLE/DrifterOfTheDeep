extends CanvasLayer

func _on_start_pressed() -> void:
	Game.start_game()
	
	Transition.fade_out()
	
	queue_free()
