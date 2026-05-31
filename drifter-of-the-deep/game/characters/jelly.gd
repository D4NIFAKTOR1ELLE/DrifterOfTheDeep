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
var max_idea_level: int = 5

var creation_count: int = 0

var cooldown: bool = false

var swim_direction := Vector2.ZERO
var swim_distance_remaining := 0.0

signal health_changed
signal idea_changed
@warning_ignore("unused_signal")
signal creation_changed

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

func heal():
	if Game.phase < 2 or Game.main_scene.ui.create_bar_full == false:
		return
	
	await action_done()
	
	health = min(max_health, health + 1)
	health_changed.emit()
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 1.5).from(Color(0, 1, 0, 5))

func attack():
	#if Game.phase < 3 or Game.main_scene.ui.create_bar_full == false:
		#return
	
	stop(false)
	
	await action_done()
	
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
	Transition.fade_in()
	await Transition.animplayer.animation_finished

	await Game.respawn()

	stop(true)
	Transition.fade_out()

func create():
	end_swim()
	stop(false)
	
	await action_done()
	
	sprite.play("CreateInit")
	await sprite.animation_finished
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "rotation", 0, 3)
	
	sprite.play("Create")
	
	await tween.finished
	
	var new_creation = Globals.creation.instantiate()
	Game.main_scene.enemies.add_child(new_creation)
	new_creation.global_position = Game.player.global_position + Vector2(0, 50)
	
	sprite.play("Idle")
	stop(true)

#func invincibility_frames(duration: float = 0.8):
	#animation.play("iframe")
	#
	#await Game.get_tree().create_timer(duration).timeout
	#
	#extra.play("RESET")
	#invulnerable = false

func action_done():
	ideas_collected = 0
	await Game.main_scene.ui.create_done()
	idea_changed.emit()

func stop(enable: bool = false):
	set_physics_process(enable)
	set_process_input(enable)

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage()
