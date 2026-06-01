extends CanvasLayer

var completion_time

@onready var return_to_start: Button = $BG/ReturnToStart
@onready var grid_container: GridContainer = $BG/GridContainer
@onready var title: RichTextLabel = $BG/Title
@onready var completion: Label = $BG/GridContainer/CompletionTime
@onready var deaths: Label = $BG/GridContainer/Deaths

func _ready() -> void:
	set_process_input(false)

	return_to_start.hide()
	for element in grid_container.get_children():
		element.hide()
	
	completion_time = Game.time_elapsed
	
	await get_tree().create_timer(2).timeout

	title.show()

	completion.text = _format_seconds(completion_time)
	deaths.text = "%d" % Game.deaths
	
	await get_tree().create_timer(2).timeout
	
	reveal()

func _format_seconds(time: float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func reveal():
	for element in grid_container.get_children():
		element.show()
	
		await get_tree().create_timer(1).timeout
		
	await get_tree().create_timer(1).timeout
	return_to_start.show()
	set_process_input(true)

func _on_return_to_start_pressed() -> void:
	UI.transition.fade_in()
	var new_start: CanvasLayer = Globals.start_screen.instantiate()
	Game.add_child(new_start)
	
	UI.transition.fade_out()
	
	queue_free()
