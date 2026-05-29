extends Area2D

@onready var sprite = $Sprite
@onready var collision: CollisionShape2D = $Collision

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect()

func collect():
	collision.set_deferred("disabled", true)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.3)
	await tween.finished
	
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
