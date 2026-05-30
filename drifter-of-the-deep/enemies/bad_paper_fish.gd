extends Enemy

@onready var player = Game.player

func _physics_process(delta: float) -> void:
	look_at(player)
	velocity = position.direction_to(player.movement.position) * movement_speed
	move_and_slide()
