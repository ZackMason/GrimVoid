extends RigidBody2D
class_name RigidRoom

func attach(node):
	get_parent().remove_child(self)
	node.add_child(self)
	linear_velocity = linear_velocity - get_parent().linear_velocity if get_parent() is RigidBody2D else linear_velocity
	
func detach():
		var pp = get_parent().get_parent()
		var vel = get_parent().linear_velocity if get_parent() is RigidBody2D else Vector2.ZERO
		var pos = global_position
		if vel:
			linear_velocity = vel
		if not pp:
			pp = get_parent()
		get_parent().remove_child(self)
		pp.add_child(self)
		global_position = pos

var oxygen := 100.0 setget set_oxygen, get_oxygen
func get_oxygen():
	return $Oxygen.oxygen
func set_oxygen(ox):
	$Floor.self_modulate = Color(1.0, ox/100.0, ox/100.0, 1.0)
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
