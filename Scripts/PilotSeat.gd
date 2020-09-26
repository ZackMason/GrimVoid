extends Interactable

export(NodePath) var ship_path
onready var _ship = get_node(ship_path)

var pilot = null
var pilot_parent = null
var pilot_position = Vector2.ZERO

func _process(delta):
	if not pilot: return

	if Input.is_action_just_pressed("ui_cancel"):
		pilot_parent.add_child(pilot)
		pilot.global_position = to_global(pilot_position)
		pilot = null
		get_tree().get_nodes_in_group("darkness")[0].visible = true
		
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input *= 2.0
	_ship.velocity += input * _ship.move_speed
	
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var engines = _ship.get_node("Ship/Engines")
	for e in engines.get_children():
		e.power(abs(input.y) > 0.5)

func alt_interact(node):
	$Health.damage(-10)

func interact(node):
	pilot = node
	pilot_parent = pilot.get_parent()
	pilot_position = to_local(node.global_position)
	pilot_parent.remove_child(node)
	get_tree().get_nodes_in_group("darkness")[0].visible = false
