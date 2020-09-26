extends RigidBody2D
export var control = true

func _process(delta):
	if control: return
	if Input.is_action_just_pressed("alt_interact"):
		detach()

func detach():
		var pp = get_parent().get_parent()
		var vel = get_parent().linear_velocity if get_parent() is RigidBody2D else Vector2.ZERO
		var pos = global_position
		if vel:
			linear_velocity = vel
		if not pp:
			pp = get_parent()
		get_parent().remove_child(self)
		pp.add_child(self)
		global_position = pos
	
	
func _physics_process(delta):
	if not control: return
	var input := Vector2.ZERO
	if DevConsole.get_node("CanvasLayer/Base/Slider/DevConsole").closed: 
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input *= 2.0 * 15.0
	
	add_force(Vector2.ZERO, input)
	
	
func _ready():
	pass
