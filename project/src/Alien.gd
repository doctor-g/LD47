class_name Alien
extends Area2D

export var speed := 40.0
export var rotation_speed := 5.0

onready var _sprite := $Sprite

func _physics_process(delta):
	position += Vector2.DOWN.rotated(rotation) * speed * delta
	_sprite.rotate(rotation_speed * delta)

func damage():
	queue_free()
