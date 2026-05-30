extends CharacterBody2D

class_name Player

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer

var speed = 300.0
var trajectory = 400
var rotation_speed: float = PI / 1.5

var health: int = 5
var ideas_collected: int = 0
var max_idea_level: int = 5
var creation_count: int = 0

var cooldown: bool = false

signal health_changed
signal idea_changed
@warning_ignore("unused_signal")
signal creation_changed

func _physics_process(delta: float) -> void:
	var rotation_direction = Input.get_axis("left", "right")
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("swim"):
		swim()
	if Input.is_action_just_pressed("create") and ideas_collected >= max_idea_level:
		create()

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

func take_damage(damage: int):
	velocity = Vector2.ZERO
	health = health - damage
	health_changed.emit()
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
	
	ideas_collected = 0
	await Game.main_scene.ui.create_done()
	idea_changed.emit()
	
	sprite.play("CreateInit")
	await sprite.animation_finished
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "rotation", 0, 3)
	
	sprite.play("Create")
	
	await tween.finished
	
	var new_creation = Globals.creation.instantiate()
	Game.main_scene.enemies.add_child(new_creation)
	new_creation.global_position = Game.player.global_position
	
	sprite.play("Idle")
	stop(true)

func stop(enable: bool = false):
	set_physics_process(enable)
	set_process_input(enable)
