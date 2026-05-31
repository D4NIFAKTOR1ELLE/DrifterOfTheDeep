extends CharacterBody2D

class_name GoodFish

func _ready():
	var tween2: Tween = create_tween()
	tween2.tween_property($Sprite, "self_modulate", Color.TRANSPARENT, 5)
	await tween2.finished
	queue_free()
