extends Panel

var drag_position = null

onready	var _pins = $Pins.get_children()

func check_pins_hovered():
	var f = false
	for p in _pins:
		if p.hovered:
			f = true
	return f

func _input(event):
	if check_pins_hovered() or $ConnectionStarted.visible: 
		drag_position = null
		return
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
