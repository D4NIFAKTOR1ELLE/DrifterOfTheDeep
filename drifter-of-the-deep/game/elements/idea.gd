extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect()

func collect():
	pass
