extends Machine

var room_a = null
var room_b = null

var disabled = false

export var sealed = false setget set_sealed
export var seal_breaks = false

var connected = false

func set_sealed(x):
	sealed = x
	if not sealed and room_a and room_b and not connected:
#		connect_rooms()
		pass
	elif seal_breaks and sealed and connected:
		pass
#		disconnect_rooms()

export var oxygen_flow_rate = 6.0
export var temp_flow_rate = 3.0
##############################################################
func _ready():
	._ready()
	$door_001.visible = not sealed
#	connect("connection_changed", RoomConnections, "reparent")

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if connected and room_a and room_b:
#			disconnect_rooms()
			pass

func do(dt):
	pass


#func _process(delta):
#	if (not room_b or not room_a) and connected:
#		connected = false
#
#	if sealed: return 
#	if not room_a:
#		if not room_b: 
#			return
#		else:
#			room_b.oxygen -= oxygen_flow_rate * delta
#			return
#	else:
#		if not room_b:
#			room_a.oxygen -= oxygen_flow_rate * delta
#			return
#
#	var o_parity = 1.0
#	if room_b.oxygen > room_a.oxygen:
#		o_parity = -1.0
#	if room_b.oxygen != room_a.oxygen:
#		room_b.oxygen += oxygen_flow_rate * delta * o_parity
#		room_a.oxygen -= oxygen_flow_rate * delta * o_parity
#
#	var t_parity = 1.0
#	if room_b.temp > room_a.temp:
#		t_parity = -1.0
#	if room_b.temp != room_a.temp:
#		room_b.temp += temp_flow_rate * delta * t_parity
#		room_a.temp -= temp_flow_rate * delta * t_parity
#
#	return
#	var e_parity = 1.0
#	if room_b.power > room_a.power:
#		e_parity = -1.0
#	if room_b.power != room_a.power:
#		room_b.power += power_flow_rate * delta * e_parity
#		room_a.power -= power_flow_rate * delta * e_parity
##############################################################

func alt_interact(_node):
	set_sealed(not sealed)
	$door_001.visible = not sealed

## bug here somewhere
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
