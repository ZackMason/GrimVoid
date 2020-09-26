extends KinematicBody2D
class_name Ship

var velocity := Vector2(0,-30)
export var move_speed := 3
 
func _physics_process(delta):
	rotate(velocity.x * delta * 0.01)
	#move_and_slide(velocity.y * Vector2(cos(global_rotation + PI*0.5), sin(global_rotation + PI*0.5)))
	var c = move_and_collide(delta * velocity.y * Vector2(cos(global_rotation + PI*0.5), sin(global_rotation + PI*0.5)))
	if c:
		var dir = global_position.direction_to(c.collider.global_position)
		c.collider.move_and_collide(dir * delta * velocity.length())
	velocity = velocity.linear_interpolate(Vector2.ZERO, 1.0 - pow(0.125, delta))
