extends Node2D

class Vertex:
	var p := Vector2.ZERO # current position
	var lp := Vector2.ZERO # last position
	
	func _init(v: Vector2):
		p = v
		lp = p
		
	#@param np - new position
	func simulate(np := p):
		p = np
		var vel = p - lp
		lp = p
		return vel
		
export var count := 10
	
var points = []
export var distance = 3.0
export var gravity = 9.8
export var width = 0.5

export(Vector2) var pin_start = null setget sps
export(Vector2) var pin_end = null setget spe

func sps(p):
	pin_start = p
	if p: $VisibilityEnabler2D.position = p

func spe(p):
	pin_end = p
	if p: $VisibilityEnabler2D2.position = p

func _ready():
	var sp = Vector2.ZERO
	for i in range(count):
		points.append(Vertex.new(sp))
		sp.x += 2
	$Line2D.points.resize(count)
	update_line()
	$Line2D.width = width
func update_line():
	for i in range(points.size()):
		$Line2D.points[i] = (points[i].p)

func link_points(a,b):
	var d = a.distance_to(b)
	var step = d / float(count)
	var dir = a.direction_to(b)
	for i in range(count):
		points[i].p = a + dir * step * i
		points[i].lp = a + dir * step * i

func fix():
	link_points(pin_start, pin_end)

var iterations := 1

onready var last_gp = global_position

func _process(delta):
	physics_sim(delta)
	
func physics_sim(delta):
#	var gv := Vector2.ZERO
	var gp = global_position
	var gv = (global_transform.inverse() * gp) - (((global_transform.inverse() * last_gp)) if last_gp else gp)
	last_gp = gp
	gv *= -.2
	if gv.length() > 50:
		gv = Vector2.ZERO

	
#	for itr in range(iterations):
	for i in range(1, points.size()):
		var p = points[i]
		var v = p.simulate(p.p)# * delta * 50.0
		v.y += gravity * delta
		p.p += v + gv
		if i > 0:
			var lp = points[i-1]
			if p.p.distance_to(lp.p) > distance:
				var half = p.p+lp.p
				half *= 0.5
				p.p = half+distance*half.direction_to(p.p)/2.0
				lp.p = half+distance*half.direction_to(lp.p)/2.0
		
		points[i] = p
		
	if pin_start: points[0].simulate(pin_start)
	else: 
#		points[0].simulate(get_local_mouse_position())
		points[0].simulate(Vector2.ZERO)
		points[0].lp = points[0].p
	
	if pin_end: points[count-1].simulate(pin_end)
	else: 
#		points[count-1].simulate(get_local_mouse_position())
		points[count-1].lp = points[count-1].p
	
	update_line()
	
	
	
	#func _input(event):
#	if event is InputEventMouseButton:
#		if not pin_start: pin_start = get_local_mouse_position()
#		else: pin_end = get_local_mouse_position()
#	if event.is_action_pressed("ui_cancel"):
#		if pin_end: pin_end = null
#		else: pin_start = null
#
