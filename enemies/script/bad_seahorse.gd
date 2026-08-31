extends Enemy

@onready var dash_timer: Timer = $DashTimer

var direction: Vector2 = Vector2.ZERO
var movement_type: String = "normal_movement"
var callable: Callable = Callable(self, movement_type)

func _physics_process(delta: float) -> void:
	callable.call(delta)

func normal_movement(_delta: float) -> void:
	velocity = direction.normalized() * movement_speed
	
	move_and_slide()

func dash_movement(_delta: float) -> void:
	velocity = Vector2.DOWN * 30
	
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	movement_type = "dash_movement" if movement_type == "normal_movement" else "normal_movement"
	callable = Callable(self, movement_type)
	
	match movement_type:
		"normal_movement":
			sprite.play("Idle")
			direction = position.direction_to(player.movement.global_position)
			var dir: Vector2 = (player.movement.global_position - global_position).normalized()

			if dir.x > 0:
				sprite.set_flip_h(false)
			else:
				sprite.set_flip_h(true)
			
			dash_timer.set_wait_time(2)
			dash_timer.start()
		"dash_movement":
			sprite.play("Drop")
			direction = Vector2.ZERO
			
			dash_timer.set_wait_time(3)
			dash_timer.start()
