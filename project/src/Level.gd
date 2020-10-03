extends Node2D

onready var _camera : Camera2D = $Camera2D
onready var _Alien := preload("res://src/Alien.tscn")
onready var _aliens := $Aliens
onready var _game_over_fade_in := $GameOverFadeIn

func _ready():
	_camera.current = true
	for i in range(0,5):
		var alien = _Alien.instance()
		alien.rotate(TAU * i / 5)
		_aliens.add_child(alien)


func _on_Player_destroyed():
	yield(get_tree().create_timer(1), "timeout")
	_game_over_fade_in.play("GameOverFadeIn")


func _on_MainMenuButton_button_down():
	# Later, this should go to the main menu, but for now, it just reloads for testing.
	var _ignored := get_tree().change_scene("res://src/Level.tscn")
