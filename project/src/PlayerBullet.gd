extends Area2D

const KILL_THRESHOLD_SQUARED := 25

export var speed := 500.0


func _physics_process(delta):
	position += Vector2.UP.rotated(rotation) * speed * delta
	if position.length_squared() < KILL_THRESHOLD_SQUARED:
		queue_free()
	

func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.yellow)


func _on_PlayerBullet_area_entered(area):
	if area.has_method('damage'):
		area.damage()
		queue_free()
