extends RigidBody2D
class_name RigidRoom

var connected_rooms := []

func unparent_room_contents():
	for c in get_children():
		if c.is_in_group("interactable") or c.is_in_group("guy"):
			var gt = c.global_transform
			var gp = c.global_position
			c._room = null
			remove_child(c)
			get_parent().add_child(c)
			c.global_transform = gt
			c.global_position = gp

func remove_neighbor_room(room):
	connected_rooms.erase(room)
	
func add_neighbor_room(room):
	connected_rooms.append(room)
	
func all_nodes_in_group(group, res := [], walked := {}):
	if is_in_group(group):
		res.append(self)
	for c in get_children():
			if c.is_in_group(group):
				res.append(c)
	for room in connected_rooms:
		if room in walked: continue
		walked[room] = true
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
