extends Control

@onready var bg_texture: TextureRect = $BG
@onready var sunlight: TextureRect = $Sunlight

func colour_transition(player: Player, colour: Color, alpha: Color):
	player.animation.play("descend")
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(bg_texture, "self_modulate", colour, 2)
	tween.tween_property(sunlight, "self_modulate", alpha, 2)
	await player.animation.animation_finished
