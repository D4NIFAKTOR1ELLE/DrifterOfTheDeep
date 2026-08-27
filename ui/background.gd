extends Control

@onready var bg_texture: TextureRect = $BG
@onready var sunlight: TextureRect = $Sunlight
@onready var parallax_back: TextureRect = $Parallax/ParallaxBack
@onready var parallax_middle: TextureRect = $Parallax2/ParallaxMiddle
@onready var parallax_front: TextureRect = $Parallax3/ParallaxFront

func colour_transition(player: Player, colour: Color, alpha: Color):
	player.animation.play("descend")
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(bg_texture, "self_modulate", colour, 2)
	tween.tween_property(parallax_back, "self_modulate", colour, 2)
	tween.tween_property(parallax_middle, "self_modulate", colour, 2)
	tween.tween_property(parallax_front, "self_modulate", colour, 2)
	tween.tween_property(sunlight, "self_modulate", alpha, 2)
	await player.animation.animation_finished
