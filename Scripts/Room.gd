extends KinematicBody2D
class_name Room

onready var _ship = get_node("../../..")

var oxygen := 100.0 setget set_oxygen, get_oxygen
func get_oxygen():
	return $Oxygen.oxygen
func set_oxygen(ox):
	$floor_001.self_modulate = Color(1.0, ox/100.0, ox/100.0, 1.0)
	$Oxygen.oxygen = ox

var temp := 100.0 setget set_temp , get_temp
func get_temp():
	return $Temp.temp
func set_temp(ox):
	$Temp.temp = ox

var power := 100.0 setget set_power , get_power
func get_power():
	return $Power.power
func set_power(ox):
	$Power.power = ox
	power = ox

func _process(delta):
	set_oxygen($Oxygen.oxygen - delta * .5)
	pass
