class_name Alien
extends Area2D

signal destroyed

export var speed := 40.0
export var rotation_speed := 5.0

onready var _sprite := $Sprite
onready var Explosion := preload("res://src/Explosion.tscn")


func _physics_process(delta):
	position += Vector2.DOWN.rotated(rotation) * speed * delta
	_sprite.rotate(rotation_speed * delta)


func damage():
	var explosion := Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	emit_signal("destroyed")
	queue_free()
