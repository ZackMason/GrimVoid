extends TextureButton

signal type_changed(type)

var hovered = false

var connections := []

enum TYPE {
	SENSOR = 0, 
	MODULE = 1, 
	TRIGGER = 2,
	MOD_EVENT = 3, 
	ALT_TRIGGER = 4, 
	SIZE
}

# to - from
const valid_connections := {
	TYPE.SENSOR: [TYPE.MODULE, TYPE.TRIGGER],
	TYPE.MODULE: [TYPE.MOD_EVENT],
	TYPE.MOD_EVENT: [TYPE.MODULE],
	TYPE.TRIGGER: [TYPE.MODULE],
	TYPE.ALT_TRIGGER: [TYPE.MODULE],
	TYPE.SIZE: [],
}

const type_names := {
	TYPE.SENSOR: "Sensor",
	TYPE.MODULE: "Module",
	TYPE.MOD_EVENT: "ModEvent",
	TYPE.TRIGGER: "Trigger",
	TYPE.ALT_TRIGGER: "AltTrig",
	TYPE.SIZE: "Invalid",
}

const type_colors := {
	TYPE.SENSOR: Color.yellow,
	TYPE.MODULE: Color.cadetblue,
	TYPE.MOD_EVENT: Color.blueviolet,
	TYPE.TRIGGER: Color.red,
	TYPE.ALT_TRIGGER: Color.orange,
	TYPE.SIZE: Color.pink,
}

const type_default := {
	TYPE.SENSOR: "power_off",
	TYPE.MODULE: "bullet",
	TYPE.MOD_EVENT: "on_hit",
	TYPE.TRIGGER: "trigger_pulled",
	TYPE.ALT_TRIGGER: "trigger_pulled",
	TYPE.SIZE: "error",
}

onready var vfunc = type_default[pin_type]

func on_hit():
	print('hit event triggered')
	
func fire_bullet():
	print('bang')

func power_off():
	print("powered_off")

func trigger_pulled():
	print("trigger was pulled")

export var pin_type = TYPE.SENSOR setget set_pin_type

func _ready():
	set_pin_type(pin_type)
	$Label.text = "%s" % type_names[pin_type]
	$LineEdit.text = "%s" % type_default[pin_type]

func set_pin_type(type):
	pin_type = type
	self_modulate = type_colors[type]
	emit_signal("type_changed", type)
	vfunc = type_default[pin_type]
	
func trigger(been_triggered := {}, results := {"immediate": [], "events": {}}):
	if been_triggered.has(self): return
	been_triggered[self] = true
	match pin_type:
		TYPE.MODULE:
			results["immediate"].append(vfunc)
			for c in connections:
				c[0].trigger(been_triggered.duplicate(), results)
		TYPE.MOD_EVENT:
			var call_chain_results := {"immediate": [], "events": {}}
			for c in connections:
#				c[0].trigger({self:true}, call_chain_results)
				c[0].trigger({}, call_chain_results)
			results["events"][vfunc] = call_chain_results
			if not results['events'][vfunc].has("action"): results['events'][vfunc]["action"] = []
			results['events'][vfunc]["action"].append(results['immediate'].back())
		TYPE.TRIGGER, TYPE.ALT_TRIGGER:
			for c in connections:
				c[0].trigger(been_triggered.duplicate(), results)
	return results

func add_connection(pin):
	if pin_type in valid_connections[pin.pin_type]:
		print("connecting pins %s and %s" % [name, pin.name])
		pin.connections.append([self, _mechanism.active_wire])
		#keep track of end points for dragging
		if not _mechanism.wire_pins.has(self): _mechanism.wire_pins[self] = [[],[]]
		if not _mechanism.wire_pins.has(pin): _mechanism.wire_pins[pin] = [[],[]]
		_mechanism.wire_pins[self][1].append(_mechanism.active_wire)
		_mechanism.wire_pins[pin][0].append(_mechanism.active_wire)
		_mechanism.active_wire = null
	else:
		print("Not a valid connection")
		_mechanism.bad_connection()
		_mechanism.clear_wire()
		
var text_enter = false

func _on_TextureButton_mouse_entered():
	hovered = true
	if not _cm.visible and (pin_type == TYPE.MODULE or pin_type == TYPE.MOD_EVENT):
		$LineEdit.visible = true
	if in_connect_mode():
		if not connection_started():
#			_mechanism.connecting_pin = self
			pass
		else:
			add_connection(_mechanism.connecting_pin)
			_mechanism.connecting_pin = null
			
func _on_TextureButton_mouse_exited():
	hovered = false
	yield(get_tree().create_timer(0.3),"timeout")
	if not hovered and not text_enter:
		$LineEdit.visible = false

onready var _cm = $'../../ConnectMode'
onready var _cs = $'../../ConnectionStarted'
onready var _mechanism = get_parent().get_parent().get_parent()


func in_connect_mode():
	return _cm.visible

func connection_started():
	return _cs.visible

var drag_position = null

func _input(event):
	if not hovered: 
		drag_position = null
		return
	if in_connect_mode():
		drag_position = null
		if event is InputEventMouseButton:
			if event.pressed:
				if not connection_started():
					_mechanism.connecting_pin = self
					print("pin = %s" % name)
					accept_event()
	else:
		if event is InputEventMouseButton:
			if event.pressed:
				drag_position = get_global_mouse_position() - rect_global_position
			else:
				drag_position = null
		
		if event is InputEventMouseMotion and drag_position:
			rect_global_position = get_global_mouse_position() - drag_position
			if _mechanism.wire_pins.has(self):
				for w in _mechanism.wire_pins[self][0]:
					w.pin_start = w.to_local(get_global_mouse_position() - drag_position)
				for w in _mechanism.wire_pins[self][1]:
					w.pin_end = w.to_local(get_global_mouse_position() - drag_position)

func _on_LineEdit_mouse_entered():
	text_enter = true

func _on_LineEdit_mouse_exited():
	text_enter = false
	$LineEdit.visible = false
	
func _on_LineEdit_text_entered(new_text):
	if pin_type == TYPE.MODULE or pin_type == TYPE.MOD_EVENT:
		vfunc = new_text
