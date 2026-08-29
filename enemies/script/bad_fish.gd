extends Enemy

func _physics_process(_delta: float) -> void:
	look_at(player.movement.global_position)
	velocity = position.direction_to(player.movement.global_position) * movement_speed
	move_and_slide()
