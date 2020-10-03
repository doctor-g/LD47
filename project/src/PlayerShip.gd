extends KinematicBody2D

onready var _collision_shape := $CollisionShape2D

func _draw():
	draw_circle(Vector2.ZERO, _collision_shape.shape.radius, Color.magenta)
	draw_line(Vector2.ZERO, Vector2(0, -_collision_shape.shape.radius), Color.black)
