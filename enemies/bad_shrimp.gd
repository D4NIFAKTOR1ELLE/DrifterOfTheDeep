extends Enemy

func _physics_process(_delta: float) -> void:
	velocity = position.direction_to(player.movement.global_position) * movement_speed
	move_and_slide()
