extends Node

var player: Player
var main_scene: MainScene
var time_elapsed: float = 0
var deaths = 0
var phase = 1

func start_game():
	player = load("res://game/characters/Jelly.tscn").instantiate()
	main_scene = load("res://game/scene/MainScene.tscn").instantiate()
	
	add_child(main_scene)
	main_scene.add_child(player)
	player.global_position = main_scene.spawn.global_position
	set_camera_limits(main_scene.background.bg_texture, player.camera)
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
		enemy.queue_free()
	
	player.global_position = main_scene.spawn.global_position
	deaths += 1
	player.ideas_collected = 0
	player.idea_changed.emit()
	player.health = 5
	player.health_changed.emit()

func finish_game():
	set_physics_process(false)
	UI.transition.fade_in()
	await UI.transition.animplayer.animation_finished
	
	var new_end: CanvasLayer = Globals.end_screen.instantiate()
	add_child(new_end)
	
	main_scene.queue_free()
	
	UI.transition.hide()

func _physics_process(delta: float) -> void:
	time_elapsed += delta
