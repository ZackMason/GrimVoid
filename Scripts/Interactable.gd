extends Area2D
class_name Interactable

var _room = null
export var disable_room_ownership = false

func interact(_node):
	print("no interaction")
	
func alt_interact(_node):
	print("no alternate interaction")
	
func text():
	return "Interactable"

func _ready():
	get_parent().add_to_group("interactable")
	input_pickable = true

var drag_position = null
var selected = false

func _input_event(viewport, event, shape_idx):
	if not ShipEditor.edit_mode: return
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT:
		
		if event.is_pressed():
			drag_position = get_global_mouse_position() - global_position
			selected = true
		else:
			selected = false
		return(self) # returns a reference to this node
	
func _input(event):
	if not selected or not ShipEditor.edit_mode: return
	
	if event is InputEventMouseMotion and drag_position:
		global_position = get_global_mouse_position() - drag_position
	
	if Input.is_action_just_pressed("ui_cancel"):
		selected = false


func _on_RoomArea_area_entered(area):
	if area.is_in_group("room") and not _room:
		_room = area.get_room()
		print("adding %s to %s" % [name, _room.name])
		if not disable_room_ownership and get_parent() != _room:
			var gt = get_global_transform()
			get_parent().call_deferred("remove_child" , self)
			_room.call_deferred("add_child", self)
			set_deferred("global_transform", gt)


func _on_RoomArea_area_exited(area):
	if area.is_in_group("room") and _room == area.get_room():
		_room = null
#		print("removing %s" % name)
