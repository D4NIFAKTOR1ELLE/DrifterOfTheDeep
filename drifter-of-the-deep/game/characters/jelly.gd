extends CharacterBody2D

class_name Player

@onready var ray: RayCast2D = $RayCast2D
@onready var camera: Camera2D = $Camera2D

var speed = 300.0
var trajectory = 400
var rotation_speed: float = PI / 1.5
var health: int = 5
var ideas_collected: int = 0

var cooldown: bool = false

func _physics_process(delta: float) -> void:
	var rotation_direction = Input.get_axis("left", "right")
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("swim"):
		swim()

func swim():
	if cooldown:
		return

	cooldown = true

	var forward: Vector2 = Vector2.RIGHT.rotated(rotation)
	var distance: float = trajectory

	var target_position = global_position + forward * distance

	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.6)

	await tween.finished

	cooldown = false

func get_camera_rect() -> Rect2:
	var pos = camera.get_target_position()
	var half_size = camera.get_viewport_rect().size * 0.5
	return Rect2(pos - half_size, pos + half_size)
