extends Area2D

export var MAX_SPEED := 2.5

signal destroyed

var _radius := 320.0
var _angle := TAU / 4

onready var _Bullet := preload("res://src/PlayerBullet.tscn")
onready var _Explosion := preload("res://src/Explosion.tscn")
onready var _shoot_sfx : AudioStreamPlayer = $FireSFX


func _ready():
	_set_position_and_rotation()
	
	
func _set_position_and_rotation()->void:
	position = Vector2(cos(_angle) * _radius, sin(_angle) * _radius)
	rotation = _angle - PI / 2
	

func _physics_process(delta):
	var target_vector := Vector2.ZERO
	var is_input := false
	if Input.is_action_pressed("move_up"):
		target_vector.y -= 1
		is_input = true
	if Input.is_action_pressed("move_down"):
		target_vector.y += 1
		is_input = true		
	if Input.is_action_pressed("move_left"):
		target_vector.x -= 1
		is_input = true		
	if Input.is_action_pressed("move_right"):
		target_vector.x += 1
		is_input = true		
		
	var target_angle = target_vector.angle()
	
	if is_input:
		var diff := fmod(target_angle - _angle, TAU)
		var shortest := fmod(2*diff, TAU) - diff
		_angle += min(abs(shortest), MAX_SPEED*delta) * sign(shortest)
		
	_set_position_and_rotation()
	
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
		emit_signal("destroyed")
		queue_free()
