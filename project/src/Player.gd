extends Area2D

export var speed := 3.0

var _radius := 320.0
var _angle := TAU / 4

onready var _Bullet := preload("res://src/PlayerBullet.tscn")
onready var _Explosion := preload("res://src/Explosion.tscn")

func _process(delta):
	var direction := 0
	if Input.is_action_pressed("move_clockwise"):
		direction += 1
	if Input.is_action_pressed("move_counterclockwise"):
		direction -= 1
	_angle += speed * delta * direction
	
	position = Vector2(cos(_angle) * _radius, sin(_angle) * _radius)
	rotation = _angle - PI / 2
	
	if Input.is_action_just_pressed("fire"):
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
