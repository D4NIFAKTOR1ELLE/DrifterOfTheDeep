extends Node2D

class_name Player

@onready var camera: Camera2D = $Jelly/Camera2D
@onready var sprite: AnimatedSprite2D = $Jelly/Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var movement: CharacterBody2D = $Jelly

const max_health: int = 5
var health: int = 5
var ideas_collected: int = 0
var max_idea_level: int = 4
var creation_count: int = 0

var invulnerable: bool = false

signal health_changed
@warning_ignore("unused_signal")
signal creation_changed
@warning_ignore("unused_signal")
signal idea_changed

func _input(event: InputEvent) -> void:
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

func heal() -> void:
	if Game.phase < 2 or Game.ui.create_bar_full == false:
		return
	
	await Game.ui.action_done("heal")
	
	health = min(max_health, health + 1)
	health_changed.emit()
	create_tween().tween_property(sprite, "self_modulate", Color.WHITE, 1.5).from(Color(0, 5, 0, 1))

func attack() -> void:
	if Game.phase < 3 or Game.ui.create_bar_full == false:
		return
	
	movement.stop(false)
	
	await Game.ui.action_done("attack")
	
	animation.play("attack")
	await animation.animation_finished
	
	invulnerable = true

func take_damage(damage: int) -> void:
	if invulnerable:
		return
	
	movement.velocity = Vector2.ZERO
	health = health - damage
	health_changed.emit()
	create_tween().tween_property(sprite, "self_modulate", Color.WHITE, 0.3).from(Color(0.631, 0.345, 0.325))

	if health <= 0:
		die()
	else:
		sprite.play("Hurt")

func die() -> void:
	movement.stop(false)
	Transition.fade_in()
	await Transition.animplayer.animation_finished

	await Game.respawn()

	movement.stop(true)
	Transition.fade_out()

func create() -> void:
	movement.end_swim()
	movement.stop(false)
	
	await Game.ui.action_done("create")
	
	sprite.play("CreateInit")
	await sprite.animation_finished
	
	var tween: Tween = create_tween()
	tween.tween_property(movement, "rotation", 0, 3)
	
	sprite.play("Create")
	
	await tween.finished
	
	var new_creation: Node2D = Globals.creation.instantiate()
	Game.main_scene.enemies.add_child(new_creation)
	
	sprite.play("Idle")
	movement.stop(true)

func _on_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage()
