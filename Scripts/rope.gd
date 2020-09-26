tool
extends Node2D

class Vertex:
	var position := Vector2.ZERO
	var last_position := Vector2.ZERO
	
	func _init(p: Vector2):
		self.position = p
		self.last_position = p

var vertices := []
var edges := []

export var width := 10
export var height := 10

export var gravity := 9.8

export var rope_distance := 5
export var spring_constant := 0.98

export var build = false setget sbuild

func sbuild(b):
	_rebuild()

func spring(a: Vector2, b: Vector2, k: float) -> Vector2:
	var d = max(0.0, a.distance_to(b) - rope_distance)
	var dir = a.direction_to(b)
	return dir * d * k

func _ready():
	_rebuild()

func _rebuild():
	vertices = []
	edges = []
	for i in range(11):
		var v = Vertex.new(Vector2(i * rope_distance, 0) + Vector2(100,100))
		vertices.push_back(v)
		edges.push_back([i-1, i]) if i > 0 else null

	
func _draw():
	for e in edges:
		draw_line(vertices[e[0]].position, vertices[e[1]].position,Color.blue,10)

func _process(delta):
	for i in range(1, vertices.size()):
		var v = vertices[i]
	
		var velocity : Vector2 = v.position - v.last_position
		var lp = vertices[i-1].last_position
		velocity += spring(vertices[i].last_position, lp, spring_constant)
#		var spring_force = (delta * spring(v.last_position, vertices[i-1].position, spring_constant)) if i > 0 else Vector2.ZERO
		var gravity_force = delta * Vector2(0, gravity if i > 0 else 0.0) 
		v.last_position = v.position
		v.position += velocity + gravity_force# + spring_force
#		if i > 0:
#			if v.position.distance_to(vertices[i-1].position) > rope_distance:
#				v.position = vertices[i-1].position + vertices[i-1].position.direction_to(v.position) * rope_distance

		vertices[i] = v
		
	update()
#	$Line2D.points = []
#	for v in vertices:
#		$Line2D.points.push_back(v.position)
