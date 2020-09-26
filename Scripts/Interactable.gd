extends Area2D
class_name Interactable

var _room

func interact(node):
	print("no interaction")
	
func alt_interact(node):
	print("no alternate interaction")
	
func text():
	return "Interactable"

func _ready():
	get_parent().add_to_group("interactable")

#func _input_event(viewport, event, shape_idx):
#	if not event is InputEventMouseButton:
#		return self
#	if event.button_index == BUTTON_LEFT and event.pressed:
#		print("Clicked")
#		return(self) # returns a reference to this node


func _on_RoomArea_area_entered(area):
	if area.is_in_group("room") and not _room:
		_room = area.get_room()
