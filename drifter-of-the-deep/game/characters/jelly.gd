extends Node2D

class_name Player

func get_camera_rect() -> Rect2:
	var pos = $Jelly/Camera2D.get_target_position()
	var half_size = $Jelly/Camera2D.get_viewport_rect().size * 0.5
	return Rect2(pos - half_size, pos + half_size)
