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

#func _input_event(viewport, event, shape_idx):
#	if not event is InputEventMouseButton:
#		return self
#	if event.button_index == BUTTON_LEFT and event.pressed:
#		print("Clicked")
#		return(self) # returns a reference to this node

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
		

