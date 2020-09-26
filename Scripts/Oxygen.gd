extends Node2D
class_name Oxygen

export var oxygen := 100.0 setget set_oxygen

func set_oxygen(ox):
	oxygen = clamp(ox, 0.0, $Viewport/RadialProgressBar.max_value - 0.01)
	$Viewport/RadialProgressBar.value = oxygen
	$Viewport/Control/ProgressBar.value = oxygen

func _ready():
	get_parent().add_to_group("oxygen")
	$Sprite2.texture = $Viewport.get_texture()
	set_oxygen(oxygen)
