extends Interactable

##############################################################
export var drain_rate := 8.0

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
