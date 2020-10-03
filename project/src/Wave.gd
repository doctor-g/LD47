extends Node2D

signal alien_destroyed
signal alien_escaped
signal complete

var level := 1

var _count : int

onready var _Alien := preload("res://src/Alien.tscn")
onready var _aliens := $Aliens


func _ready():
	_count = level + 2
	for i in range(0,_count):
		var alien = _Alien.instance()
		alien.rotate(TAU * i / _count)
		alien.connect("destroyed", self, "_on_Alien_destroyed", [], CONNECT_ONESHOT)
		alien.connect("escaped", self, "_on_Alien_escaped", [], CONNECT_ONESHOT)
		_aliens.add_child(alien)


# Remove all aliens
func clear():
	for alien in _aliens.get_children():
		_aliens.remove_child(alien)
		alien.queue_free()


func _on_Alien_destroyed(alien:Alien) -> void:
	_aliens.remove_child(alien)
	_count-=1
	emit_signal("alien_destroyed")
	if _count == 0:
		emit_signal("complete")
	
	
func _on_Alien_escaped(_alien:Alien) -> void:
	_count -= 1
	emit_signal("alien_escaped")
	if _count == 0:
		emit_signal("complete")
