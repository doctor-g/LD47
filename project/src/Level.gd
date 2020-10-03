extends Node2D

var _score := 0

onready var _Alien := preload("res://src/Alien.tscn")
onready var _aliens := $Aliens
onready var _game_over_fade_in := $GameOverFadeIn
onready var _score_label : Label = $ScoreLabel

func _ready():
	for i in range(0,5):
		var alien = _Alien.instance()
		alien.rotate(TAU * i / 5)
		alien.connect("destroyed", self, "_on_Alien_destroyed", [], CONNECT_ONESHOT)
		_aliens.add_child(alien)


func _on_Alien_destroyed() -> void:
	_score += 10
	_score_label.text = str(_score)


func _on_Player_destroyed() ->void:
	yield(get_tree().create_timer(1), "timeout")
	_game_over_fade_in.play("GameOverFadeIn")


func _on_MainMenuButton_button_down() ->void :
	# Later, this should go to the main menu, but for now, it just reloads for testing.
	var _ignored := get_tree().change_scene("res://src/Level.tscn")
