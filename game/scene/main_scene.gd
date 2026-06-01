extends Node2D

class_name MainScene

@onready var background: Control = $Background
@onready var ideas: Node2D = $Ideas
@onready var enemies: Node2D = $Enemies
@onready var timer: Timer = $Timer
@onready var spawn: Marker2D = $Spawn

@onready var player: Player = Game.player

var overworld_shark: CharacterBody2D

func random_idea_spawn():
	var screen_rect: Rect2 = get_camera_rect()
	for i in range(6):
		var new_idea = Globals.idea.instantiate()
		new_idea.global_position = Vector2(
			randf_range(screen_rect.position.x, screen_rect.end.x),
			randf_range(screen_rect.position.y, screen_rect.end.y)
		)
		
		ideas.add_child(new_idea)

func get_camera_rect() -> Rect2:
	var pos = player.camera.get_target_position()
	var half_size = player.camera.get_viewport_rect().size * 0.5
	return Rect2(pos - half_size, pos + half_size)

func next_phase():
	Game.phase += 1
	timer.stop()
	for enemy in enemies.get_children():
		if enemy is Enemy:
			enemy.die()
		else:
			enemy.queue_free()
	for idea in ideas.get_children():
		idea.die()

	var tween: Tween = create_tween()
	tween.tween_property(player, "rotation", deg_to_rad(180), 1)
	await tween.finished
	
	match Game.phase:
		2:
			player.creation_changed.disconnect(UI.update_bar1)
			player.creation_changed.connect(UI.update_bar2)
			
			await colour_transition(Color(0.45, 0.647, 0.73, 1.0), Color(1.0, 1.0, 1.0, 0.4),)
			
			timer.start()
		3:
			player.creation_changed.disconnect(UI.update_bar2)
			
			await colour_transition(Color(0.082, 0.287, 0.402, 1.0), Color(1.0, 1.0, 1.0, 0))
			
			var shark: Shark = load("res://enemies/Shark.tscn").instantiate()
			enemies.add_child(shark)
			shark.animation.play("intro")
			await shark.animation.animation_finished
			overworld_shark = load("res://enemies/OverworldShark.tscn").instantiate()
			enemies.add_child(overworld_shark)
			overworld_shark.global_position = spawn.global_position
			
			timer.start()

func colour_transition(colour: Color, alpha: Color):
	player.animation.play("descend")
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(background.bg_texture, "self_modulate", colour, 2)
	tween.tween_property(background.sunlight, "self_modulate", alpha, 2)
	await player.animation.animation_finished

func _on_timer_timeout() -> void:
	await random_idea_spawn()
	
	timer.start()

func _on_child_exiting_tree(node: Node) -> void:
	if node.name == "OverworldShark":
		Game.finish_game()
