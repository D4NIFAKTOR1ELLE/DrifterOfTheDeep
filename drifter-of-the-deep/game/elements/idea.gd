extends Area2D

@onready var sprite = $Sprite
@onready var collision: CollisionShape2D = $Collision

@onready var player: Player = Game.player

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collect()

func collect():
	if player.ideas_collected < player.max_idea_level:
		player.ideas_collected += 1
		player.idea_changed.emit()
	
	await die()
	queue_free()

func die():
	collision.set_deferred("disabled", true)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.3)
	await tween.finished

func _on_self_destruct_timer_timeout() -> void:
	await die()
	queue_free()
