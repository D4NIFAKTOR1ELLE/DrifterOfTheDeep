extends Node

var phase: int = 1
var player: Player
var main_scene: MainScene
var time_elapsed: float = 0
var deaths = 0

func start_game():
	player = load("res://game/characters/Jelly.tscn").instantiate()
	main_scene = load("res://game/scene/MainScene.tscn").instantiate()
	
	add_child(main_scene)
	main_scene.add_child(player)
	main_scene.ui.initialise()
	player.global_position = main_scene.get_node("Spawn").global_position
	main_scene.get_node("Spawn").queue_free()
	set_camera_limits(main_scene.background.bg_texture, player.camera)
	
	Transition.animplayer.play("fade_out")

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
	
	deaths += 1
	player.ideas_collected = 0
	player.idea_changed.emit()
	player.health = 5
	player.health_changed.emit()

func next_phase():
	phase += 1
	for enemy in main_scene.enemies.get_children():
		if enemy is Enemy:
			enemy.die()
		else:
			enemy.queue_free()
	for idea in main_scene.ideas.get_children():
		idea.die()

	var tween: Tween = create_tween()
	tween.tween_property(player, "rotation", deg_to_rad(180), 1)
	await tween.finished
	player.animation.play("descend")
	
	match phase:
		2:
			player.creation_changed.disconnect(main_scene.ui.update_bar1)
			player.creation_changed.connect(main_scene.ui.update_bar2)
			
			var tween2: Tween = create_tween()
			tween2.tween_property(main_scene.background.bg_texture, "self_modulate", Color(0.291, 0.459, 0.528, 1.0), 2)
			await player.animation.animation_finished
		3:
			player.creation_changed.disconnect(main_scene.ui.update_bar2)

			var tween2: Tween = create_tween()
			tween2.tween_property(main_scene.background.bg_texture, "self_modulate", Color(0.082, 0.287, 0.402, 1.0), 2)
			await player.animation.animation_finished
			
			var shark: Shark = load("res://enemies/Shark.tscn").instantiate()
			main_scene.add_child(shark)
			shark.animation.play("intro")
			await shark.animation.animation_finished
			main_scene.overworld_shark = load("res://enemies/OverworldShark.tscn").instantiate()
			main_scene.add_child(main_scene.overworld_shark)
			main_scene.overworld_shark.global_position = player.global_position + Vector2(700, 700)

func finish_game():
	set_physics_process(false)
	Transition.fade_in()
	await Transition.animplayer.animation_finished
	
	var new_end: CanvasLayer = Globals.end_screen.instantiate()
	add_child(new_end)
	
	main_scene.queue_free()
	
	Transition.hide()

func _physics_process(delta: float) -> void:
	time_elapsed += delta
