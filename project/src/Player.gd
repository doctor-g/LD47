extends Area2D

signal destroyed

export var MAX_SPEED := 2.5
export var FIRE_COOLDOWN := 0.35

var enabled := true

var _radius := 320.0
var _angle := TAU / 4
var _touch_input := false
var _target_angle : float
var _can_fire := true

onready var _Bullet := preload("res://src/PlayerBullet.tscn")
onready var _Explosion := preload("res://src/Explosion.tscn")
onready var _shoot_sfx : AudioStreamPlayer = $FireSFX
onready var _fire_cooldown : Timer = $FireCooldown


func _ready():
	_set_position_and_rotation()
	
	
func _set_position_and_rotation()->void:
	position = Vector2(cos(_angle) * _radius, sin(_angle) * _radius)
	rotation = _angle - PI / 2


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			_touch_input = true
			var transformed_point = event.position - Vector2(400,400)
			_target_angle = transformed_point.angle()
		else:
			_touch_input = false
	if event is InputEventMouseMotion and _touch_input:
		var transformed_point = event.position - Vector2(400,400)
		_target_angle = transformed_point.angle()
		

func _physics_process(delta):
	if not enabled:
		return
	
	var is_key_input := false
	
	if not _touch_input:
		var target_vector := Vector2.ZERO
		if Input.is_action_pressed("move_up"):
			target_vector.y -= 1
			is_key_input = true
		if Input.is_action_pressed("move_down"):
			target_vector.y += 1
			is_key_input = true		
		if Input.is_action_pressed("move_left"):
			target_vector.x -= 1
			is_key_input = true		
		if Input.is_action_pressed("move_right"):
			target_vector.x += 1
			is_key_input = true		
		if is_key_input:
			_target_angle = target_vector.angle()
			
	
	if is_key_input or _touch_input:
		var diff := fmod(_target_angle - _angle, TAU)
		var shortest := fmod(2*diff, TAU) - diff
		_angle += min(abs(shortest), MAX_SPEED*delta) * sign(shortest)
		
	_set_position_and_rotation()
	
	if _can_fire and (Input.is_action_pressed("fire") or _touch_input):
		_fire()
		

func _fire():
	_shoot_sfx.play()
	var bullet := _Bullet.instance()
	bullet.position = position
	bullet.rotation = rotation
	get_parent().add_child(bullet)
	_can_fire = false
	_fire_cooldown.start(FIRE_COOLDOWN)


func _on_Player_area_entered(area):
	if area is Alien:
		var explosion = _Explosion.instance()
		explosion.position = position
		get_parent().add_child(explosion)
		emit_signal("destroyed")
		queue_free()


func _on_FireCooldown_timeout():
	_can_fire = true
