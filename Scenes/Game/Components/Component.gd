extends Node2D
class_name Component

export var component_name := ""
export var component_color := Color(1.0,0.0,0.0)
export var free_on_depleted := false

export(int) var max_value = 100 setget set_max_value
onready var value = max_value setget set_value

func set_max_value(val):
	var value_difference = val - max_value
	
	if value_difference >= 0:
		value += value_difference
	else:
		value = max(value, val)
	
	max_value = val
	_pb.max_value = max_value

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
	_pb.bar_color = component_color
	_pb.border_color = Color.black
	
func damage(amount: float) -> bool:
	set_value(value - amount)
	if value <= 0 and free_on_depleted:
		if get_parent().is_in_group("rigid"):
			get_parent().unparent_room_contents()
		get_parent().queue_free()

	return value <= 0
