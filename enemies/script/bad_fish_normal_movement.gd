extends Enemy

@onready var player: Player = Game.player

func _physics_process(_delta: float) -> void:
	look_at(player.movement.global_position)
	velocity = position.direction_to(player.movement.global_position) * movement_speed
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.take_damage(1)
