extends Node2D
class_name Power

export var power := 100.0 setget set_power

func set_power(ele):
	power = clamp(ele, 0.0, $Viewport/RadialProgressBar.max_value - 0.01)	
	$Viewport/Control/ProgressBar.value = power
	$Viewport/RadialProgressBar.value = power

func _ready():
	get_parent().add_to_group("power")
	$Sprite2.texture = $Viewport.get_texture()
	set_power(power)
