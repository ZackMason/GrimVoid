extends RigidBody2D
class_name RigidRoom

var connected_rooms := []
var connected_doors := []
var bodies = [self]
var body_from_room = [self]

export var depth = 1

var force := Vector2.ZERO

var disable_attach = false

func _ready():
	RoomConnections.add_room(self)

func disable_area(b := true):
	$RoomArea/CollisionShape2D.disabled = b

func set_doors_enabled(b):
	for d in connected_doors:
		d.disabled = not b

func push_body(body, room):
	bodies.push_back(body)
	body_from_room.push_back(room)
	
func pop_body():
	if bodies.size() > 1: bodies.pop_back()
	
func top_body():
	return bodies.back()

func print(s):
	print(s)

func attach_room(node):
	var gt = node.global_transform
	node.get_parent().call_deferred('remove_child', node)
	node.transform = global_transform.inverse() * gt
	call_deferred('add_child', node)
	node.set_deferred("mode", MODE_STATIC)
	node.push_body(top_body(), node)
	
func detach_room(node):
	var gt = node.global_transform
	node.top_body().call_deferred('remove_child', node)
	node.pop_body()
	node.transform = get_parent().global_transform.inverse() * gt
	top_body().get_parent().call_deferred('add_child', node)
	if node.top_body() == node:
		node.mode = MODE_RIGID

func fill_add_depth(ignore, d, pop = false):
	depth += d
	ignore.append(self)
	for r in connected_rooms:
		if not r in ignore:
			if pop: r.pop_body()
			r.fill_add_depth(ignore, d, pop)

func unparent_room_contents():
	for c in get_children():
		if c.is_in_group("interactable") or c.is_in_group("guy"):
			var gt = c.global_transform
			var gp = c.global_position
			
			c._room = null
			remove_child(c)
			var w = get_tree().get_nodes_in_group("world")[0]
			w.add_child(c)
			c.global_transform = gt
			c.global_position = gp

func remove_neighbor_room(room):
	if disable_attach: return
	
	connected_rooms.erase(room)
		
#	if depth < room.depth:
#		top_body().detach_room(room)
#		fill_add_depth([room], -room.depth,true)
#	return
#
#	if top_body() is ShipHub:
#		top_body().update_rooms()
##	if body_from_room.back() == room:
#		top_body().interact(self)
	
func add_neighbor_room(room):
	if disable_attach: return
#	if depth <= room.depth and room.top_body() != self:
#		print("adding %s to %s" % [room.name, name])
#		attach_room(room)
#		room.fill_add_depth([self], depth)
	connected_rooms.append(room)
	
#	if bodies.size() < room.bodies.size():
#		room.top_body().attach_shapes(self)

	
func all_nodes_in_group(group, res := [], walked := {}):
	if is_in_group(group) and not self in res:
		res.append(self)
	walked[self] = true
	for c in get_children():
		if c.is_in_group(group) and not c in res:
			res.append(c)
	for room in connected_rooms:
		if room in walked: continue
		res = room.all_nodes_in_group(group, res, walked)
	return res

func print_all_rooms(walked := {}):
	for room in connected_rooms:
		if room in walked: continue
		walked[room] = true
		print(room.name)
		room.print_all_rooms(walked)

func _exit_tree():
	for room in connected_rooms:
		room.connected_rooms.erase(self)
	
var oxygen := 100.0 setget set_oxygen, get_oxygen
func get_oxygen():
	return $Oxygen.value
func set_oxygen(ox):
	$Floor.self_modulate = Color(1.0, ox/100.0, ox/100.0, 1.0)
	$Oxygen.value = ox

var temp := 100.0 setget set_temp , get_temp
func get_temp():
	return $Heat.value
func set_temp(ox):
	$Heat.value = ox

var power := 100.0 setget set_power , get_power
func get_power():
	return $Power.value
func set_power(ox):
	$Power.value = ox
	power = ox

func _process(delta):
	set_oxygen($Oxygen.value - delta * .5)
