extends Interactable
##############################################################
export var powered_on := false
export var fill_rate := 8.0

##############################################################
func interact(node):
	powered_on = not powered_on
	if not _room:
		print("this generator in not in a room")
	print("oxygenerator is %s" % ("on" if powered_on else "off"))
	
func alt_interact(node):
	$Health.damage(-10.0)
##############################################################
func _process(delta):
	if not _room: 
		return
	if _room.power <= 0.0 and powered_on:
		powered_on = false
	elif _room.oxygen < 100.50 and powered_on and $Health.health > 10.0:
		_room.oxygen += fill_rate * delta
		_room.power -= delta

func _ready():
	._ready()
	randomize()
	
func _on_Timer_timeout():
	if randf() < 0.5:
		$Health.damage(10.0)
