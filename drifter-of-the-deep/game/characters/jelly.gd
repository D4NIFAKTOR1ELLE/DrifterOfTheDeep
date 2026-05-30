extends CharacterBody2D

class_name Player

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $Sprite

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

	sprite.play("Swim")

	cooldown = true

	var forward: Vector2 = Vector2.UP.rotated(rotation)
	var distance: float = trajectory

	var target_position = global_position + forward * distance

	var tween: Tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "global_position", target_position, 0.6)
	
	await tween.finished

	sprite.play("Idle")

	cooldown = false

func take_damage():
	var tween: Tween = create_tween()
	tween.tween_property(sprite,
		"self_modulate",
		Color.WHITE, 0.3).from(Color(0.631, 0.345, 0.325))

	if health <= 0:
		die()
	else:
		sprite.play("Hurt")

func die():
	stop(false)
	Transition.fade_in()
	await Transition.animplayer.animation_finished

	await Game.respawn()

	stop(true)
	Transition.fade_out()

func create():
	stop(false)
	
	sprite.play("CreateInit")
	await sprite.animation_finished
	
	sprite.play("Create")
	await get_tree().create_timer(1).timeout
	
	sprite.play("Idle")
	
	stop(true)

func stop(enable: bool = false):
	set_physics_process(enable)
	set_process_input(enable)
