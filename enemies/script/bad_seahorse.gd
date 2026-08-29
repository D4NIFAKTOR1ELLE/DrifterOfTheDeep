extends Enemy

@onready var dash_timer: Timer = $DashTimer

var direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = direction.normalized() * movement_speed
	
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	direction = position.direction_to(player.movement.global_position)
	
	set_physics_process(false)
	await get_tree().create_timer(2).timeout
	set_physics_process(true)
	
	var dir: Vector2 = (player.movement.global_position - global_position).normalized()

	if dir.x > 0:
		sprite.set_flip_h(false)
	else:
		sprite.set_flip_h(true)
