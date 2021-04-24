extends ColorRect

var planets = [
	Vector2(100,100),
	Vector2(200,100),
	Vector2(150,200),
	Vector2(350,150),
]

var connections = [
	[0,1],
	[2,1],
	[2,0],
	[0,3],
	[1,3],
]

func _ready():
	pass


func _draw():
	for edge in connections:
		draw_line(planets[edge[0]], planets[edge[1]], Color.white)
	for planet in planets:
		draw_circle(planet, 25.0, Color.whitesmoke if get_local_mouse_position().distance_to(planet) > 25.0 else Color.purple)


	
func _process(delta):
	update()
