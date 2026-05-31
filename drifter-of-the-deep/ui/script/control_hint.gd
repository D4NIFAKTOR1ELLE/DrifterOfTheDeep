extends CanvasLayer

## UI HINT!
## All UI elements are visible by default, they should be manually hidden when instantiated in another scene

func _ready():
	await get_tree().create_timer(3).timeout
	var tween: Tween = create_tween()
	tween.tween_property($GridContainer, "modulate", Color.TRANSPARENT, 2)
	await tween.finished
	self.queue_free()
