extends Machine

#strength = heat output
#power drain = fill rate

func do(dt):
	if _room:
		var h = _room.get_node("Heat")
		h.damage(-strength * dt)
