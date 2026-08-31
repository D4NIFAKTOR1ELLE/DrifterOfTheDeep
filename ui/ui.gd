extends CanvasLayer

class_name UI

@onready var bar1: TextureProgressBar = $Container/Bar1
@onready var bar2: TextureProgressBar = $Container/Bar2
@onready var bar3: TextureProgressBar = $Container/Bar3
@onready var objective: RichTextLabel = $Objective

@onready var health_box: TextureRect = $Health
@onready var health_bar: ProgressBar = $Health/ProgressBar
@onready var idea_level: TextureProgressBar = $IdeaLevel
@onready var create_prompt: RichTextLabel = $CreatePrompt

@onready var player: Player

@onready var create_prompt_position: Vector2 = Vector2(488, 395)
@onready var control_hint: CanvasLayer = $ControlHint
@onready var bubble_timer: Timer = $BubbleTimer

var create_bar_full: bool = false
var bubbles: PackedScene = load("res://ui/Bubbles.tscn")

func initialise() -> void:
	player.health_changed.connect(update_health)
	player.idea_changed.connect(update_idea)
	player.creation_changed.connect(update_bar1)
	idea_level.max_value = player.max_idea_level
	bubble_timer.start()

func update_phase_bar(bar: ProgressBar, value: int) -> void:
	bar.value = value
	
	if bar.value >= bar.max_value:
		Game.next_phase()

func update_bar1() -> void:
	bar1.value = player.creation_count
	
	if player.creation_count >= bar1.max_value:
		ui_next_phase("\n[[color=yellow]H[/color]] [color=yellow]HEAL[/color]", "[[color=yellow]OBJECTIVE[/color]] CREATE 5 DRAWINGS.", bar1)

func update_bar2() -> void:
	bar2.value = player.creation_count
	
	if player.creation_count >= bar2.max_value:
		ui_next_phase("\n[[color=yellow]A[/color]] [color=yellow]ATTACK[/color]", "[[color=yellow]OBJECTIVE[/color]] GET RID OF YOUR ART BLOCK.", bar2)

func update_bar3() -> void:
	bar3.value = Game.main_scene.overworld_shark.health

func ui_next_phase(create_prompt_text: String, objective_text: String, bar: TextureProgressBar) -> void:
	create_tween().tween_property(bar, "self_modulate", Color(1.0, 1.0, 1.0, 0.396), 0.5)
	create_tween().tween_property(objective, "self_modulate", Color.TRANSPARENT, 0.3)
	await Game.main_scene.next_phase()
	create_prompt.append_text(create_prompt_text)
	objective.text = objective_text
	player.creation_count = 0
	create_tween().tween_property(objective, "self_modulate", Color.WHITE, 0.7)

func update_health() -> void:
	health_box.modulate = Color.WHITE
	
	health_bar.value = player.health
	
	create_tween().tween_property(health_box, "modulate", Color.TRANSPARENT, 1.5).from(Color.WHITE)
 
func update_idea():
	idea_level.value = player.ideas_collected
	
	if idea_level.value == player.max_idea_level:
		create_ready()

func create_ready() -> void:
	if create_bar_full:
		return
	create_bar_full = true
	create_prompt.set_visible(true)
	create_tween().set_parallel(true).tween_property(create_prompt, "self_modulate", Color.WHITE, 0.2).from(Color.TRANSPARENT)

func create_done() -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(create_prompt, "self_modulate", Color.TRANSPARENT, 0.5).from(Color.WHITE)
	
	await tween.finished
	create_prompt.set_visible(true)
	create_bar_full = false

func action_done(specifier: String) -> void:
	player.get_node("Sound2").play()
	if specifier != "heal":
		create_tween().tween_property(idea_level, "value", 0, 3.5).from(idea_level.max_value)
	player.ideas_collected = 0
	await create_done()
	update_idea()

func _on_bubble_timer_timeout() -> void:
	bubble_timer.stop()
	bubble_timer.wait_time = randi_range(4, 7)
	var bubbles_instance: AnimatedSprite2D = bubbles.instantiate()
	var viewport_rect: Rect2 = player.get_viewport_rect()
	
	bubbles_instance.global_position = Vector2(
		randf_range(0, viewport_rect.end.x),
		randf_range(0, viewport_rect.end.y)
	)

	add_child(bubbles_instance)
	bubble_timer.start()
