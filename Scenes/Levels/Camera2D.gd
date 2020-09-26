extends Camera2D

export(NodePath) var follow
export(NodePath) var follow_ship
onready var follow_node = get_node(follow)
onready var ship_follow_node = get_node(follow_ship)

func _process(delta):
	if follow_node and follow_node.is_inside_tree():
		global_rotation = follow_node.global_rotation
#		$Tween.interpolate_property(self, "rotation", rotation, follow_node.global_rotation, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
#		$Tween.start()
#		global_position = global_position.linear_interpolate(follow_node.global_position, 3.995 * delta)
		global_position = follow_node.global_position
	elif ship_follow_node and ship_follow_node.is_inside_tree():
		global_rotation = ship_follow_node.global_rotation
#		$Tween.interpolate_property(self, "rotation", rotation, ship_follow_node.global_rotation, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
#		$Tween.start()
		global_position = global_position.linear_interpolate(ship_follow_node.global_position, 1.995 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom -= Vector2(0.1, 0.1)
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom += Vector2(0.1, 0.1)

	zoom.x = max(0.1, zoom.x)
	zoom.y = max(0.1, zoom.y)
