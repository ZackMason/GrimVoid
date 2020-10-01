extends Node2D
class_name Component

export var component_name := ""
export var component_color := Color(1.0,0.0,0.0)
export var free_on_depleted := false

export(int) var max_value = 100 setget set_max_value
export(int) var start_value = 0
onready var value = min(max_value, start_value) setget set_value

func set_max_value(val):
	var value_difference = val - max_value
	
	if value:
		if value_difference >= 0:
			value += value_difference
		else:
			value = max(value, val)
	
	max_value = val
	$Viewport/RadialProgressBar.max_value = max_value

func set_value(val):
	val = clamp(val, 0.0, _pb.max_value-0.01)
	value = val
	_pb.value = value
	_l.text = "%d" % ceil(value)
	
onready var _pb = $Viewport/RadialProgressBar
onready var _l = $Viewport/RadialProgressBar/Label

func _ready():
	$Icon.queue_free()
	get_parent().add_to_group(component_name)
	set_max_value(max_value)
	set_value(value)
	$Sprite.texture = $Viewport.get_texture()
	_pb.tint_progress = component_color
#	_pb.bar_color = component_color
#	_pb.border_color = Color.black
	
func try_deplete(amount: float) -> bool:
	if value >= amount:
		set_value(value - amount)
		return true
	return false
	
func damage(amount: float) -> bool:
	set_value(value - amount)
	if value <= 0 and free_on_depleted:
		if get_parent().has_method("on_death"):
			get_parent().call("on_death")
		if get_parent().is_in_group("rigid"):
			get_parent().unparent_room_contents()
		get_parent().queue_free()

	return value <= 0


func _on_VisibilityNotifier2D_screen_entered():
	$Viewport/RadialProgressBar.visible = true

func _on_VisibilityNotifier2D_screen_exited():
	$Viewport/RadialProgressBar.visible = false
