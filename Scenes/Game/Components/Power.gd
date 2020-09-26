extends Node2D
class_name Power

export var power := 100.0 setget set_power

func set_power(ele):
	$Viewport/Control/ProgressBar.value = ele
	power = max(ele, 0.0)

func _ready():
	get_parent().add_to_group("power")
	$Sprite.texture = $Viewport.get_texture()
