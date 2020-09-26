extends Interactable
##############################################################
var held = null
var grappled = null
onready var _bullet = preload("res://Scenes/Game/Interactables/Weapons/Bullet.tscn")
export var run = false setget fire_bullet

var stats = {
	"damage": 10, 
	"range": 100, 
	"sprite": "res://Sprites/gun_001.png",
	"fire_method" : "fire",
	"alt_fire_method" : "grapple",
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
func _ready():
	._ready()
	randomize()
	$RayCast2D.cast_to.x = stats["range"]
