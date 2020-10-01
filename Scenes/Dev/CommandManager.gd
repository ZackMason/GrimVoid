extends Control

onready var console = get_parent()

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT,
}

func arg_enum_to_string(arg):
	match arg:
		0:
			return "int"
		1:
			return "string"
		2:
			return "bool"
		3:
			return "float"
		_:
			return "unknown"

var commands = [
	["help", [ARG_STRING], "command(opt) - lists available commands or a commands description"],
	["rand", [], "prints a random number between 0-9"],
	["ship_rooms", [], "prints ship rooms"],
	["all_rooms", [], "prints all rooms"],
	["all_bodies", [], "prints all bodies"],
	["make_ships", [], "prints all bodies"],
	["rename_room", [ARG_STRING], "renames a ship room"],
	["select_group", [ARG_STRING], "prints all nodes in a group that are on a ship"],
	["repair_all", [], "heals everything to full health"],
	["energize", [], "restores everything to full power"],
	["spaghettify", [], "connects wires"],
	["refill_component", [ARG_STRING], "restores a component to full"],
]

var _wire = preload("res://Scenes/Game/Wire.tscn")

func spaghettify():
	console.output_text("connecting Subsystems within: %f units..." % 69.0)
	var guy = get_tree().get_nodes_in_group("guy")[0]
	var power_nodes = get_tree().get_nodes_in_group("power")
	for n1 in power_nodes:
		for n2 in power_nodes:
			if n1 == n2: continue
			if n1.global_position.distance_to(n2.global_position) < 69.0:
				var w = _wire.instance()
				guy.get_parent().add_child(w)
#				guy._room.top_body().add_child(w)
				var x = randf() * 2.0 - 1.0
				var y = randf() * 2.0 - 1.0
				w.pin_start = w.to_local(n1.global_position) + Vector2(x,y) * 5.0
				x = randf() * 2.0 - 1.0
				y = randf() * 2.0 - 1.0
				w.pin_end = w.to_local(n2.global_position) + Vector2(x,y) * 5.0
				w.fix()
				RoomConnections.wires.append([n1.get_node('Power'), n2.get_node('Power'), w])
				
func select_group(group):
	var guy = get_tree().get_nodes_in_group("guy")[0]
	var nodes = guy._room.all_nodes_in_group(group)
	for n in nodes:
		console.output_text("%s" % n.name)
	
func rename_room(n):
	var guy = get_tree().get_nodes_in_group("guy")[0]
	guy._room.name = n
	
func all_bodies():
	for r in RoomConnections.get_all_single_bodies():
		console.output_text("-------")
		for x in r:
			console.output_text("%s" % x.name)
			
			
func make_ships():
	RoomConnections.reparent()

func all_rooms():
	for r in RoomConnections.all_rooms:
		console.output_text("%s" % r.name)
	
	
func ship_rooms():
	var _guy = get_tree().get_nodes_in_group("guy")[0]
	var rooms = RoomConnections.get_all_connected_rooms(_guy._room)
	for r in rooms:
		console.output_text("%s" % r.name)
	
#	select_group("rigid")
	
func refill_component(comp: String):
	get_tree().call_group(comp, "damage", -10000000.0)
	

#	for power in get_tree().get_nodes_in_group(comp):
#		comp = comp.substr(0,1).to_upper() + comp.substr(1, comp.length()-1)
#		var p = power.get_node(comp)
#		p.value = 100

func energize():
	for power in get_tree().get_nodes_in_group("power"):
		var p = power.get_node("Power")
		p.value = 100

func repair_all():
	for health in get_tree().get_nodes_in_group("health"):
		var hp = health.get_node("Health")
		hp.value = hp.max_value

func rand():
	console.output_text("%d" % rand_range(0,10))

func help(opt_cmd: String = ""):
	for command in commands:
		if opt_cmd != "":
			if opt_cmd == command[0]:
				console.output_text("%s(%s) - %s" % command)
				return
		else:
			var params = []
			for p in command[1]:
				params.push_back(arg_enum_to_string(p))
			console.output_text("%s, params: %s" % [command[0], params])
