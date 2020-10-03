extends Node2D

signal alien_destroyed

onready var _Alien := preload("res://src/Alien.tscn")
onready var _aliens := $Aliens


func _ready():
	for i in range(0,5):
		var alien = _Alien.instance()
		alien.rotate(TAU * i / 5)
		alien.connect("destroyed", self, "_on_Alien_destroyed", [], CONNECT_ONESHOT)
		_aliens.add_child(alien)


# Remove all aliens
func clear():
	for alien in _aliens.get_children():
		_aliens.remove_child(alien)
		alien.queue_free()


func _on_Alien_destroyed() -> void:
	emit_signal("alien_destroyed")
