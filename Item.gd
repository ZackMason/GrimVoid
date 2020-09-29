extends Interactable
class_name Item

export var item_name := "" 

func interact(node):
	node.add_to_inventory(self)
	queue_free()
	
func _ready():
	._ready()
	assert(item_name != "")
	$Sprite.texture = load(ItemDB.get_item(item_name)["icon"])
