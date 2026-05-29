extends CanvasLayer

func _on_start_pressed() -> void:
	Game.start_game()
	
	#Transition.show()
	
	queue_free()
