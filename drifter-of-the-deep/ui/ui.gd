extends CanvasLayer

@onready var bar1 = $Container/Bar1
@onready var bar2 = $Container/Bar2
@onready var bar3 = $Container/Bar3

@onready var health_bar: ProgressBar = $Health/ProgressBar
@onready var idea_level: TextureProgressBar = $IdeaLevel
@onready var create_prompt: RichTextLabel = $CreatePrompt

@onready var player: Player = Game.player

@onready var create_prompt_position = create_prompt.global_position

var create_bar_full: bool = false

func _ready() -> void:
	player.health_changed.connect(update_health)
	player.idea_changed.connect(update_idea)

func update_health():
	health_bar.value = player.health

func update_idea():
	idea_level.value = player.ideas_collected
	
	if idea_level.value == idea_level.max_value:
		create_ready()

func create_ready():
	if create_bar_full:
		return
	create_bar_full = true
	create_prompt.set_visible(true)
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(
		create_prompt,
		"self_modulate",
		Color.WHITE,
		0.2).from(Color.TRANSPARENT)

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
		create_prompt_position.y - 20,
		0.5).from(create_prompt_position.y)
	
	await tween.finished
	create_prompt.set_visible(true)
	create_bar_full = false
