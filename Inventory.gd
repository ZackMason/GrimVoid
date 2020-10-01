extends Control

const _item_base = preload('res://Scenes/Game/Inventory/ItemBase.tscn')

onready var inv_base = $InventoryBase
onready var back_pack = $BackPack
onready var eq_slots = $Equipment

var item_held = null
var item_offset := Vector2.ZERO
var last_container = null
var last_pos := Vector2.ZERO

var stacked_items = {}
var items = []

func _ready():
	$InventoryBase/TextEdit.text = get_parent().get_parent().name
	
func _process(delta):
	var cp = get_global_mouse_position()
	if Input.is_action_just_pressed("inv_grab"):
		grab(cp)
	elif Input.is_action_just_released("inv_grab"):
		release(cp)
	if item_held:
		item_held.rect_global_position = cp + item_offset
		
func grab(pos):
	var c = get_container_under_cursor(pos)
	if c != null and c.has_method("grab_item"):
		item_held = c.grab_item(pos)
		if item_held:
			last_container = c
			last_pos = item_held.rect_global_position
			item_offset = item_held.rect_global_position - pos
			move_child(item_held, get_child_count())
			
func get_container_under_cursor(pos):
	var containers := [back_pack, eq_slots, inv_base]
	for c in containers:
		if c.get_global_rect().has_point(pos):
			return c
	return null
	
func release(pos):
	if not item_held: return
	var c = get_container_under_cursor(pos)
	if not c:
		drop_item()
	elif c.has_method("insert_item"):
		if c.insert_item(item_held):
			item_held = null
		else:
			return_item()
	else:
		return_item()
		
func drop_item():
	item_held.queue_free()
	item_held = null
	
func return_item():
	item_held.rect_global_position = last_pos
	last_container.insert_item(item_held)
	item_held = null


func pickup_item(item_id, amt = 0):
	if amt:
		if stacked_items.has(item_id):
			stacked_items[item_id]["count"] += amt
			stacked_items[item_id]["widget"].get_node("Label").text = ("%d" % stacked_items[item_id]["count"])
			return
		else: 
			stacked_items[item_id] = {}
			stacked_items[item_id]['count'] = amt
	var item = _item_base.instance()
	item.set_meta("id", item_id)
	item.texture = load(ItemDB.get_item(item_id)["icon"])
	item.get_node("Label").text = ("%d" % amt) if amt else "" 
		
	if amt: stacked_items[item_id]['widget'] = item
	add_child(item)
	if !back_pack.insert_item_at_first_available_spot(item):
		item.queue_free()
		return false
	
	if not amt: items.append(item_id)
	return true

func _on_TextEdit_text_changed():
	get_parent().get_parent().name = $InventoryBase/TextEdit.text

var drag_position = null

func _input(event):
	if item_held: 
		drag_position = null
		return
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	

