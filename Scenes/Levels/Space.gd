tool
extends Sprite

func _ready():
	material = material.duplicate()

func _process(_delta):
	material.set_shader_param("global_transform", get_global_transform())
	material.set_shader_param("camera_position", get_tree().get_nodes_in_group("camera")[0].global_position)
