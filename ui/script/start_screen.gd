extends CanvasLayer

@onready var timer: Timer = $BG/Timer

var jelly_position: Vector2
var paper_position: Vector2

func _ready():
	jelly_position = $BG/Jelly.position
	paper_position = $BG/Paper.position
	$BG/Options/Start.grab_focus()
	
	start_tweeners()

func start_tweeners() -> void:
	var tween: Tween = create_tween().set_loops().set_parallel(false)
	tween.tween_property($BG/Jelly, "position", jelly_position - Vector2(0, 1), 2)
	tween.tween_property($BG/Jelly, "position", jelly_position + Vector2(0, 1), 2)
	var tween2: Tween = create_tween().set_loops().set_parallel(false)
	tween2.tween_property($BG/Paper, "position", paper_position - Vector2(0, 5), 3)
	tween2.tween_property($BG/Paper, "position", paper_position + Vector2(0, 5), 3)

func _on_start_pressed() -> void:
	Game.start_game()
	
	await Transition.fade_out()
	
	queue_free()

func _on_timer_timeout() -> void:
	timer.stop()
	var bubble: AnimatedSprite2D = $BG.get_node("Bubble%s" % randi_range(1, 3))
	bubble.frame = 0
	bubble.play("Default")
	await get_tree().create_timer(randi_range(0, 3)).timeout
	timer.start()
