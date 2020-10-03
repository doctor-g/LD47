extends Node2D

const FALLOFF_START := 100.0
const FALLOFF_START_SQUARED := FALLOFF_START * FALLOFF_START

onready var _node : Node2D = get_parent()


func _physics_process(_delta):
	var distance_squared := _node.position.length_squared()
	if distance_squared <= FALLOFF_START_SQUARED:
		var new_scale := range_lerp(distance_squared, FALLOFF_START_SQUARED, 0, 1, 0)
		_node.scale = Vector2(new_scale, new_scale)
		
