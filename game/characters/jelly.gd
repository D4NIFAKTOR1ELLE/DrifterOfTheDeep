extends CharacterBody2D

class_name Player

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $Collision

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
@warning_ignore("unused_signal")
signal creation_changed
@warning_ignore("unused_signal")
signal idea_changed

func _physics_process(delta: float) -> void:
	if cooldown:
		swim_movement(delta)
	else:
		var rotation_direction: float = Input.get_axis("left", "right")
		rotation += rotation_direction * rotation_speed * delta
	
	move_and_slide()

	if cooldown and get_slide_collision_count() > 0:
		end_swim()

func end_swim() -> void:
	cooldown = false
	velocity = Vector2.ZERO
	
	sprite.play("Idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swim"):
		swim()
	if event.is_action_pressed("create") and ideas_collected >= max_idea_level:
		create()
	if event.is_action_pressed("heal"):
		heal()
	if event.is_action_pressed("attack"):
		attack()
	if event.is_action_pressed("reload"):
		await die()
		Game.deaths = Game.deaths - 1
		sprite.modulate = Color.WHITE
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

func heal() -> void:
	if Game.phase < 2 or UI.create_bar_full == false:
		return
	
	await UI.action_done("heal")
	
	health = min(max_health, health + 1)
	health_changed.emit()
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 1.5).from(Color(0, 5, 0, 1))

func attack() -> void:
	if Game.phase < 3 or UI.create_bar_full == false:
		return
	
	collision.set_deferred("disabled", true)
	
	stop(false)
	
	await UI.action_done("attack")
	
	animation.play("attack")
	await animation.animation_finished

	collision.set_deferred("disabled", false)

	stop(true)

func swim() -> void:
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

	var collider = move_and_collide(velocity * delta)

	if collider:
		sprite.play("Hurt")
		end_swim()
		return

	swim_distance_remaining -= frame_distance

	if swim_distance_remaining <= 0.0:
		end_swim()

func take_damage(damage: int) -> void:
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

func die() -> void:
	stop(false)
	UI.transition.fade_in()
	await UI.transition.animplayer.animation_finished

	await Game.respawn()

	stop(true)
	UI.transition.fade_out()

func create() -> void:
	end_swim()
	stop(false)
	
	await UI.action_done("create")
	
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

func iframes():
	pass

func stop(enable: bool = false) -> void:
	if !Game.main_scene.scene_transition:
		set_physics_process(enable)
		set_process_input(enable)

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage()
