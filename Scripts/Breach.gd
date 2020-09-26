extends Interactable

##############################################################
export var drain_rate := 8.0

onready var _all_floors = get_node("../../Floors")

var repair_progress := 100.0

##############################################################

func interact(node):
	if randf() < 0.5:
		repair_progress -= 10.0
	if repair_progress <= 0.0:
		queue_free()
##############################################################

func _process(delta):
	if not _room: 
		queue_free() 
		return
	_room.oxygen -= drain_rate * delta

func _ready():
	._ready()
	randomize()
	var closest_dist = INF
	for room in _all_floors.get_children():
		var d = global_position.distance_to(room.global_position)
		if d < closest_dist:
			closest_dist = d
			_room = room
