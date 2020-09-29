extends Node

var all_rooms := []
var wires := []

var major_physics_bodys := []

# rb[room] = body
var room_body := {}

export var power_flow_rate = 6.0

func _process(delta):
	for w in wires:
		var obj_a = w[0]
		var obj_b = w[1]
		if not (obj_a and obj_b):
			w[2].queue_free()
			wires.erase(w)
			continue
			
		var e_parity = 1.0
		if obj_b.value > obj_a.value:
			e_parity = -1.0
		if obj_b.value != obj_a.value:
			obj_b.value += power_flow_rate * delta * e_parity
			obj_a.value -= power_flow_rate * delta * e_parity

func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	reparent()

func add_room(room):
	all_rooms.append(room)
	
func get_all_connected_rooms(room):
	var res = [room]
	for x in res:
		for r in x.connected_rooms:
			if not r in res: res.append(r)
	return res

func get_all_single_bodies():
	var res = []
	var ignore_list = []
	for r in all_rooms:
		if not r in ignore_list:
			var connected = get_all_connected_rooms(r)
			res.append(connected)
			for cr in connected:
				ignore_list.append(cr)
	return res

func reparent():
	get_tree().call_group("door", "set", "disabled", true)
	
	var bodies = get_all_single_bodies()
	for body in bodies:
		var deepest = body[0]
		for x in body:
			if x.depth > deepest.depth:
				deepest = x
		for r in body:
			if r != deepest:
				deepest.depth += 1
				deepest.attach_room(r)
		if deepest.is_inside_tree() == false:
			var gt = deepest.global_transform
			var w = get_tree().get_nodes_in_group("world")[0].add_child(deepest)
			deepest.global_transform = gt
	get_tree().call_group("door", "set", "disabled", false)
