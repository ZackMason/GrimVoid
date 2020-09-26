extends Area2D
class_name InteractableArea

var nearby_interactables := []


func _on_InteractableArea_area_entered(area):
	nearby_interactables.push_back(area)
	print("added %s" % area.name)

func _on_InteractableArea_area_exited(area):
	var i = nearby_interactables.find(area)
	if i >= 0:
		nearby_interactables.remove(i)
		print("removed %s" % area.name)
