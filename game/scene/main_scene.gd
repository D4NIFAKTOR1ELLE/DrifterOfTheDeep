extends Node2D

class_name MainScene

@onready var background: Control = $Background
@onready var ideas: Node = $Ideas
@onready var enemies: Node = $Enemies
@onready var idea_spawn_timer: Timer = $IdeaSpawnTimer
@onready var spawn: Marker2D = $Spawn

@onready var player: Player = Game.player

var bounding_rectangle: Rect2 = Rect2(Vector2(200, 200), Vector2(5906, 3726))

var overworld_shark: CharacterBody2D
var scene_transition: bool = false

func next_phase() -> void:
	player.movement.stop(false)
	scene_transition = true
	Game.phase += 1
	idea_spawn_timer.stop()
	kill_entities()
	
	var tween: Tween = create_tween()
	tween.tween_property(player.movement, "rotation", deg_to_rad(180), 1)
	await tween.finished
	
	match Game.phase:
		2:
			player.creation_changed.disconnect(Game.ui.update_bar1)
			player.creation_changed.connect(Game.ui.update_bar2)
			
			await background.colour_transition(player, Color(0.45, 0.647, 0.73, 1.0), Color(1.0, 1.0, 1.0, 0.4),)
			
			idea_spawn_timer.start()
		3:
			player.creation_changed.disconnect(Game.ui.update_bar2)
			
			await background.colour_transition(player, Color(0.112, 0.358, 0.496), Color(1.0, 1.0, 1.0, 0))
			
			create_tween().tween_property(Game.ui.bar3, "value", Game.ui.bar3.max_value, 3)
			
			var shark: Shark = Globals.shark.instantiate()
			enemies.add_child(shark)
			await shark.animation.animation_finished
			overworld_shark = load("res://enemies/OverworldShark.tscn").instantiate()
			enemies.add_child(overworld_shark)
			idea_spawn_timer.start(true)
	
	scene_transition = false
	player.movement.stop(true)

func kill_entities() -> void:
	for fish: Node2D in enemies.get_children():
		if fish is Enemy:
			fish.die()
		else:
			fish.queue_free()
	for idea: Area2D in ideas.get_children():
		idea.die()

func _on_idea_spawn_timer_timeout() -> void:
	random_idea_spawn()

func random_idea_spawn() -> void:
	idea_spawn_timer.stop()
	for i: int in range(6):
		var new_idea: Area2D = Globals.idea.instantiate()
		new_idea.position = Vector2(
			randf_range(bounding_rectangle.position.x, bounding_rectangle.size.x),
			randf_range(bounding_rectangle.position.y, bounding_rectangle.size.y)
		)
		
		ideas.add_child(new_idea)
	
	idea_spawn_timer.start()
