class_name Alien
extends Area2D

export var ESCAPE_DISTANCE := 320

signal destroyed(alien)
signal escaped(alien)

var destroyed := false
var _escaped := false

export var speed := 30.0
export var rotation_speed := 5.0

onready var _sprite := $Sprite
onready var Explosion := preload("res://src/Explosion.tscn")


func _physics_process(delta):
	position += Vector2.DOWN.rotated(rotation) * speed * delta
	_sprite.rotate(rotation_speed * delta)
	if not _escaped and position.length() >= ESCAPE_DISTANCE:
		_escaped = true
		emit_signal("escaped", self)


func damage():
	destroyed = true
	var explosion := Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	emit_signal("destroyed", self)
	queue_free()
