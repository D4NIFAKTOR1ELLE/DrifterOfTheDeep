extends CharacterBody2D

class_name Player

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer

var movement_speed = 300.0
var trajectory = 200
var rotation_speed: float = PI / 1.7

const max_health: int = 5
var health: int = 5

var ideas_collected: int = 0
var max_idea_level: int = 4

var creation_count: int = 0

var cooldown: bool = false

var swim_direction := Vector2.ZERO
var swim_distance_remaining := 0.0

signal health_changed
signal creation_changed
signal idea_changed

func _physics_process(delta: float) -> void:
	if cooldown:
		swim_movement(delta)
	else:
		var rotation_direction = Input.get_axis("left", "right")
		rotation += rotation_direction * rotation_speed * delta
	
	move_and_slide()

	if cooldown and get_slide_collision_count() > 0:
		end_swim()

func end_swim() -> void:
	cooldown = false
	velocity = Vector2.ZERO
	
	sprite.play("Idle")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("swim"):
		swim()
	if Input.is_action_just_pressed("create") and ideas_collected >= max_idea_level:
		create()
	if Input.is_action_just_pressed("heal"):
		heal()
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("reload"):
		await die()
		Game.deaths = Game.deaths - 1
		sprite.modulate = Color.WHITE
	if Input.is_action_just_pressed("j"):
		sprite.modulate = Color.LAWN_GREEN
	if Input.is_action_just_pressed("a"):
		sprite.modulate = Color.MEDIUM_PURPLE
	if Input.is_action_just_pressed("c"):
		sprite.modulate = Color.DODGER_BLUE
	if Input.is_action_just_pressed("v"):
		sprite.modulate = Color.DARK_RED

func heal():
	if Game.phase < 2 or UI.create_bar_full == false:
		return
	
	await UI.action_done()
	
	health = min(max_health, health + 1)
	health_changed.emit()
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 1.5).from(Color(0, 5, 0, 1))

func attack():
	if Game.phase < 3 or UI.create_bar_full == false:
		return
	
	stop(false)
	
	await UI.action_done()
	
	animation.play("attack")
	await animation.animation_finished

	stop(true)

func swim():
	if cooldown:
		return

	sprite.play("Swim")

	cooldown = true

	swim_direction = Vector2.UP.rotated(rotation)
	swim_distance_remaining = trajectory
	$Sound.play()

func swim_movement(delta: float) -> void:
	var frame_distance = movement_speed * delta

	frame_distance = min(frame_distance, swim_distance_remaining)

	velocity = swim_direction * movement_speed

	var collision = move_and_collide(velocity * delta)

	if collision:
		sprite.play("Hurt")
		end_swim()
		return

	swim_distance_remaining -= frame_distance

	if swim_distance_remaining <= 0.0:
		end_swim()

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
	UI.transition.fade_in()
	await UI.transition.animplayer.animation_finished

	await Game.respawn()

	stop(true)
	UI.transition.fade_out()

func create():
	end_swim()
	stop(false)
	
	await UI.action_done()
	
	sprite.play("CreateInit")
	await sprite.animation_finished
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "rotation", 0, 3)
	
	sprite.play("Create")
	
	await tween.finished
	
	var new_creation = Globals.creation.instantiate()
	Game.main_scene.enemies.add_child(new_creation)
	
	sprite.play("Idle")
	stop(true)

func stop(enable: bool = false):
	set_physics_process(enable)
	set_process_input(enable)

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage()
