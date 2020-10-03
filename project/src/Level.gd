extends Node2D

enum State { MENU, MENU_FADE_OUT, PLAYING, GAME_OVER }

var _score := 0
var _state = State.MENU

onready var _Alien := preload("res://src/Alien.tscn")
onready var _Player := preload("res://src/Player.tscn")
onready var _aliens := $Aliens
onready var _animation_player := $AnimationPlayer
onready var _score_label : Label = $ScoreLabel
onready var _start_sound := $StartSound


func _input(event):
	if _state==State.MENU and event.is_action("fire"):
		_start_sound.play()	
		_state = State.MENU_FADE_OUT
		_animation_player.play("MenuFadeOut")


func _on_Alien_destroyed() -> void:
	_score += 10
	_update_score_label()
	
	
func _update_score_label()->void:
	_score_label.text = str(_score)


func _on_Player_destroyed() ->void:
	yield(get_tree().create_timer(1), "timeout")
	_animation_player.play("GameOverFadeIn")


func _on_MainMenuButton_button_down() ->void :
	_start_sound.play()
	for alien in _aliens.get_children():
		_aliens.remove_child(alien)
		alien.queue_free()
	_animation_player.play("GameOverFadeOut")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "MenuFadeOut":
		_start_game()
	elif anim_name == "GameOverFadeOut":
		_state = State.MENU


func _start_game() -> void:
	_state = State.PLAYING
	_score = 0
	_update_score_label()
	_score_label.visible = true
	var player := _Player.instance()
	var _ignored = player.connect("destroyed", self, "_on_Player_destroyed", [], CONNECT_ONESHOT)
	add_child(player)
	
	for i in range(0,5):
		var alien = _Alien.instance()
		alien.rotate(TAU * i / 5)
		alien.connect("destroyed", self, "_on_Alien_destroyed", [], CONNECT_ONESHOT)
		_aliens.add_child(alien)


func _on_FullScreenCheck_pressed():
	OS.window_fullscreen = not OS.window_fullscreen
