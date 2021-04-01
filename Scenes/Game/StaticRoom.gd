extends StaticBody2D

onready var _shapes = [$CollisionShape2D, $CollisionShape2D2, $CollisionShape2D3, $CollisionShape2D4, $NavigationPolygonInstance] 

var _cached_ship_shape = []

func add_shapes_to_ship():
#	return
	var _ship = get_parent().get_parent()
	assert(_ship is ShipBase)
	for shape in _shapes:
		var gt = shape.global_transform
		var ns = shape.duplicate()
		if shape is CollisionShape2D:
			_ship.call_deferred('add_child', ns)
			ns.set_deferred('global_transform', gt)
#			shape.position -= shape.position.normalized()
			shape.scale.x += .5
			_cached_ship_shape.append(ns)
#			shape.disabled = true
		elif shape is NavigationPolygonInstance:
			_ship.navs_to_add.append([ns, gt])
			shape.enabled = false
#		print("disabling shape")
	
#	var ngt = global_transform
#	var n = _nav.duplicate()
#	_ship.call_deferred('add_child', _nav.duplicate())
#	n.set_deferred('global_transform', gt)
#
func _ready():
	add_shapes_to_ship()

func get_nav():
	return $Navigation2D

func on_death():
	for s in _cached_ship_shape:
		s.queue_free()
	print("destroyed room: %s" % name)
