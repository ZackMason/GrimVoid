extends Interactable
##############################################################
export var powered_on := false
export var fill_rate := 8.0
onready var _power = $Power
##############################################################
func interact(_node):
	powered_on = not powered_on
	print("oxygenerator is %s" % ("on" if powered_on else "off"))
	
func alt_interact(_node):
	$Health.damage(-10.0)
##############################################################
func _process(delta):
	if not _room: 
		return
	if _power.value <= 0.0 and powered_on:
		powered_on = false
	if _room.oxygen < 100.50 and powered_on and $Health.value > 10.0:
		_room.oxygen += fill_rate * delta
		_power.value -= delta

func _ready():
	._ready()
	randomize()
	
func _on_Timer_timeout():
	if randf() < 0.15:
		$Health.damage(10.0)
