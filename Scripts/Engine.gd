extends Interactable

##############################################################
#onready var _all_floors = get_node("../../Floors")
#onready var _ship = get_node("../../..")

export var power_drain_rate := 2.0
export var temp_exhaust_rate := 5.0
export var engine_thrust := 80.0

var time = 15.0
##############################################################

func power(state):
	if not _room:
		print("engine is not connected to a room, it needs power")
		return
	if _room.power < 10.0:
		$engine_001/flame_001.visible = false
		return
	$engine_001/flame_001.visible = state
	
func alt_interact(node):
	power(not $engine_001/flame_001.visible)
	
func interact(node):
	if randf() < 0.5:
		$Health.damage(-10)

##############################################################

func _process(delta):
	if $engine_001/flame_001.visible:
		_room.temp += temp_exhaust_rate * delta
		_room.power -= power_drain_rate * delta
		if _room.power < 10.0:
			_room.temp += temp_exhaust_rate # discharge heat into the room
			power(false)
			return
		if _room.is_in_group("rigid"):
			var r := _room as RigidBody2D
			r.add_force(r.to_local(global_position), delta*engine_thrust*Vector2.UP.rotated(global_rotation))
		else:
#			_ship.velocity.y += -delta * engine_thrust
			pass
		time -= delta
		if time <= 0.0:
			time = 15.0
			if randf() < 0.5:
				$Health.damage(10)

func _ready():
	._ready()
	randomize()
