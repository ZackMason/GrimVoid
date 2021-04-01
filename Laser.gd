extends RayCast2D

var is_casting := true setget set_is_casting

export var damage = 10.0
export var life_time = 1.0 setget set_life_time

func set_life_time(t):
	$LifeTimer.stop()
	life_time = t
	if is_inside_tree(): $LifeTimer.start(life_time)

func life_timer_done():
	queue_free()

func _ready():
	$LifeTimer.connect("timeout", self, 'life_timer_done')
	set_physics_process(false)
	set_is_casting(true)
	$Beam.points[1] = Vector2.ZERO
	$LifeTimer.start(life_time)
	
func set_is_casting(cast: bool) -> void:
	is_casting = cast
	
	$CastingParticles.emitting = is_casting
	if is_casting:
		appear()
	else:
		disappear()
		$HitParticles.emitting = false
	
	set_physics_process(is_casting)

func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	
	$HitParticles.emitting = is_colliding()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		if get_collider().is_in_group("health"):
			get_collider().get_node("Health").damage(damage * delta)
		
		$HitParticles.global_rotation = get_collision_normal().angle()
		$HitParticles.position = cast_point
	
	$Beam.points[1] = cast_point
	$CastingParticles.position = cast_point * 0.5
	$CastingParticles.process_material.emission_box_extents.x = cast_point.length() * 0.5

func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Beam, 'width', 0,  3.666, 0.2)
	$Tween.start()
	
	
func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Beam, 'width', 3.666,  0, 0.2)
	$Tween.start()
