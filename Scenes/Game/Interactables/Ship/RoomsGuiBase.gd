extends Panel

var rooms = [] setget set_rooms

var room_gui = preload('res://Scenes/UI/ShipGUIRoom.tscn')

export var world_scale = 1.7

var components = ["Health", "Power", "Oxygen", "Heat"]

var comp_current = [0,0,0,0]
var comp_max = [0,0,0,0]

func update_stats():
	if rooms.empty(): return
	for i in range(components.size()):
		comp_current[i] = 0.0
		comp_max[i] = 0.0

	rooms = [rooms[0]]
	for r in rooms:
		for cr in r.connected_rooms:
			if not cr in rooms:
				rooms.append(cr)
				for i in range(components.size()):
					var c = components[i]
					var comp = cr.get_node(c)
					comp_current[i] += comp.value
					comp_max[i] += comp.max_value
					get_node("Stats/" + c).max_value = comp_max[i]
					get_node("Stats/" + c).value = comp_current[i]
					
func _process(delta):
	if visible:
		update_stats()

func set_rooms(arr):
	rooms = arr
	

	
	for c in $Room.get_children():
		c.queue_free()
		
	for r in rooms:
		for cr in r.connected_rooms:
			if not cr in rooms:
				rooms.append(cr)
				var p = room_gui.instance()
				var delta = rooms[0].to_local(cr.global_position) / world_scale
				$Room.add_child(p)
				p.rect_position = delta

var drag_position = null

func _on_RoomsGui_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - $Room.rect_global_position
		else:
			drag_position = null
	
	if event is InputEventMouseMotion and drag_position:
		$Room.rect_global_position = get_global_mouse_position() - drag_position
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				$Room.rect_scale += Vector2(0.1,0.1)
#				set_rooms([rooms[0]])
			if event.button_index == BUTTON_WHEEL_DOWN:
				$Room.rect_scale += -Vector2(0.1,0.1)
#				set_rooms([rooms[0]])
