extends Sprite

export(float) var mass = 1.989e30

var initial_velocity := Vector2(0.0, 1.22)
onready var last_position := global_position - initial_velocity


func _process(delta: float) -> void:
	var velocity: Vector2 = global_position - last_position 
	last_position = global_position
	global_position += velocity
	
