extends Node2D

enum State { MENU, MENU_FADE_OUT, PLAYING, GAME_OVER }

var _score := 0
var _state = State.MENU
# The current wave
var _wave
var _escapees := 0
var _player 

onready var _Player := preload("res://src/Player.tscn")
onready var _Wave := preload("res://src/Wave.tscn")
onready var _animation_player := $AnimationPlayer
onready var _score_label : Label = $ScoreLabel
onready var _start_sound := $StartSound


func _ready() -> void:
	$MainMenuControl/PlayButton.grab_focus()


func _on_Alien_destroyed() -> void:
	_score += 10 - 2 * _escapees
	_update_score_label()
	
	
func _update_score_label()->void:
	_score_label.text = str(_score)


func _on_Player_destroyed() ->void:
	_state = State.GAME_OVER
	yield(get_tree().create_timer(1), "timeout")
	_animation_player.play("GameOverFadeIn")


func _on_MainMenuButton_button_down() ->void :
	_start_sound.play()
	if _player:
		remove_child(_player)
		_player.queue_free()
	if _wave:
		_wave.clear()
		remove_child(_wave)
		_wave.queue_free()
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
	_player = _Player.instance()
	var _ignored = _player.connect("destroyed", self, "_on_Player_destroyed", [], CONNECT_ONESHOT)
	add_child(_player)
	_start_wave(1)


func _start_wave(level:int):
	if _state != State.PLAYING:
		return
	
	_wave = _Wave.instance()
	_wave.level = level
	var _ignored = _wave.connect("alien_destroyed", self, "_on_Alien_destroyed")
	_ignored = _wave.connect("alien_escaped", self, "_on_Alien_escaped")
	_ignored = _wave.connect("complete", self, "_on_Wave_complete")
	add_child(_wave)


func _on_Wave_complete() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	_start_wave(_wave.level + 1)


func _on_FullScreenCheck_pressed():
	OS.window_fullscreen = not OS.window_fullscreen


func _on_MuteCheck_pressed():
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))


func _on_PlayButton_pressed():
	_start_sound.play()	
	_state = State.MENU_FADE_OUT
	_animation_player.play("MenuFadeOut")


func _on_Alien_escaped():
	_escapees += 1
	if _escapees == 3:
		_player.enabled = false
		_state = State.GAME_OVER
		_animation_player.play("GameOverFadeIn")
