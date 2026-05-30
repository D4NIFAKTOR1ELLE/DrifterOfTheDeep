extends Node

var phase: int = 1
var player: Player
var main_scene

func start_game():
	player = load("res://game/characters/Jelly.tscn").instantiate()
	main_scene = load("res://game/scene/MainScene.tscn").instantiate()
	
	add_child(main_scene)
	main_scene.add_child(player)
	main_scene.ui.initialise()
	player.global_position = main_scene.get_node("Spawn").global_position
	main_scene.get_node("Spawn").queue_free()
	set_camera_limits(main_scene.background.bg_texture, player.camera)

func set_camera_limits(map: Control, camera: Camera2D):
	if map == null:
		return
	
	var map_limits = map.get_rect()
	
	camera.set_limit(SIDE_LEFT, map_limits.position.x)
	camera.set_limit(SIDE_RIGHT, map_limits.end.x)
	camera.set_limit(SIDE_TOP, map_limits.position.y)
	camera.set_limit(SIDE_BOTTOM, map_limits.end.y)

func respawn():
	for enemy in main_scene.enemies.get_children():
		enemy.queue_free()
	
	player.ideas_collected = 0
	player.idea_changed.emit()
	player.health = 5
	player.health_changed.emit()

func next_phase():
	phase += 1
	for enemy in main_scene.enemies.get_children():
		enemy.queue_free()
	
	match phase:
		2:
			player.creation_changed.disconnect(main_scene.ui.update_bar1)
			player.creation_changed.connect(main_scene.ui.update_bar2)
			var tween: Tween = create_tween()
			tween.tween_property(player, "rotation", deg_to_rad(180), 1)
			await tween.finished
			player.animation.play("descend")
			
			var tween2: Tween = create_tween()
			tween2.tween_property(main_scene.background.bg_texture, "self_modulate", Color.CORNFLOWER_BLUE, 2)
			await player.animation.animation_finished
		3:
			player.creation_changed.disconnect(main_scene.ui.update_bar2)
			player.creation_changed.connect(main_scene.ui.update_bar3)

			var tween: Tween = create_tween()
			tween.tween_property(player, "rotation", deg_to_rad(180), 1)			
			player.animation.play("descend")

			var tween2: Tween = create_tween()
			tween2.tween_property(main_scene.background.bg_texture, "self_modulate", Color.DARK_BLUE, 2)
			await player.animation.animation_finished
		_:
			finish_game()

func finish_game():
	Transition.fade_in()
	
	var new_end: CanvasLayer = Globals.end_screen.instantiate()
	add_child(new_end)
	
	main_scene.queue_free()
	
	Transition.hide()
