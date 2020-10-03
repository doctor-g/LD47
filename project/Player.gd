extends Node2D

export var radius := 300.0
export var angle := PI * .5
export var speed := 3.5

onready var _Bullet := preload("res://src/Bullet.tscn")
onready var _ship := $PlayerShip


func _physics_process(delta):
	var direction := 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1
	angle -= speed * delta * direction
	
	var new_position := Vector2(cos(angle) * radius,  sin(angle) * radius)
	
	_ship.transform.origin = new_position
	_ship.rotation = angle - PI/2
	
	update()
	
	if Input.is_action_just_pressed("fire"):
		var bullet = _Bullet.instance()
		bullet.position = _ship.position
		bullet.rotation = _ship.rotation
		get_parent().add_child(bullet)
		


# Get the ship's location relative to its origin.
func _compute_position() -> Vector2:
	return Vector2(radius * cos(angle), radius * sin(angle))
