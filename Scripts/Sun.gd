extends Sprite

export(float) var galaxy_scale = 1.0e1

export(float) var mass = 1.0e2
onready var scaled_mass : float = mass / galaxy_scale


var gravity_constant : float = 1.0 # 6.67408e-11 / galaxy_scale

onready var last_position := global_position

var distance_scale := 0.01 # 373884

func _process(delta: float) -> void:
	var velocity : Vector2 = last_position - global_position
	last_position = global_position
	global_position += velocity
	

	for node in get_tree().get_nodes_in_group("gravity"):
		if node == self: continue
		
		var distance_to_body := global_position.distance_to(node.global_position) * distance_scale
		var to_sun := node.global_position.direction_to(global_position) as Vector2
		
		var m_div_r : float = scaled_mass / pow(distance_to_body, 3.0)
		var gravity_accel := m_div_r * gravity_constant
		
		node.global_position += to_sun * gravity_accel * delta
