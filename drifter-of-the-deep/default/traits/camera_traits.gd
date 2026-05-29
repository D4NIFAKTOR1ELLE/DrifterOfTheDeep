extends Node

func set_camera_limits(map: Control, camera: Camera2D):
	if map == null:
		return
	
	var map_limits = map.get_rect()
	
	camera.set_limit(SIDE_LEFT, map_limits.position.x)
	camera.set_limit(SIDE_RIGHT, map_limits.end.x)
	camera.set_limit(SIDE_TOP, map_limits.position.y)
	camera.set_limit(SIDE_BOTTOM, map_limits.end.y)

## USAGE
#if Input.is_action_just_pressed("right_click"):
#	save_to()
func save_to(viewport: SubViewport, background_limit: ColorRect):
	viewport.world_2d = get_tree().root.get_world_2d()
	viewport.size = Vector2(
		background_limit.size.x,
		background_limit.size.y)
	
	await RenderingServer.frame_post_draw
	
	var vt = viewport.get_texture()
	var img = vt.get_image()
	return img.save_png("res://default/trashcan/Screenshot.png")
## The SubViewport needs to be attached to the level root node
## The BG limit is for the rect encompassing everything
