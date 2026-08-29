extends Enemy

@onready var hurtbox: RectangleShape2D = $Hurtbox/Collision.shape
@onready var collision: RectangleShape2D = $Collision.shape

var collision_growth: Vector2 = Vector2(10, 10)
var hurtbox_growth: Vector2 = Vector2(50, 50)

func puff():
	sprite.play("PuffUp")
	await sprite.animation_finished
	collision.set_deferred("size", collision.size + collision_growth)
	hurtbox.set_deferred("size", collision.size + hurtbox_growth)
	sprite.play("IdlePuff")

func depuff():
	sprite.play("PuffDown")
	await sprite.animation_finished
	collision.set_deferred("size", collision.size - collision_growth)
	hurtbox.set_deferred("size", collision.size - hurtbox_growth)
	sprite.play("IdleDown")
