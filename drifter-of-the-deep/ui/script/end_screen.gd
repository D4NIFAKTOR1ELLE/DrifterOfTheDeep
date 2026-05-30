extends CanvasLayer

var completion_time
var ornaments_collected

func _ready() -> void:
	set_process_input(false)

	$BG/Title.hide()
	$BG/QuitMessage.hide()
	$BG/ReturnToStart.hide()
	for element in $BG/GridContainer.get_children():
		element.hide()
	
	#completion_time = Globals.game.time_elapsed
	#ornaments_collected = Globals.game.ornaments_collected
	
	await get_tree().create_timer(2).timeout

	$BG/Title.show()

	$GridContainer/CompletionTime.text = _format_seconds(completion_time)
	#$GridContainer/Deaths.text = "%d" % Globals.game.deaths
	
	await get_tree().create_timer(2).timeout
	
	reveal()

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func reveal():
	for element in $BG/GridContainer.get_children():
		element.show()
	
		await get_tree().create_timer(1).timeout
		
	await get_tree().create_timer(1).timeout
	$BG/QuitMessage.show()
	$BG/ReturnToStart.show()
	set_process_input(true)

func _on_return_to_start_pressed() -> void:
	var new_start: CanvasLayer = Globals.start_screen.instantiate()
	Game.add_child(new_start)
	
	queue_free()
