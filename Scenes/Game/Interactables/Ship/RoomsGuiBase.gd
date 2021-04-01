extends Panel

var _room = null

var room_gui = preload('res://Scenes/UI/ShipGUIRoom.tscn')

export var world_scale = 1.7

var components = ["Health", "Power", "Oxygen", "Heat"]

var comp_current = [0,0,0,0]
var comp_max = [0,0,0,0]



func update_stats():
	var _ship = get_parent().get_parent().get_parent().get_parent()
	
	for i in range(components.size()):
		comp_current[i] = 0.0
		comp_max[i] = 0.0

	for p in _ship._powers:
		if not p: 
			_ship._powers.erase(p)
			return
		comp_current[1] += p.value
		comp_max[1] += p.max_value
		$Stats/Power.value = comp_current[1]
		$Stats/Power.max_value = comp_max[1]

	for p in _ship._healths:
		if not p: 
			_ship._powers.erase(p)
			return
		comp_current[0] += p.value
		comp_max[0] += p.max_value
		$Stats/Health.value = comp_current[0]
		$Stats/Health.max_value = comp_max[0]

func _process(delta):
	if visible:
		minimap_display(get_tree().get_nodes_in_group('room'))
		update_stats()

func minimap_display(arr):
	for c in $Room.get_children():
		c.queue_free()
	for r in arr:
		var p = room_gui.instance()
		var delta = _room.to_local(r.global_position) / world_scale
		$Room.add_child(p)
		p.rect_position = delta

var drag_position = null

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				$Room.rect_scale *= 1.1
			if event.button_index == BUTTON_WHEEL_DOWN:
				$Room.rect_scale *= 0.9
			else:
				drag_position = get_global_mouse_position() - $Room.rect_global_position
		else:
			drag_position = null
	
	if event is InputEventMouseMotion and drag_position:
		$Room.rect_global_position = get_global_mouse_position() - drag_position
	
func _on_RoomsGui_mouse_exited():
	drag_position = null
