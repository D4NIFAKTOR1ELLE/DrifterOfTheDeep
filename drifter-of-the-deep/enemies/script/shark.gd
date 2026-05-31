extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer

@export var health: int = 5

var dying: bool = false

func intro():
	animation.play("intro")
