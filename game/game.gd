extends Node

var player: Player
var time_elapsed: float = 0
var deaths: int = 0
var phase: int = 1

var main_scene: MainScene
var ui: UI

func start_game():
	player = Globals.jelly.instantiate()
	ui = Globals.ui.instantiate()
	main_scene = Globals.main_scene.instantiate()
	ui.player = player
	main_scene.player = player
	
	add_child(ui)
	add_child(main_scene)
	
	ui.initialise()
	main_scene.add_child(player)
	player.global_position = main_scene.spawn.global_position
	set_camera_limits(main_scene.background.bg_texture, player.camera)

func set_camera_limits(map: Control, camera: Camera2D):
	if map == null:
		return
	
	var map_limits: Rect2i = map.get_rect()
	
	camera.set_limit(SIDE_LEFT, map_limits.position.x)
	camera.set_limit(SIDE_RIGHT, map_limits.end.x)
	camera.set_limit(SIDE_TOP, map_limits.position.y)
	camera.set_limit(SIDE_BOTTOM, map_limits.end.y)

func respawn():
	for enemy in main_scene.enemies.get_children():
		if enemy.name != "OverworldShark":
			enemy.queue_free()
	
	ui.create_done()
	player.global_position = main_scene.spawn.global_position
	deaths += 1
	player.ideas_collected = 0
	player.idea_changed.emit()
	player.health = 5
	player.health_changed.emit()

func finish_game():
	player.movement.stop(false)
	ui.queue_free()
	set_process(false)
	Transition.animplayer.play("fade_in_white")
	await Transition.animplayer.animation_finished
	
	await get_tree().create_timer(2).timeout
	
	add_child(Globals.end_screen.instantiate())
	
	main_scene.queue_free()
	
	Transition.animplayer.play("fade_out_white")

func _process(delta: float) -> void:
	time_elapsed += delta
