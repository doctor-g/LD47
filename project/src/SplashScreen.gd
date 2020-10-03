extends Control

var _pressed := false

onready var Next := preload("res://src/Level.tscn")
onready var animation_player := $AnimationPlayer


func _input(event):
	if not _pressed:
		if event is InputEventMouseButton or event.is_action("fire"):
			_pressed = true
			animation_player.play("ScrollAway")
			$StartSound.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "ScrollAway":
		var _ignored := get_tree().change_scene_to(Next)
