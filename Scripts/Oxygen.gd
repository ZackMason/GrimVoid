extends Node2D
class_name Oxygen


export var oxygen := 100.0 setget set_oxygen

func set_oxygen(ox):
	$Viewport/Control/ProgressBar.value = ox
	oxygen = max(ox, 0.0)

func _ready():
	get_parent().add_to_group("oxygen")
	$Sprite.texture = $Viewport.get_texture()
