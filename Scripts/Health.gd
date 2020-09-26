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

onready var _pb = $Viewport/Control/ProgressBar

func _ready():
	get_parent().add_to_group("health")
	set_max_health(max_health)
	set_health(health)
	$HealthBar.texture = $Viewport.get_texture()

func damage(amount: float) -> bool:
	set_health(health - amount)
	if health <= 0:
		get_parent().queue_free()
		
	return health <= 0
