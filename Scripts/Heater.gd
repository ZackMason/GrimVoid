extends Interactable
##############################################################
export var powered_on := false
export var fill_rate := 8.0
##############################################################

func interact(node):
	powered_on = not powered_on
	print("heater is %s" % ("on" if powered_on else "off"))

func alt_interact(node):
	$Health.damage(-10.0)

##############################################################

func _process(delta):
	if not _room: return
	if _room.temp < 75.50 and powered_on and $Health.health > 10.0 and _room.power > 10.0:
		_room.temp += fill_rate * delta
		_room.power -= delta

func _ready():
	._ready()
	randomize()

func _on_Timer_timeout():
	if randf() < 0.5:
		$Health.damage(10.0)
