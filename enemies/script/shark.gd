extends Node2D

class_name Shark

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var player: Player = Game.player

func _ready() -> void:
	global_position = player.movement.global_position
	animation.play("intro")
	await animation.animation_finished
