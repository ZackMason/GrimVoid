extends Camera2D

export(NodePath) var follow
export(NodePath) var follow_ship
onready var follow_node = get_node(follow)
onready var ship_follow_node = get_node(follow_ship)

var need_to_zoom = false

func _process(delta):
	if follow_node and follow_node.is_inside_tree():
		global_rotation = follow_node.global_rotation
		global_position = follow_node.global_position
		if need_to_zoom:
			zoom = Vector2(0.2,0.2)
			need_to_zoom = false
	else:
		need_to_zoom = true
		
		global_position = global_position.linear_interpolate(follow_node._room.global_position, 1.995 * delta)
		global_rotation = follow_node._room.global_rotation


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom -= Vector2(0.1, 0.1)
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom += Vector2(0.1, 0.1)

	zoom.x = max(0.1, zoom.x)
	zoom.y = max(0.1, zoom.y)
