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

func respawn():
	for enemy in main_scene.enemies.get_children():
		enemy.queue_free()
	
	player.ideas_collected = 0
	player.idea_changed.emit()
	player.health = 5
	player.health_changed.emit()

func next_phase():
	phase += 1
	
	match phase:
		2:
			main_scene.ui.disconnect()
			player.animation.play("descend")
			await player.animation.animation_finished
		3:
			player.animation.play("descend")
			await player.animation.animation_finished
		_:
			finish_game()

func finish_game():
	Transition.fade_in()
	
	var new_end: CanvasLayer = Globals.end_screen.instantiate()
	add_child(new_end)
	
	main_scene.queue_free()
	
	Transition.hide()
