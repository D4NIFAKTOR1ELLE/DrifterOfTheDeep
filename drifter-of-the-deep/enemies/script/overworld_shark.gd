extends Enemy

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var player: Player = Game.player
@onready var hitbox = $Hitbox
@onready var timer = $Timer

func take_damage():
	if dying:
		return

	set_physics_process(false)

	health = health - 1

	if health <= 0:
		die()
	else:
		animation.play("hurt")
		await animation.animation_finished
		
		set_physics_process(true)

func die():
	dying = true
	
	var tween: Tween = create_tween().set_loops(4)
	tween.tween_property(sprite, "visible", false, 0.1).from(true)
	tween.tween_interval(0.1)
	await tween.finished
	
	queue_free()

func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
	velocity = position.direction_to(player.global_position) * movement_speed
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(1)
