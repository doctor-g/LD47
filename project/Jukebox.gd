extends AudioStreamPlayer

onready var menu := preload("res://assets/music/menu.ogg")
onready var theme := preload("res://assets/music/theme.ogg")

func _ready():
	stream = menu
	play()


func play_theme():
	stream = theme
	play()
	
	
func play_menu():
	stream = menu
	play()
