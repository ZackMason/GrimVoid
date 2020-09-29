extends Panel

onready var slots = get_children()
var items := {}


func _ready():
	for slot in slots:
		items[slot.name] = null

func insert_item(item):
	var item_pos = item.rect_global_position + item.rect_size / 2
	var slot = get_slot_under_pos(item_pos)
	if not slot:
		return false
	
	var item_slot = ItemDB.get_item(item.get_meta("id"))["slot"]
	if item_slot != slot.name:
		return false
	if items[item_slot]:
		return false
	items[item_slot] = item
	get_node(item_slot).get_node("Label").visible = false
	item.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - item.rect_size / 2
	return true

	
func grab_item(pos):
	var item = get_item_under_pos(pos)
	if not item: return null
	
	var item_slot = ItemDB.get_item(item.get_meta("id"))["slot"]
	items[item_slot] = null
	get_node(item_slot).get_node("Label").visible = true
	return item
	
	
	

func get_slot_under_pos(pos):
	return get_thing_under_pos(slots, pos)

func get_thing_under_pos(arr, pos):
	for thing in arr:
		if thing and thing.get_global_rect().has_point(pos):
			return thing
	return null

func get_item_under_pos(pos):
	return get_thing_under_pos(items.values(), pos)
