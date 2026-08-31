extends Area2D

@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $Collision

@onready var player: Player = Game.player

func _ready() -> void:
	create_tween().tween_property(sprite, "self_modulate", Color.WHITE, 0.2).from(Color.TRANSPARENT)
	
	await get_tree().create_timer(10).timeout
	
	die()

func  _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collect()

func collect() -> void:
	$Sound.play()
	if player.ideas_collected < player.max_idea_level:
		player.ideas_collected += 1
		player.idea_changed.emit()
	
	die()

func die() -> void:
	collision.set_deferred("disabled", true)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 0.3)
	tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 0.3)
	await tween.finished

	queue_free()
