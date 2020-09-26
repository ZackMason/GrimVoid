extends Node2D
class_name Temp

export var temp := 75.0 setget set_temp

func set_temp(t):
	$Viewport/Control/ProgressBar.value = t
	temp = max(t, 0.0)

func _process(delta):
	set_temp(temp - delta)
	
func _ready():
	get_parent().add_to_group("heat")
	$Sprite.texture = $Viewport.get_texture()
