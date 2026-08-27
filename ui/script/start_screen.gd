extends CanvasLayer

func _ready():
	$BG/Options/Start.grab_focus()

func _on_start_pressed() -> void:
	Game.start_game()
	
	await Transition.fade_out()
	
	queue_free()
