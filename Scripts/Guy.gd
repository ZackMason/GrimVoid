extends KinematicBody2D
class_name Guy

##############################################################
var velocity := Vector2.ZERO
var move_speed := 5.0
onready var last_position := global_position
var _room = null setget set_room

export var enter_room = true

func set_room(room):
	_room = room
	if not enter_room: return
	if room == null and is_inside_tree():
		var gt = global_transform
		var w = get_tree().get_nodes_in_group("world")[0]
		get_parent().call("remove_child", self)
		w.get_parent().call("add_child", self)
		set_deferred("global_transform", gt)

##############################################################

func _ready():
	pass

func _input(_event):
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
	
func _process(_dt):
	if is_holding():
		var held_item = $HandPivot/Hands.get_child(0)
		if held_item:
			held_item.transform = Transform2D.IDENTITY
	
	var mp = to_local(get_global_mouse_position()).normalized()
	$HandPivot.rotation = atan2(mp.y, mp.x) + PI*0.5
	
	
	if abs($HandPivot.rotation) > PI/4.0:
#		global_rotation = lerp_angle(global_rotation, $HandPivot.global_rotation, dt)
		pass
	
func _physics_process(delta):
	var input := Vector2.ZERO
	if DevConsole.get_node("CanvasLayer/Base/Slider/DevConsole").closed and not $CanvasLayer/Inventory.visible: 
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input *= 2.0
	if (input.y != 0.0 or input.x != 0.0) and _room:
		$AnimationPlayer.play("walk")
	else:
		pass
#		$AnimationPlayer.stop()
		
	velocity += input.rotated(global_rotation) * move_speed
	
	velocity = velocity.linear_interpolate(Vector2.ZERO, 1.0 - pow(0.00125, delta))
	
	velocity = move_and_slide(velocity, Vector2.ZERO,
					false, 4, PI/4, false)
					
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider is RigidBody2D:
#			collision.collider.apply_central_impulse(-collision.normal * 100)
#
##############################################################

func add_to_inventory(item):
	$CanvasLayer/Inventory.pickup_item(item.item_name)

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
#		print("entered room")
		_room = area.get_room()
		
		if get_parent() != _room:
#			print("set room: %s" % _room.name)
			var gt = global_transform
			get_parent().call_deferred("remove_child", self)
			_room.call_deferred("add_child", self)
			set_deferred("global_transform", gt)

func _on_RoomArea_area_exited(area):
	var b = [area.is_in_group("room")]
	b.append(_room == area.get_room() if b[0] else false)
	if not false in b:
#		print("left room")
#		var gt = global_transform
#		_room.call_deferred("remove_child", self)
#		_room.get_parent().call_deferred("add_child", self)
#		set_deferred("global_transform", gt)
		_room = null
