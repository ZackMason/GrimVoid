extends Control

onready var connect_mode = $MechWindow/ConnectMode
var active_wire = null
onready var _wires = $MechWindow/Wires

var wire_pins = {
	"test": [[],[]],
}


func _on_ConnectButton_toggled(button_pressed):
	connect_mode.visible = button_pressed

var connecting_pin = null setget set_connecting_pin

func set_connecting_pin(v):
	connecting_pin = v
	$MechWindow/ConnectionStarted.visible = connecting_pin != null
	if connecting_pin:
		active_wire = _wire.instance()
		active_wire.set_process(false)
		_wires.add_child(active_wire)
		active_wire.pin_start = _wires.get_local_mouse_position()
		active_wire.pin_end = _wires.get_local_mouse_position()
		active_wire.fix()
		
func _input(event):
	if Input.is_action_just_pressed("alt_fire"):
		if active_wire: 
			clear_wire()
			$MechWindow/ConnectionStarted.visible = false
		
func clear_wire():
	if not active_wire: return
	active_wire.queue_free()
	active_wire = null
	
func set_wire_end(p):
	active_wire.pin_end = p
	active_wire = null

func _process(delta):
	if active_wire:
		active_wire.get_node("Line2D").width = 5.0
#		active_wire.gravity = 175.0
		active_wire.gravity = 0.0
		active_wire.distance = 6.0
		active_wire.pin_end = _wires.get_local_mouse_position()
	
	for w in _wires.get_children():
		w._process(delta)
	
func bad_connection():
	$MechWindow/PopupPanel.popup_centered()#  ($MechWindow/PopupPanel.get_rect())
	$MechWindow/PopupPanel.rect_global_position.y += 200
	yield(get_tree().create_timer(1.0), "timeout")
	$MechWindow/PopupPanel.visible = false
	

onready var _wire = preload("res://Scenes/Game/Wire.tscn")

func _on_Trigger_button_up():
	trigger()
	
func trigger(alt := false):
	var trigger_list = []
	for p in $MechWindow/Pins.get_children():
		if p.pin_type == (Mechpin.TYPE.TRIGGER if not alt else Mechpin.TYPE.ALT_TRIGGER): # if trigger or alt trigger
			trigger_list.append(p.trigger())
	return trigger_list


func _on_Reset_button_up():
	var p = get_parent()
	p.remove_child(self)
	p.add_child(load("res://Scenes/UI/Mechanism.tscn").instance())
	queue_free()
