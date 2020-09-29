extends Area2D

var dmg := 10.0
var speed = 90.0
var life := 10.0
var dir := Vector2.ZERO

onready var leak = preload("res://Scenes/Game/Interactables/Ship/Breach.tscn")
onready var explosion = preload("res://Scenes/Game/explosion.tscn")

func _ready():
	randomize()

func do(body):
	if body.is_in_group("rigid") and randf() < 0.1:
		var l = leak.instance()
		body.add_child(l)
		l._room = body
		l.transform = body.transform.inverse()
		var s = 32
		l.position = Vector2(randf() * s, randf() * s )
	if body.is_in_group("health"):
		body.get_node("Health").damage(dmg)
		var e = explosion.instance()
		get_parent().add_child(e)
		e.position = position
		queue_free()

func _on_CannonShot_area_entered(area):
	do(area)

func _on_CannonShot_body_entered(body):
	do(body)

func _process(delta):
	life -= delta
	if life <= 0.0: 
		queue_free()
	position += delta * speed * dir
