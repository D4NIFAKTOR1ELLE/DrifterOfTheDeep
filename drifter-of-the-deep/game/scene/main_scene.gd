extends TileMapLayer

class_name MainScene

@onready var background: CanvasLayer = $Background
@onready var ui: CanvasLayer = $UI

@onready var ideas: Node2D = $Ideas
@onready var enemies: Node = $Enemies

@onready var player: Player = Game.player

func random_idea_spawn():
	var screen_rect: Rect2 = get_camera_rect()
	for i in range(5):
		var new_idea = Globals.idea.instantiate()
		new_idea.global_position = Vector2(
			randf_range(screen_rect.position.x, screen_rect.end.x),
			randf_range(screen_rect.position.y, screen_rect.end.y)
		)
		
		ideas.add_child(new_idea)

func get_camera_rect() -> Rect2:
	var pos = $Jelly/Camera2D.get_target_position()
	var half_size = $Jelly/Camera2D.get_viewport_rect().size * 0.5
	return Rect2(pos - half_size, pos + half_size)

func _on_timer_timeout() -> void:
	await random_idea_spawn()
	
	$Timer.start()
