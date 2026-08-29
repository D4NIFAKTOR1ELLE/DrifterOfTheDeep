extends Enemy

@onready var hurtbox: RectangleShape2D = $Hurtbox/Collision.shape
@onready var collision: RectangleShape2D = $Collision.shape

var collision_growth: Vector2 = Vector2(10, 10)
var hurtbox_growth: Vector2 = Vector2(50, 50)

func puff():
	sprite.play("PuffUp")
	await sprite.animation_finished
	movement_speed = 30
	collision.set_deferred("size", collision.size + collision_growth)
	hurtbox.set_deferred("size", collision.size + hurtbox_growth)
	sprite.play("IdlePuff")

func depuff():
	sprite.play("PuffDown")
	await sprite.animation_finished
	movement_speed = 110
	collision.set_deferred("size", collision.size - collision_growth)
	hurtbox.set_deferred("size", collision.size - hurtbox_growth)
	sprite.play("IdleDown")

func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		puff()

func _physics_process(_delta: float) -> void:
	velocity = position.direction_to(player.movement.global_position) * movement_speed
	move_and_slide()

func _on_radius_body_exited(_body: Node2D) -> void:
	await get_tree().create_timer(2).timeout
	
	if !$Radius.has_overlapping_bodies():
		depuff()
