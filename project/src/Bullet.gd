extends KinematicBody2D

export var speed := 10


func _physics_process(_delta):
	var _ignored := move_and_collide(Vector2.UP.rotated(rotation) * speed)


func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.yellow)
