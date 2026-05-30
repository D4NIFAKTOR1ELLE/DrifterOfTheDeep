extends Node

var phase: int = 1
var player: Player
var main_scene

func start_game():
	player = Globals.jelly.instantiate()
	main_scene = Globals.main_scene.instantiate()
	
	add_child(main_scene)
	main_scene.add_child(player)
	player.global_position = main_scene.get_node("Spawn").global_position

func respawn():
	pass

func finish_game():
	pass
