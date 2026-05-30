extends TileMapLayer

@onready var background = $Background
@onready var player = Game.player
@onready var ideas = $Ideas

func random_idea_spawn():
	var screen_rect: Rect2 = player.get_camera_rect()
	for i in range(5):
		var new_idea = Globals.idea.instantiate()
		new_idea.global_position = Vector2(
			randf_range(screen_rect.position.x, screen_rect.position.y),
			randf_range(screen_rect.end.x, screen_rect.end.y)
		)
		
		ideas.add_child(new_idea)

func _on_timer_timeout() -> void:
	await random_idea_spawn()
	
	$Timer.start()
