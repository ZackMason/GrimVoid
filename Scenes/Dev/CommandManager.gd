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
	["select_group", [ARG_STRING], "prints all nodes in a group that are on a ship"],
	["repair_all", [], "heals everything to full health"],
	["energize", [], "restores everything to full power"],
]

func select_group(group):
	var guy = get_tree().get_nodes_in_group("guy")[0]
	var nodes = guy._room.all_nodes_in_group(group)
	for n in nodes:
		console.output_text("%s" % n.name)
	
func ship_rooms():
	var guy = get_tree().get_nodes_in_group("guy")[0]
	guy._room.print_all_rooms()
	
	

func energize():
	for power in get_tree().get_nodes_in_group("power"):
		var p = power.get_node("Power")
		p.power = 100

func repair_all():
	for health in get_tree().get_nodes_in_group("health"):
		var hp = health.get_node("Health")
		hp.health = hp.max_health

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
