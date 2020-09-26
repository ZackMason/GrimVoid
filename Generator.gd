extends Interactable

##############################################################
export var powered_on := true
export var fill_rate := 8.0
export var exhaust_rate := 1.0

##############################################################
func interact(_node):
	powered_on = not powered_on
	print("generator is %s" % ("on" if powered_on else "off"))
	
func alt_interact(_node):
	$Health.damage(-10.0)
##############################################################
func _process(delta):
	if not _room: return
	if _room.power < 100.50 and powered_on and $Health.value > 10.0:
		_room.power += fill_rate * delta
		_room.temp += exhaust_rate * delta

func _ready():
	._ready()
	randomize()
	
func _on_Timer_timeout():
	if randf() < 0.5:
		$Health.damage(10.0)
