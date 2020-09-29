extends Interactable
class_name Machine

onready var _power = $Power
onready var _health = $Health

export var powered_on = true
export var power_drain_rate = 6.0

export var strength = 6.0

func do(dt):
	print("implement machine fnuction")
	
func interact(node):
	powered_on = not powered_on
	var state = "on" if powered_on else "off"
	print("Machine: %s is %s" % [name, state])

func alt_interact(node):
	_health.damage(-10)
	
func power_update(dt):
	return _power.try_deplete(dt * power_drain_rate)

func _process(delta):
	if powered_on and power_update(delta): do(delta)
