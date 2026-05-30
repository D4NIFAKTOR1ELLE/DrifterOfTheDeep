extends TileMapLayer

@onready var background = $Background
@onready var player = Game.player
@onready var ideas = $Ideas
@onready var ui = $UI

func random_idea_spawn():
	var screen_rect: Rect2 = get_camera_rect()
	for i in range(5):
		var new_idea = Globals.idea.instantiate()
		new_idea.global_position = Vector2(
			randf_range(screen_rect.position.x, screen_rect.position.y),
			randf_range(screen_rect.end.x, screen_rect.end.y)
		)
		
		ideas.add_child(new_idea)

func get_camera_rect() -> Rect2:
	var pos = $Jelly/Camera2D.get_target_position()
	var half_size = $Jelly/Camera2D.get_viewport_rect().size * 0.5
	return Rect2(pos - half_size, pos + half_size)

func _on_timer_timeout() -> void:
	await random_idea_spawn()
	
	$Timer.start()
