extends Machine


func do(dt):
	if _room:
		var h = _room.get_node("Heat")
		var parity = -1.0 if h.value < 75.0 else 1.0
		h.damage(strength * parity * dt)
