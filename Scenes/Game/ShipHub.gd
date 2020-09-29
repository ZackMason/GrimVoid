extends RigidBody2D
class_name ShipHub

var _room = null
var _connected_rooms := []

func attach_shapes(node):
	_connected_rooms.append(node)
	
	var gt = node.global_transform
#	node.disable_area()
	node.get_parent().remove_child(node)
	node.transform = global_transform.inverse() * gt 
	add_child(node)
#	node.global_transform = gt
	node.set_deferred("mode", MODE_STATIC)
	node.push_body(self, node)
#	node.disable_area(false)
	print("attached")
	
#	for child in node.get_children():
#		if child is CollisionShape2D:
#			node.remove_child(child)
#			add_child(child)

func _process(delta):
	if Input.is_key_pressed(KEY_9):
		interact(null)

func update_rooms():
	var connected_rooms : Array = _room.all_nodes_in_group("rigid")
	for c in get_children():
		if not c in connected_rooms:
			remove_room(c)

func interact(node):
	remove_room(node)
	
func remove_room(node):
	var gt = _room.global_transform
	_room.pop_body()
	remove_child(_room)
	_room.transform = get_parent().global_transform.inverse() * gt 
	get_parent().add_child(_room)
	_room.mode = MODE_RIGID
	_room.apply_central_impulse(linear_velocity)

func _on_RoomArea_area_entered(area):
	if not _room and area.is_in_group("room"):
		_room = area.get_room()
		print("hub in room: %s" % _room.name)
		attach_shapes(_room)
		
func _on_RoomArea_area_exited(area):
	if not _room and area.is_in_group("room") and area.get_room() == _room:
		_room = null
