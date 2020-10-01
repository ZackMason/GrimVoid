extends Interactable

export var engine_torque = 2500.0

var pilot = null
var pilot_parent = null
var pilot_position = Vector2.ZERO
onready var _power = $Power

func _process(delta):
	if not pilot: return

	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input *= 2.0
	
	_power.try_deplete(abs(input.x) * delta)

	if Input.is_action_just_pressed("ui_cancel"):
		pilot_parent.add_child(pilot)
		pilot.global_position = to_global(pilot_position)
		pilot.global_rotation = _room.global_rotation
		pilot._room = null
		pilot = null
		get_tree().get_nodes_in_group("darkness")[0].visible = true
		$CanvasLayer/RoomsGui.visible = false
	


func _unhandled_input(event):
	if not pilot: return
	var turrets = _room.all_nodes_in_group("turret")
	var fire = Input.is_action_just_pressed("fire")
	for turret in turrets:
		turret.operate()
		if fire and _power.try_deplete(.5): 
			turret.fire()
		
func _physics_process(_delta):
	if not pilot: return

	if not _room: return
		
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input *= 2.0
	
	
	var rooms = _room.all_nodes_in_group("rigid")
	for r in rooms:
		r = r as RigidRoom
		if Input.is_key_pressed(KEY_SPACE):
			r.set_applied_force(Vector2.ZERO)
			
	var b = _room.top_body() as RigidBody2D
	b.set_applied_torque(input.x*engine_torque)
	
	var engines = _room.all_nodes_in_group("engine")
	var force = Vector2.ZERO
	for e in engines:
		if e.power(abs(input.y) > 0.5):
			force += e.force
	b.set_applied_force(force)


func alt_interact(_node):
	$Health.damage(-10)

func interact(node):
	pilot = node
	pilot_parent = pilot.get_parent()
	pilot_position = to_local(node.global_position)
	pilot_parent.remove_child(node)
	pilot._room = self
	get_tree().get_nodes_in_group("darkness")[0].visible = false
	$CanvasLayer/RoomsGui.rooms = [_room]
	$CanvasLayer/RoomsGui.visible = true
