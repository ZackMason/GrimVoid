tool
extends Interactable
##############################################################
export var held := false
onready var _bullet = preload("res://Scenes/Game/Interactables/Weapons/Bullet.tscn")
export var run = false setget fire_bullet

var stats = {
	"damage": 10, 
	"range": 100, 
	"sprite": "res://Sprites/gun_001.png",
}

##############################################################

func fire_bullet(b=0):
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

func interact(node):
	if not held:
		node.pick_up(self)
		held = true
	else:
		fire()
	
func alt_interact(node):
	$Health.damage(-10.0)

##############################################################

func _process(delta):
	pass
	
func _ready():
	._ready()
	randomize()
	
	$RayCast2D.cast_to.x = stats["range"]
