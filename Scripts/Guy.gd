extends KinematicBody2D
class_name Guy

##############################################################
var velocity := Vector2.ZERO
export var move_speed := 5.0
onready var last_position := global_position
onready var _ray = $RayCast2D
var _room = null setget set_room
onready var _ship = $'..'

func set_room(room):
	_room = room

var path = []
##############################################################

func _ready():
#	get_parent().add_collision_exception_with(self)
	pass

func _unhandled_input(event):#_input(_event):
	if not DevConsole.get_node("CanvasLayer/Base/Slider/DevConsole").closed: 
		return
	
	if Input.is_action_just_pressed("open_inventory") and not $CanvasLayer/Inventory.visible:
		$CanvasLayer/Inventory.visible = true
	elif Input.is_action_just_pressed("close_inventory"):
		$CanvasLayer/Inventory.visible = false
	
	if Input.is_action_just_pressed("fire"):
		if is_holding():
			$HandPivot/Hands.get_child(0).interact(self)
	elif Input.is_action_just_pressed("alt_fire"):
		if is_holding():
			$HandPivot/Hands.get_child(0).alt_interact(self)
			
	elif Input.is_action_just_pressed("interact"):
		if not $InteractableArea.nearby_interactables.empty():
			$InteractableArea.nearby_interactables[0].interact(self);
		else:
			print("nothing to interact with...")
	elif Input.is_action_just_pressed("alt_interact"):
		if not $InteractableArea.nearby_interactables.empty():
			$InteractableArea.nearby_interactables[0].alt_interact(self);
		else:
			print("nothing to interact with...")

func is_holding():
	return $HandPivot/Hands.get_child_count() > 0
	
	
func _process(delta):
	if is_holding():
		var held_item = $HandPivot/Hands.get_child(0)
		if held_item:
			held_item.transform = Transform2D.IDENTITY
	
	var mp = to_local(get_global_mouse_position()).normalized()
	$HandPivot.rotation = atan2(mp.y, mp.x) + PI*0.5

#func _physics_process(delta):
	var input := Vector2.ZERO
	if DevConsole.get_node("CanvasLayer/Base/Slider/DevConsole").closed and not $CanvasLayer/Inventory.visible: 
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input *= 2.0
	if (input.y != 0.0 or input.x != 0.0):
		$AnimationPlayer.play("walk")
	input = input.normalized().rotated(global_rotation)
#	velocity += input.rotated(global_rotation) * move_speed
#
#	velocity = velocity.linear_interpolate(Vector2.ZERO, 1.0 - pow(0.00125, delta))

#	velocity = move_and_slide(velocity, Vector2.ZERO,
#					false, 4, PI/4, false)
	if not input.x and not input.y: return
	
	var distance_to_walk = move_speed * delta
	var desired_position = global_position + input * move_speed 
	var expected_distance = global_position.distance_to(desired_position)
	var nav = _ship.nav
	var p1 = nav.get_simple_path(nav.to_local(global_position), nav.to_local(desired_position),false)
	path = p1
	
#	if p1.empty() or p1[0].distance_to(p1[1]) < expected_distance and p2.size() > 1:
#		path = p2
#
	for p in path:
		p = position + p
	
	if path.size() > 1:
		position = path[1]
#		print(path)
	return
	
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

##############################################################

func add_to_inventory(item, amount):
	$CanvasLayer/Inventory.pickup_item(item.item_name, amount)

func pick_up(node):
	for n in $HandPivot/Hands.get_children():
		n.queue_free() 
	node.get_parent().remove_child(node)
	$HandPivot/Hands.add_child(node)
	node.position = Vector2.ZERO
	node.rotation = 0.0

##############################################################
func _on_RoomArea_area_entered(area):
	if not _room and area.is_in_group("room"): 
		print("entered room %s")
		_room = area.get_room()

#		if get_parent() != _room:
##			print("set room: %s" % _room.name)
#			var gt = global_transform
#			get_parent().call_deferred("remove_child", self)
#			_room.call_deferred("add_child", self)
#			set_deferred("global_transform", gt)
#
func _on_RoomArea_area_exited(area):
#	var b = [area.is_in_group("room")]
#	b.append(_room == area.get_room() if b[0] else false)
#	if not false in b:
##		print("left room")
##		var gt = global_transform
##		_room.call_deferred("remove_child", self)
##		_room.get_parent().call_deferred("add_child", self)
##		set_deferred("global_transform", gt)
	_room = null
