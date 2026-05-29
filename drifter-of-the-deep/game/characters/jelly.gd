extends CharacterBody2D

class_name Player

var speed = 300.0
var trajectory = 400
var rotation_speed: float = 1.5
var health: int = 5

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
