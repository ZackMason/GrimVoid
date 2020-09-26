extends Interactable
##############################################################
var room_a = null
var room_b = null

export var sealed = false

export var oxygen_flow_rate = 6.0
export var temp_flow_rate = 3.0
export var power_flow_rate = 6.0
##############################################################
func _ready():
	._ready()
	$door_001.visible = not sealed

func _process(delta):
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

func alt_interact(node):
	sealed = not sealed
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

func _on_RoomADetector_area_entered(area):
	if area.is_in_group("room") and not room_a:
		room_a = area.get_room()
		if room_b and room_a is RigidRoom:
			room_a.attach(room_b)

func _on_RoomBDetector_area_entered(area):
	if area.is_in_group("room") and not room_b:
		room_b = area.get_room()
		if room_a and room_a is RigidRoom:
			room_a.attach(room_b)
			
func _on_RoomBDetector_area_exited(area):
	if area == room_b and area.is_in_group("room"):
		room_b.detach()
		room_b = null
	if room_a:
		room_a.detach()
			
func _on_RoomADetector_area_exited(area):
	if area == room_a and area.is_in_group("room"):
		room_a.detach()
		room_a = null
	if room_b:
		room_b.detach()
