extends Node2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	Game.player.creation_count += 1
	Game.player.creation_changed.emit()
	
	global_position = Game.player.global_position
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position:y", global_position.y - 150, 0.7)
	await tween.finished
	
	var rand = randf_range(0, 1)
	
	if rand < 0.3:
		normal_creation()
	else:
		bad_creation()

func normal_creation():
	animation.play("normal_creation")
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color(1, 1, 1, 5), 1)
	await animation.animation_finished
	
	var new_fish = Globals.normal_creations.pick_random()
	new_fish = new_fish.instantiate()
	Game.main_scene.enemies.add_child(new_fish)
	new_fish.global_position = sprite.global_position

	var tween2: Tween = create_tween()
	tween2.tween_property(new_fish, "modulate", Color.WHITE, 1).from(Color(1, 1, 1, 5))
	queue_free()

func bad_creation():
	animation.play("bad_creation")
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color(1, 1, 1, 5), 1)
	await animation.animation_finished
	
	var new_fish = Globals.bad_creations.pick_random()
	new_fish = new_fish.instantiate()
	Game.main_scene.enemies.add_child(new_fish)
	new_fish.global_position = sprite.global_position

	var tween2: Tween = create_tween()
	tween2.tween_property(new_fish, "modulate", Color.WHITE, 1).from(Color(1, 1, 1, 5))
	queue_free()
