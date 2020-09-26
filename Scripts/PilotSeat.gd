extends Interactable

export var engine_torque = 100.0

var pilot = null
var pilot_parent = null
var pilot_position = Vector2.ZERO

func _process(_delta):
	if not pilot: return

	if Input.is_action_just_pressed("ui_cancel"):
		pilot_parent.add_child(pilot)
		pilot.global_position = to_global(pilot_position)
		pilot = null
#		get_tree().get_nodes_in_group("darkness")[0].visible = true
		
	if not _room: return
		
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	_ship.velocity += input * _ship.move_speed
	
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input *= 2.0
	
	
	var rooms = _room.all_nodes_in_group("rigid")
	for r in rooms:
		r = r as RigidRoom
		if Input.is_key_pressed(KEY_SPACE):
			r.add_central_force(-r.linear_velocity)
#			r.add_torque(-r.angular_velocity)
			r.applied_torque = 0.0
#			r.apply_central_impulse(-r.linear_velocity)
#			r.apply_torque_impulse (-r.angular_velocity)
	_room.add_torque(input.x*engine_torque)
	
	var engines  = _room.all_nodes_in_group("engine")
	for e in engines:#.get_children():
		e.power(abs(input.y) > 0.5)

func alt_interact(_node):
	$Health.damage(-10)

func interact(node):
	pilot = node
	pilot_parent = pilot.get_parent()
	pilot_position = to_local(node.global_position)
	pilot_parent.remove_child(node)
#	get_tree().get_nodes_in_group("darkness")[0].visible = false
