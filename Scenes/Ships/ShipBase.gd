extends RigidBody2D
class_name ShipBase

export var ship_name := 'Arrowhead'

onready var rooms = $Rooms.get_children()
onready var doors = $Doors.get_children()
onready var subsystems = $Subsystems.get_children()
onready var engines = $Engines.get_children()
onready var pilots = $FlightControl.get_children()
onready var weapons = $Weapons.get_children()
onready var nav = $RoomNav as Navigation2D
onready var hall_nav = $HallNav as Navigation2D

var navs_to_add = []

func _process(delta):
	for n in navs_to_add:
		if (n.size() < 3) or true:
#			print("adding room %s" % n[0].name)
			nav.add_child(n[0])  
		else:
#			print("adding hall %s" % n[0].name)
			nav.add_child(n[0])
		n[0].global_transform = n[1]
	if not navs_to_add.empty():
		navs_to_add = []

	var force := Vector2.ZERO
	for e in engines:
		if e.powered_on:
			force += Vector2.UP.rotated(e.global_rotation) * e.thrust_power
	set_applied_force(force)

#func _enter_tree():
#	load_ship()
#
#func _exit_tree():
#	save()

func save():
	var data = inst2dict(self)
	var file = File.new()
	file.open("res://Save/ship_save.json", File.WRITE)
	file.store_string(JSON.print(data))
	file.close()
	
var loaded = false

func load_ship():
	if loaded: return
	loaded = true
	var file = File.new()
	if not file.file_exists("res://Save/ship_save.json"): return
	file.open("res://Save/ship_save.json", File.READ)
	var data = JSON.parse(file.get_as_text()).result
	var inst = dict2inst(data)
	get_parent().add_child(inst)
	inst.global_transform = global_transform
	queue_free()
	inst.loaded = true
