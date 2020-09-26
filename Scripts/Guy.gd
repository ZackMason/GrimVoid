extends KinematicBody2D
class_name Guy

##############################################################
var velocity := Vector2.ZERO
var move_speed := 5.0
onready var last_position := global_position
##############################################################
func _ready():
	pass

func _unhandled_input(event):
	if not DevConsole.get_node("CanvasLayer/Base/Slider/DevConsole").closed: 
		return
	
	if Input.is_action_just_pressed("fire"):
		if $HandPivot/Hands.get_child_count() > 0:
			$HandPivot/Hands.get_child(0).interact(self)
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

func _process(dt):
	var mp = to_local(get_global_mouse_position()).normalized()
	$HandPivot.rotation = atan2(mp.y, mp.x) + PI*0.5
	
	if abs($HandPivot.rotation) > PI/4.0:
		global_rotation = lerp_angle(global_rotation, $HandPivot.global_rotation, dt)
		pass
#	$Tween.interpolate_property(self, "global_rotation", global_rotation, \
#		$HandPivot.global_rotation,0.3,Tween.TRANS_EXPO,Tween.EASE_OUT_IN)
#	$Tween.start()

func _physics_process(delta):
	var input := Vector2.ZERO
	if DevConsole.get_node("CanvasLayer/Base/Slider/DevConsole").closed: 
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input *= 2.0
	if input.y != 0.0 or input.x != 0.0:
		$AnimationPlayer.play("walk")
	else:
		pass
#		$AnimationPlayer.stop()
		
	velocity += input.rotated(global_rotation) * move_speed
	
	velocity = velocity.linear_interpolate(Vector2.ZERO, 1.0 - pow(0.00125, delta))
	
	velocity = move_and_slide(velocity)
##############################################################

func pick_up(node):
	for n in $HandPivot/Hands.get_children():
		n.queue_free() 
	node.get_parent().remove_child(node)
	$HandPivot/Hands.add_child(node)
	node.position = Vector2.ZERO
	node.rotation = 0.0

##############################################################








