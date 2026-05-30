extends CanvasLayer

@onready var bar1 = $Container/Bar1
@onready var bar2 = $Container/Bar2
@onready var bar3 = $Container/Bar3

@onready var health_bar: ProgressBar = $Health/ProgressBar
@onready var idea_level: TextureProgressBar = $IdeaLevel
@onready var create_prompt: RichTextLabel = $CreatePrompt

@onready var player = Game.player

@onready var create_prompt_position = create_prompt.global_position

func _ready() -> void:
	pass

func update_health():
	health_bar.value = player.current_health

func create_ready():
	create_prompt.set_visible(true)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(
		create_prompt,
		"self_modulate",
		Color.TRANSPARENT,
		0.5).from(Color.WHITE)

func create_done():
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(
		create_prompt,
		"self_modulate",
		Color.TRANSPARENT,
		0.5).from(Color.WHITE)
	tween.tween_property(
		create_prompt,
		"global_position:y",
		-40,
		0.5).from(create_prompt_position.y)
	
	await tween.finished
	create_prompt.set_visible(true)
