extends Machine

export var engine_torque = 2500.0

var pilot = null
var pilot_parent = null
var pilot_position = Vector2.ZERO

onready var _ship = get_parent().get_parent()

var ld = 0.0

func _process(delta):
	if not pilot: return
	ld = delta
	
func _unhandled_input(event):
	if not pilot: return
	var delta = ld
	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input *= 2.0
	
	_power.try_deplete(abs(input.x) * delta)

	if Input.is_action_just_pressed("ui_cancel"):
		pilot_parent.add_child(pilot)
		pilot.global_position = to_global(pilot_position)
		#bug if no room
		pilot.global_rotation = _room.global_rotation
		pilot._room = null
		pilot = null
		get_tree().get_nodes_in_group("darkness")[0].visible = true
		$CanvasLayer/RoomsGui.visible = false
	var ship = get_parent().get_parent()
	var weapons = ship.weapons
	for weapon in weapons:
		if not weapon: 
			ship.weapons.erase(weapon)
			continue
		weapon.operate()
		if Input.is_action_just_pressed("fire"):
			weapon.fire()
			
#	var turrets = _room.all_nodes_in_group("turret")
#	var fire = Input.is_action_just_pressed("fire")
#	for turret in turrets:
#		turret.operate()
#		if fire and _power.try_deplete(.5): 
#			turret.fire()
#
func _physics_process(_delta):
	if not pilot: return

	var input := Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input *= 2.0
	
	_ship.set_applied_torque(input.x*engine_torque)
	
	var engines = _ship.get_node("Engines").get_children()
	var force = Vector2.ZERO
	for e in engines:
		e.powered_on = abs(input.y) > 0.5


func alt_interact(_node):
	$Health.damage(-10)

func interact(node):
	pilot = node
	pilot_parent = pilot.get_parent()
	pilot_position = to_local(node.global_position)
	pilot_parent.remove_child(node)
	pilot._room = self
	get_tree().get_nodes_in_group("darkness")[0].visible = false
#	$CanvasLayer/RoomsGui.rooms = [_room]
	
#	$CanvasLayer/RoomsGui.rooms = get_tree().get_nodes_in_group('room')
	$CanvasLayer/RoomsGui.visible = true
	$CanvasLayer/RoomsGui._room = _room

func _ready():
	$CanvasLayer/RoomsGui._room = _room
	
	
	
	
	
