extends Node

func stop(enable: bool = false):
	set_physics_process(enable)
	set_process_input(enable)
