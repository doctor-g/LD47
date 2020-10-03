class_name Alien
extends Area2D

export var speed := 40.0

func _physics_process(delta):
	position += Vector2.DOWN.rotated(rotation) * speed * delta


func damage():
	queue_free()
