extends CharacterBody2D

class_name Enemy

@export var health: int = 3
@export var movement_speed: float = 120.0
@onready var player: Player = Game.player
@onready var sprite: AnimatedSprite2D = $Sprite

var dying: bool = false

func take_damage():
	if dying:
		return

	health = health - 1
	create_tween().tween_property(sprite, "self_modulate", Color.WHITE, 0.3).from(Color(0.631, 0.345, 0.325))

	if health <= 0:
		die()
	else:
		sprite.play("Hurt")

func die():
	dying = true
	
	var tween: Tween = create_tween().set_loops(4)
	tween.tween_property(sprite, "visible", false, 0.1).from(true)
	tween.tween_interval(0.1)
	await tween.finished
	
	queue_free()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Game.player.take_damage(1)
