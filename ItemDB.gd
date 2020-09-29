extends Node

const _ICON_PATH = "res://Sprites/"
const _ITEM_PATH = "res://Sprites/Items/"
var _ITEMS := {
	"pistol" : {
		"icon": _ICON_PATH + "gun_001.png",
		"slot": "primary",
		"protection": [],
	},
	"spacehelm" : {
		"icon": _ITEM_PATH + "helmet_001.png",
		"slot": "head",
		"protection": [],
	},
	"spacesuit" : {
		"icon": _ITEM_PATH + "chest_001.png",
		"slot": "chest",
		"protection": [],
	},
	"spacelegs" : {
		"icon": _ITEM_PATH + "legs_001.png",
		"slot": "legs",
		"protection": [],
	},
	"airpack" : {
		"icon": _ITEM_PATH + "airpack_001.png",
		"slot": "back",
		"protection": [],
	},
	"heater" : {
		"icon": _ICON_PATH + "heater_001.png",
		"slot": "",
		"protection": [],
	},
	"error" : {
		"icon": _ICON_PATH + "icon.png",
		"slot": "",
		"protection": [],
	},
}

func get_item(item_id):
	if item_id in _ITEMS:
		return _ITEMS[item_id]
	return _ITEMS["error"]
