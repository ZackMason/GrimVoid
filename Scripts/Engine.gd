extends Interactable

##############################################################
#onready var _all_floors = get_node("../../Floors")
#onready var _ship = get_node("../../..")

export var power_drain_rate := 6.0
export var temp_exhaust_rate := 5.0
export var engine_thrust := 26.0

var time = 15.0

var force := Vector2.ZERO
onready var _power = $Power
##############################################################

func power(state):
	if not _room:
		print("engine is not connected to a room, it needs power")
		return false
	if _power.value < 10.0:
		$engine_001/flame_001.visible = false
		return false
	$engine_001/flame_001.visible = state
	var v = engine_thrust as float * Vector2.UP.rotated(global_rotation)
	force = v
	
	return state
	
func alt_interact(_node):
	power(not $engine_001/flame_001.visible)
	
func interact(_node):
	if randf() < 0.5:
		$Health.damage(-10)

##############################################################

func _physics_process(delta):
	if $engine_001/flame_001.visible:
		if _room:
			_room.temp += temp_exhaust_rate * delta
			_power.value -= power_drain_rate * delta
			if _power.value < 10.0:
				_room.temp += temp_exhaust_rate # discharge heat into the room
				power(false)
				return
			
			var v = delta * engine_thrust as float * Vector2.UP.rotated(global_rotation)
#			force = v
#			_room.top_body().add_force(Vector2.ZERO, v)

#			_room.top_body().set_applied_force(_room.top_body().applied_force + v)
		else:
			$engine_001/flame_001.visible = false
			
		time -= delta
		if time <= 0.0:
			time = 15.0
			if randf() < 0.5:
				$Health.damage(10)

func _ready():
	._ready()
	randomize()
