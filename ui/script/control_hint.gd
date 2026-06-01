extends CanvasLayer

func start():
	visible = true
	await Game.get_tree().create_timer(4).timeout
	var tween: Tween = create_tween()
	tween.tween_property($GridContainer, "modulate", Color.TRANSPARENT, 2)
	await tween.finished
	self.queue_free()
