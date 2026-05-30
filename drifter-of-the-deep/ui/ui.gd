extends CanvasLayer

class_name UI

@onready var bar1 = $Container/Bar1
@onready var bar2 = $Container/Bar2
@onready var bar3 = $Container/Bar3

@onready var health_bar: ProgressBar = $Health/ProgressBar
@onready var idea_level: TextureProgressBar = $IdeaLevel
@onready var create_prompt: RichTextLabel = $CreatePrompt

@onready var player: Player = Game.player

@onready var create_prompt_position: Vector2 = Vector2(488, 385)

var create_bar_full: bool = false

func initialise() -> void:
	player.health_changed.connect(update_health)
	player.idea_changed.connect(update_idea)
	player.creation_changed.connect(update_bar1)

func update_phase_bar(bar: ProgressBar, value: int):
	bar.value = value
	
	if bar.value >= bar.max_value:
		Game.next_phase()

func update_bar1():
	bar1.value = player.creation_count
	
	if player.creation_count >= bar1.max_value:
		Game.next_phase()

func update_bar2():
	bar2.value = player.creation_count
	
	if player.creation_count >= bar2.max_value:
		Game.next_phase()

func update_bar3():
	bar3.value = player.creation_count
	
	if player.creation_count >= bar3.max_value:
		Game.next_phase()

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
