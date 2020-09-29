extends Interactable
##############################################################
var held = null
var grappled = null
onready var _bullet = preload("res://Scenes/Game/Interactables/Weapons/Bullet.tscn")
export var run = false setget fire_bullet

var stats = {
	"damage": 10, 
	"range": 200, 
	"sprite": "res://Sprites/gun_001.png",
	"fire_method" : "fire",
	"alt_fire_method" : "wireA",
}

##############################################################

func fire_bullet(_b=0):
	var nb = _bullet.instance()
	add_child(nb)
	nb.position = $RayCast2D.position

func fire():
	fire_bullet()
	if $RayCast2D.is_colliding():
		var b = $RayCast2D.get_collider()
		print(b.name)
		if b.is_in_group("health"):
			b.get_node("Health").damage(stats["damage"])

onready var _s = $Spring


var first_hit = null
var first_body = null
var second_hit = null
var second_body = null
onready var active_wire = $Wire

func wireA():
	var collision = $RayCast2D.is_colliding()
	var p = $RayCast2D.get_collision_point()
	var b = $RayCast2D.get_collider()
	if first_hit == null:
		if collision:
			remove_child(active_wire)
			held.get_parent().add_child(active_wire)
			active_wire.visible = true
			if b.is_in_group("power"):
				first_body = b
			first_hit = active_wire.to_local(p)
			active_wire.pin_start = first_hit
			active_wire.pin_end = active_wire.to_local($RayCast2D.global_position)
			active_wire.fix()
	elif second_hit == null:
		if collision:
			if b.is_in_group("power"):
				second_body = b
			second_hit = active_wire.to_local(p)
			active_wire.pin_end = second_hit
				
			if first_body and second_body and first_body != second_body:
				RoomConnections.wires.append([first_body.get_node('Power'), second_body.get_node('Power'), active_wire])
		
			active_wire = _wire.duplicate()
			add_child(active_wire)
			
			first_hit = null
			second_hit = null
			$Wire.visible = false

func grapple():
	if not grappled:
		fire_bullet()
		if $RayCast2D.is_colliding():
			var b = $RayCast2D.get_collider()
			if b is RigidBody2D:
				grappled = true
				_s.node_a = held.get_path()
				_s.node_b = b.get_path()
	else:
		grappled = false
		_s.node_a = ""
		_s.node_b = ""

func interact(node):
	if not held:
		node.pick_up(self)
		held = node
		remove_child(_s)
		node.add_child(_s)
		disable_room_ownership = true
	else:
		call(stats["fire_method"])
	
func alt_interact(_node):
	if not held:
		$Health.damage(-10.0)
	else:
		call(stats["alt_fire_method"])
	
##############################################################
onready var _wire = $Wire.duplicate()

func _process(_d):
	if first_hit:
		active_wire.pin_end = active_wire.to_local($RayCast2D.global_position)

func _ready():
	._ready()
	randomize()
	$RayCast2D.cast_to.x = stats["range"]
