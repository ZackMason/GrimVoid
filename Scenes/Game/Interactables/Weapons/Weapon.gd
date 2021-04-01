extends Interactable
##############################################################
var held = null
var grappled = null
onready var _bullet = preload("res://Scenes/Game/Interactables/Weapons/Bullet.tscn")
export var run = false setget fire_bullet

var stats = {
	"damage": 10, 
	"range": 200, 
	"sprite": "res://Sprites/gun_001.png",
	"fire_method" : "mechanism",
	"alt_fire_method" : "mechanism",
}

onready var _wire = $Wire.duplicate()
onready var _mechanism = $MeshLayer/Mechanism
##############################################################

func on_hit():
	print('hit event triggered')
	
func power_off():
	print("powered_off")

func trigger_pulled():
	print("trigger was pulled")
	
func mechanism(alt = false, shots = null):
	if not shots:
		shots = _mechanism.trigger(alt)
	if not shots: 
		print("mechanism not working")
		return
#	for i in range(shots.size()):
	for shot in shots:
#		var shot = shots[i]
#		print(shot)
		var i = 0
		while i < shot['immediate'].size():
			var effect = shot['immediate'][i]
		
#		for effect in shot["immediate"]:
			print(effect.vfunc)

			var hit = call(effect.vfunc)

			if hit: # disabled
				if shot['events'].has('on_hit') and effect.vfunc in shot['events']['on_hit']['action']:
#					print("%s on hit event: %s" % [effect.vfunc, shot['events']['on_hit']])
					shot['events']['on_hit']['action'].erase(effect.vfunc)
#					shots.insert(i+1,shot['events']['on_hit'])
					shots.append(shot['events']['on_hit'])
#					mechanism(alt, [shot['events']['on_hit']])
			if shot['events'].has('delay') and effect.vfunc in shot['events']['delay']['action']:
				print('delay')
				shot['events']['delay']['action'].erase(effect.vfunc)
				yield(get_tree().create_timer(0.2),"timeout")
				shots.append(shot['events']['delay'])
#				for e in shot['events']['delay']['immediate']:
#					shot['immediate'].append(e)
#					break
#				shot["immediate"] += (shot['events']['delay']['immediate'])
#				mechanism(alt, [shot['events']['delay']])
			i += 1

	print('done')
#		shots[i] = shot
func fire_bullet(_b=0):
	var nb = _bullet.instance()
	add_child(nb)
	nb.position = $RayCast2D.position
	
func scatter():
	$RayCast2D.rotation_degrees = (randf() * 2.0 - 1.0) * 15.0
	
onready var _laser = preload('res://Scenes/Game/Projectiles/Laser.tscn')
onready var _b = preload('res://Scenes/Game/Projectiles/Bullet.tscn')

func laser():
#	print("laser")
	var l = _laser.instance()
	$RayCast2D.add_child(l)
	l.rotation = deg2rad((randf() * 2.0 - 1.0) * 15.0)
	
func bullet():
	var l = _b.instance()
	$RayCast2D.add_child(l)
	l.rotation = deg2rad((randf() * 2.0 - 1.0) * 15.0)
#	return fire()

func fire():
	fire_bullet()
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		var b = $RayCast2D.get_collider()
#		print(b.name)
		if b.is_in_group("health"):
			b.get_node("Health").damage(stats["damage"])
			return true
	return false

onready var _s = $Spring


var first_hit = null
var first_body = null
var second_hit = null
var second_body = null
onready var active_wire = $Wire


func wire():
#	print("wire")
	var collision = $RayCast2D.is_colliding()
	var p = $RayCast2D.get_collision_point()
	var b = $RayCast2D.get_collider()
	if first_hit == null:
		if collision:
			remove_child(active_wire)
			held.get_parent().add_child(active_wire)
			active_wire.visible = true
			if b.is_in_group("power"):
				first_body = b
			first_hit = active_wire.to_local(p)
			active_wire.pin_start = first_hit
			active_wire.pin_end = active_wire.to_local($RayCast2D.global_position)
			active_wire.fix()
			return true
	elif second_hit == null:
		if collision:
			if b.is_in_group("power"):
				second_body = b
			second_hit = active_wire.to_local(p)
			active_wire.pin_end = second_hit
				
			if first_body and second_body and first_body != second_body:
				print("connected power %s <=> %s" % [first_body.name, second_body.name])
				RoomConnections.wires.append([first_body.get_node('Power'), second_body.get_node('Power'), active_wire])
		
			active_wire = _wire.duplicate()
			add_child(active_wire)
			
			$Wire.pin_start = Vector2.ZERO
			$Wire.pin_end = Vector2.ZERO
			
			first_hit = null
			first_body = null
			second_hit = null
			second_body = null
			$Wire.visible = false
			return true

func grapple():
	if not grappled:
		fire_bullet()
		if $RayCast2D.is_colliding():
			var b = $RayCast2D.get_collider()
			if b is RigidBody2D:
				grappled = true
				_s.node_a = held.get_path()
				_s.node_b = b.get_path()
	else:
		grappled = false
		_s.node_a = ""
		_s.node_b = ""

func interact(node):
	if not held:
		node.pick_up(self)
		held = node
		remove_child(_s)
		node.add_child(_s)
		disable_room_ownership = true
	else:
		print("firing")
		call(stats["fire_method"])
	
func alt_interact(_node):
	if not held:
		$Health.damage(-10.0)
	else:
		call(stats["alt_fire_method"], true)
	
##############################################################

func _process(_d):
	if not _mechanism: 
		_mechanism = $MeshLayer.get_child(0)
	if held:
		if Input.is_action_just_pressed("hack_screen"):
			print("ggg")
			_mechanism.visible = not _mechanism.visible 
			_mechanism.rect_position = Vector2.ZERO
	if first_hit:
		active_wire.pin_end = active_wire.to_local($RayCast2D.global_position)

func _ready():
	._ready()
	randomize()
	$RayCast2D.cast_to.x = stats["range"]
	$Wire.pin_start = Vector2.ZERO
	$Wire.pin_end = Vector2.ZERO
