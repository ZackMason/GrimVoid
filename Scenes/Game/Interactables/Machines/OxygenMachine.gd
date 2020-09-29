extends Machine

func do(dt):
	if _room:
		var o = _room.get_node("Oxygen")
		o.damage(-strength * dt)
