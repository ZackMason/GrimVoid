extends Node2D
class_name Temp

export var temp := 75.0 setget set_temp

func set_temp(t):
	temp = clamp(t, 0.0, $Viewport/RadialProgressBar.max_value - 0.01)
	$Viewport/Control/ProgressBar.value = temp
	$Viewport/RadialProgressBar.value = temp
	
func _process(delta):
	set_temp(temp - delta)
	
func _ready():
	get_parent().add_to_group("heat")
	$Sprite2.texture = $Viewport.get_texture()
	$Viewport/RadialProgressBar.value = temp
	set_temp(temp)
