extends Enemy

@onready var player: Player = Game.player

func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
	velocity = position.direction_to(player.global_position) * movement_speed
	move_and_slide()

func _on_hitbox_body_entered(_body: Node2D) -> void:
	player.take_damage(1)
