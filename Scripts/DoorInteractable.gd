extends Interactable
##############################################################
var room_a = null
var room_b = null

export var sealed = false setget set_sealed
export var seal_breaks = false

func set_sealed(x):
	sealed = x
	if not sealed and room_a and room_b and not connected:
		connect_rooms()
	elif seal_breaks and sealed and connected:
		disconnect_rooms()

export var oxygen_flow_rate = 6.0
export var temp_flow_rate = 3.0
export var power_flow_rate = 6.0
##############################################################
func _ready():
	._ready()
	$door_001.visible = not sealed

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if connected and room_a and room_b:
			disconnect_rooms()

func _process(delta):
	if not joint:
		joint = joint_dup.duplicate()
		add_child(joint)
		connected = false
	if not room_b and connected:
		connected = false
		room_a.remove_child(joint)
		add_child(joint)
		joint.node_a = ""
		joint.node_b = ""
		
	if sealed: return 
	if not room_a:
		if not room_b: 
			return
		else:
			room_b.oxygen -= oxygen_flow_rate * delta
			return
	else:
		if not room_b:
			room_a.oxygen -= oxygen_flow_rate * delta
			return
			
	var o_parity = 1.0
	if room_b.oxygen > room_a.oxygen:
		o_parity = -1.0
	if room_b.oxygen != room_a.oxygen:
		room_b.oxygen += oxygen_flow_rate * delta * o_parity
		room_a.oxygen -= oxygen_flow_rate * delta * o_parity

	var t_parity = 1.0
	if room_b.temp > room_a.temp:
		t_parity = -1.0
	if room_b.temp != room_a.temp:
		room_b.temp += temp_flow_rate * delta * t_parity
		room_a.temp -= temp_flow_rate * delta * t_parity
		
	var e_parity = 1.0
	if room_b.power > room_a.power:
		e_parity = -1.0
	if room_b.power != room_a.power:
		room_b.power += power_flow_rate * delta * e_parity
		room_a.power -= power_flow_rate * delta * e_parity
##############################################################

func alt_interact(_node):
	set_sealed(not sealed)
	$door_001.visible = not sealed

func interact(node):
	if sealed:
		print("the door is sealed")
		return
	
	var closest_node = $ExitA
	var farthest_node = $ExitB
	if node.global_position.distance_to(closest_node.global_position) > node.global_position.distance_to($ExitB.global_position):
		farthest_node = $ExitA
		closest_node = $ExitB
	
	node.global_position = farthest_node.global_position
	node._room = null# room_a if closest_node == $ExitA else room_b

var connected = false
onready var joint = $Connection
onready var joint_dup = joint.duplicate()

func disconnect_rooms():
	assert(connected)
	print("disconnecting %s" % name)
	var gt = joint.global_transform
	room_a.remove_child(joint)
	add_child(joint)
	joint.global_transform = gt
	joint.node_a = ""
	joint.node_b = ""
	
	room_a.remove_neighbor_room(room_b)
	room_b.remove_neighbor_room(room_a)
	
	connected = false
	
func connect_rooms():
	assert(not connected)
	print("connected rooms")
	var gt = joint.global_transform
	remove_child(joint)
	room_a.add_child(joint)
	joint.node_a = room_a.get_path()
	joint.node_b = room_b.get_path()
	joint.global_transform = gt
	room_a.add_neighbor_room(room_b)
	room_b.add_neighbor_room(room_a)
	connected = true
	
func _on_RoomADetector_area_entered(area):
	if area.is_in_group("room") and not room_a:
		room_a = area.get_room()
		if room_b and not sealed:
			 connect_rooms()
			
func _on_RoomBDetector_area_entered(area):
	if area.is_in_group("room") and not room_b:
		room_b = area.get_room()
		if room_a and not sealed:
			 connect_rooms()
			
func _on_RoomBDetector_area_exited(area):
	if area.is_in_group("room") and area.get_room() == room_b:
		if connected: disconnect_rooms()
		room_b = null
		
func _on_RoomADetector_area_exited(area):
	if area.is_in_group("room") and area.get_room() == room_a:
		if connected: disconnect_rooms()
		room_a = null
