extends Node2D
class_name Health

export(int) var max_health = 100 setget set_max_health
func set_max_health(hp):
	var health_difference = hp - max_health
	
	if health_difference >= 0:
		health += health_difference
	else:
		health = max(health, hp)
	
	max_health = hp
	_pb.max_value = max_health

onready var health = max_health setget set_health
func set_health(hp):
	hp = min(hp, max_health)
	health = hp
	_pb.value = health

onready var _pb = $Viewport/RadialProgressBar

func _process(_delta):
#	$HealthBar.global_rotation = 0.0
	pass

func _ready():
	get_parent().add_to_group("health")
	set_max_health(max_health)
	set_health(health)
	$Sprite.texture = $Viewport.get_texture()

func damage(amount: float) -> bool:
	set_health(health - amount)
	if health <= 0:
		if get_parent().is_in_group("rigid"):
			get_parent().unparent_room_contents()
		get_parent().queue_free()
		
	return health <= 0
