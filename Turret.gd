extends Interactable

var pilot = null
var pilot_parent = null
var pilot_position = Vector2.ZERO
var need_to_rotate = true

onready var shot = preload("res://Scenes/Game/Interactables/Weapons/CannonShot.tscn")

onready var power = $Power

func fire():
	if power.value < 10.0: return
	power.value -= 10.0
	var dir = -get_global_mouse_position().direction_to(global_position)
	
	if dir.dot(Vector2.UP.rotated($turret_base_001/Pivot.global_rotation)) < 0.965:
		return
	var s = shot.instance()
	var w = get_tree().get_nodes_in_group("world")[0]
	w.add_child(s)
	s.dir = dir
	s.global_position = $turret_base_001/Pivot/FirePoint.global_position
	
func _process(_delta):
	last_dt = _delta
	if not _room: need_to_rotate = true
	
	if _room and need_to_rotate:
		need_to_rotate = false
		var dir = global_position.direction_to(_room.global_position)
		var theta = atan2(dir.y, dir.x) - PI/2.0
		global_rotation = theta 

	if not pilot: return
	if Input.is_action_just_pressed("fire") and _room:
		fire()
		
	if Input.is_action_just_pressed("ui_cancel"):
		(pilot_parent if pilot_parent else get_tree().get_nodes_in_group("world")[0]).add_child(pilot)
		pilot.global_position = to_global(pilot_position)
		pilot.global_rotation = _room.global_rotation
		pilot._room = null
		pilot = null
#		get_tree().get_nodes_in_group("darkness")[0].visible = true
		$Light2D.visible = false
		
	if not _room: return
	
	operate()

var last_dt = 0.0
func operate():
	var m = get_local_mouse_position()
	var theta = atan2(m.y, m.x)
	if theta < 0.0 and power.value > last_dt:
		theta += PI/2.0
		if rad2deg(abs(rotation - theta)) > 10.0: 
			power.value -= last_dt
		$Tween.interpolate_property($turret_base_001/Pivot,"rotation", $turret_base_001/Pivot.rotation, theta, 0.052,Tween.TRANS_EXPO,Tween.EASE_IN_OUT)
		$Tween.start()
		
func alt_interact(_node):
	$Health.damage(-10)

func interact(node):
	pilot = node
	pilot_parent = pilot.get_parent()
	pilot_position = to_local(node.global_position)
	pilot_parent.remove_child(node)
	node._room = self
#	get_tree().get_nodes_in_group("darkness")[0].visible = false
	$Light2D.visible = true
