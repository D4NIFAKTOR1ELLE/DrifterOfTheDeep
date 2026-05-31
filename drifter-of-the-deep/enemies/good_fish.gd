extends CharacterBody2D

class_name GoodFish

func _ready():
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position:x", global_position.x - 700, 15)
	await tween.finished
	
	var tween2: Tween = create_tween()
	tween2.tween_property($Sprite, "self_modulate", Color.TRANSPARENT, 2)
	await tween2.finished
	queue_free()
