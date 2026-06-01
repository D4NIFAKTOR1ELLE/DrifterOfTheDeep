extends CanvasLayer

func _on_start_pressed() -> void:
	Game.start_game()
	
	await UI.transition.fade_out()
	if !UI.control_hint:
		var new_control_hint = Globals.control_hint
		new_control_hint = new_control_hint.instantiate()
		UI.control_hint = new_control_hint
	UI.control_hint.start()
	
	queue_free()
