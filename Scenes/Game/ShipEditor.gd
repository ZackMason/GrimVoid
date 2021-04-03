extends Node2D

var edit_mode = false

func _input(_event):
	if Input.is_action_just_pressed("edit_mode"):
		edit_mode = not edit_mode
		$UI/ColorRect.visible = edit_mode
