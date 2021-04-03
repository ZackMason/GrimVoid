tool
extends Machine

var room_a = null
var room_b = null

var disabled = false

export var sealed = false setget set_sealed
export var seal_breaks = false

var connected = false
onready var shape = $door_001/DoorNav

export var door_length = 1.0 setget set_door_length
var base_scale = Vector2(0.391,0.391)

func set_door_length(v):
	door_length = v
	$CollisionShape2D.scale.y = v
	$door_001.scale.y = door_length * base_scale.y
	
func set_sealed(x):
	sealed = x
	if not sealed and room_a and room_b and not connected:
#		connect_rooms()
		pass
	elif seal_breaks and sealed and connected:
		pass
#		disconnect_rooms()

export var oxygen_flow_rate = 6.0
export var temp_flow_rate = 3.0
##############################################################
func _ready():
	._ready()
	$door_001.visible = not sealed
	
#	return
	if not Engine.editor_hint:
		var _ship = get_parent().get_parent()
		assert(_ship is ShipBase)
		var gt = shape.global_transform
		var ns = shape.duplicate()
		_ship.navs_to_add.append([ns, gt, true])
		shape.enabled = false
		
#	connect("connection_changed", RoomConnections, "reparent")

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if connected and room_a and room_b:
#			disconnect_rooms()
			pass

func do(dt):
	pass

##############################################################

func alt_interact(_node):
	set_sealed(not sealed)
	$door_001.visible = not sealed


## bug here somewhere
func interact(node):
	if sealed:
		print("the door is sealed")
		return
	
	var entrances = $door_001/Entrances.get_children()
	var closest = null #entrances[0]
	var next_closest = null
	var cd = INF
	var nd = INF
	for i in range(0,entrances.size()):
		var e = entrances[i]
		var d = e.global_position.distance_to(node.global_position)
		if d < cd:
			next_closest = closest
			closest = e
			nd = cd
			cd = d
		elif d < nd:
			nd = d
			next_closest = e

	if cd < 4.0:
		node.global_position = next_closest.global_position
	return
	
	var closest_node = $ExitA
	var farthest_node = $ExitB
	if node.global_position.distance_to(closest_node.global_position) > node.global_position.distance_to($ExitB.global_position):
		farthest_node = $ExitA
		closest_node = $ExitB
	
	node.global_position = farthest_node.global_position
