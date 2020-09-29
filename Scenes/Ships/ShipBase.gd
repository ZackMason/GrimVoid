extends RigidBody2D
class_name ShipBase

export var ship_name := 'Arrowhead'

onready var rooms = $Rooms.get_children()
onready var doors = $Doors.get_children()
onready var subsystems = $Subsystems.get_children()
onready var engines = $Engines.get_children()
onready var pilots = $FlightControl.get_children()


func _ready():
	pass
