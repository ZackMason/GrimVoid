extends Area2D
class_name InteractableArea

var nearby_interactables := []


func _on_InteractableArea_area_entered(area):
	nearby_interactables.push_back(area)
	print("added %s" % area.name)

func _on_InteractableArea_area_exited(area):
	nearby_interactables.erase(area)
	print("removed %s" % area.name)
