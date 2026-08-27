extends CharacterBody2D

@onready var sprite: Node2D = $Sprite

var swim_direction: Vector2 = Vector2.ZERO
var swim_distance_remaining: float = 0.0

var movement_speed: float = 300.0
var trajectory: float = 200
var rotation_speed: float = PI / 1.7

var cooldown: bool = false

func _physics_process(delta: float) -> void:
	if cooldown:
		swim_movement(delta)
	else:
		var rotation_direction: float = Input.get_axis("left", "right")
		rotation += rotation_direction * rotation_speed * delta
	
	move_and_slide()

	if cooldown and get_slide_collision_count() > 0:
		end_swim()

func swim() -> void:
	if cooldown:
		return

	sprite.play("Swim")

	cooldown = true

	swim_direction = Vector2.UP.rotated(rotation)
	swim_distance_remaining = trajectory
	$Sound.play()

func end_swim() -> void:
	cooldown = false
	velocity = Vector2.ZERO
	
	sprite.play("Idle")

func swim_movement(delta: float) -> void:
	var frame_distance: float = min(movement_speed * delta, swim_distance_remaining)
	velocity = swim_direction * movement_speed

	var collider: KinematicCollision2D = move_and_collide(velocity * delta)

	if collider:
		sprite.play("Hurt")
		end_swim()
		return

	swim_distance_remaining -= frame_distance

	if swim_distance_remaining <= 0.0:
		end_swim()

func stop(enable: bool = false) -> void:
	if !Game.main_scene.scene_transition:
		set_physics_process(enable)
		set_process_input(enable)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swim"):
		swim()
	if event.is_action_pressed("j"):
		sprite.modulate = Color.LAWN_GREEN
	if event.is_action_pressed("a"):
		sprite.modulate = Color.BEIGE
	if event.is_action_pressed("c"):
		sprite.modulate = Color.DODGER_BLUE
	if event.is_action_pressed("v"):
		sprite.modulate = Color.DARK_RED
	if event.is_action_pressed("m"):
		sprite.modulate = Color.MEDIUM_PURPLE
