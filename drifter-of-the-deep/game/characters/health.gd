extends TextureRect

@onready var jelly = get_node("../Jelly")

var vector = Vector2(-60, -65)

func _process(delta: float) -> void:
	global_position = jelly.global_position + vector
