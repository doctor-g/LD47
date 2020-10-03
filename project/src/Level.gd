extends Node2D

onready var _camera : Camera2D = $Camera2D
onready var _Alien := preload("res://src/Alien.tscn")
onready var _aliens := $Aliens

func _ready():
	_camera.current = true
	for i in range(0,5):
		var alien = _Alien.instance()
		alien.rotate(TAU * i / 5)
		_aliens.add_child(alien)
