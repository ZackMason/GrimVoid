extends Interactable
class_name Machine

onready var _power = $Power
onready var _health = $Health

export var powered_on = true setget set_powered_on
func set_powered_on(s):
	powered_on = s
	on_powered_on(s)

func on_powered_on(s):
	pass
	
export var power_drain_rate = 6.0

export var strength = 6.0

func do(_dt):
#	print("implement machine function")
	pass
	
func interact(_node):
	powered_on = not powered_on
	var state = "on" if powered_on else "off"
	print("Machine: %s is %s" % [name, state])

func alt_interact(_node):
	_health.damage(-10)
	
func power_update(dt):
	if not _power: return false
	return _power.try_deplete(dt * power_drain_rate)

func _process(delta):
	if powered_on and power_update(delta): do(delta)
