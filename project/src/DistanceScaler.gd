extends Node2D

const FALLOFF_START := 100.0
const FALLOFF_START_SQUARED := FALLOFF_START * FALLOFF_START

onready var _node : Node2D = get_parent()

func _ready():
	# Ensure that the target node start at zero scale, so that we have complete
	# control over it.
	_node.scale = Vector2.ZERO

func _physics_process(_delta):
	var distance_squared := _node.position.length_squared()
	var new_scale := clamp(range_lerp(distance_squared, FALLOFF_START_SQUARED, 0, 1, 0), 0, 1)
	_node.scale = Vector2(new_scale, new_scale)
		
