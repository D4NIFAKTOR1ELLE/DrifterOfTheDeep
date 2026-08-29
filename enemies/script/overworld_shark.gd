extends Enemy

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hitbox = $Hitbox
@onready var timer = $Timer

func _ready():
	set_physics_process(false)
	animation.play("appear")
	await animation.animation_finished
	sprite.play("Idle")
	global_position = player.movement.global_position + Vector2(700, 700)
	player.creation_changed.connect(Game.ui.update_bar3)
	Game.main_scene.overworld_shark = self
	set_physics_process(true)

func take_damage():
	if dying:
		return

	set_physics_process(false)

	health -= 1
	Game.player.creation_changed.emit()

	if health <= 0:
		die()
	else:
		animation.play("hurt")
		await animation.animation_finished
		
		set_physics_process(true)

func die():
	dying = true
	
	sprite.play("Hurt")
	
	var tween: Tween = create_tween().set_loops(4)
	tween.tween_property(sprite, "visible", false, 0.1).from(true)
	tween.tween_interval(0.1)
	await tween.finished
	
	await get_tree().create_timer(1).timeout
	
	var tween2: Tween = create_tween()
	tween2.tween_property(sprite, "self_modulate", Color.TRANSPARENT, 1)
	await tween2.finished
	
	Game.finish_game()
	
	queue_free()

func _physics_process(_delta: float) -> void:
	look_at(player.movement.global_position)
	velocity = position.direction_to(player.movement.global_position) * movement_speed
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.take_damage(1)
