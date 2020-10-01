extends Machine

onready var _ship = $'../..'
onready var _flame = $engine_001/flame_001

export var thrust_power = 26

func _process(delta):
	$engine_001/flame_001.visible = powered_on

func do(dt):
	pass
