extends Node

var player: Player
var main_scene: MainScene
var time_elapsed: float = 0
var deaths = 0
var phase = 1

func start_game():
	UI.visible = true
	player = Globals.jelly.instantiate()
	main_scene = Globals.main_scene.instantiate()
	
	add_child(main_scene)
	main_scene.add_child(player)
	player.global_position = main_scene.spawn.global_position
	set_camera_limits(main_scene.background.bg_texture, player.camera)
	
	Game.phase = 2
	main_scene.next_phase()
	
	UI.initialise()

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
		if enemy.name != "OverworldShark":
			enemy.queue_free()
	
	player.global_position = main_scene.spawn.global_position
	deaths += 1
	player.ideas_collected = 0
	player.idea_changed.emit()
	player.health = 5
	player.health_changed.emit()

func finish_game():
	UI.visible = false
	set_physics_process(false)
	UI.transition.fade_in()
	await UI.transition.animplayer.animation_finished
	
	await get_tree().create_timer(2).timeout
	
	var new_end: CanvasLayer = Globals.end_screen.instantiate()
	add_child(new_end)
	
	main_scene.queue_free()
	
	UI.transition.hide()

func _physics_process(delta: float) -> void:
	time_elapsed += delta
