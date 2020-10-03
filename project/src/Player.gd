extends Area2D

export var MAX_SPEED := 2.5
export var ACCELERATION := 0.25

var _speed := 0.0
var _radius := 320.0
var _angle := TAU / 4

onready var _Bullet := preload("res://src/PlayerBullet.tscn")
onready var _Explosion := preload("res://src/Explosion.tscn")
onready var _shoot_sfx : AudioStreamPlayer = $FireSFX

func _physics_process(delta):
	var direction := 0
	if Input.is_action_pressed("move_clockwise"):
		direction += 1
	if Input.is_action_pressed("move_counterclockwise"):
		direction -= 1
	
	if direction == 0:
		_speed *= ACCELERATION
	else:
		_speed = clamp(_speed + ACCELERATION * direction, -MAX_SPEED, MAX_SPEED)	
	_angle += _speed * delta
	
	position = Vector2(cos(_angle) * _radius, sin(_angle) * _radius)
	rotation = _angle - PI / 2
	
	if Input.is_action_just_pressed("fire"):
		_shoot_sfx.play()
		var bullet := _Bullet.instance()
		bullet.position = position
		bullet.rotation = rotation
		get_parent().add_child(bullet)
		


func _on_Player_area_entered(area):
	if area is Alien:
		var explosion = _Explosion.instance()
		explosion.position = position
		get_parent().add_child(explosion)
		queue_free()
