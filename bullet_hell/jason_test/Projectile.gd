extends Node3D

var particle_explosion = preload ("res://jason_test/particle_explosion.tscn")

var hit_something: bool = false
var direction: Vector3 = Vector3.ZERO
var proj_speed: int = 0
var damage: int = 1
var hit = -1
var init_pos: Vector3 = Vector3.ZERO
@onready var lifetime: Timer = get_node("Lifetime")
@onready var timer: Timer = get_node("HitTime")
@onready var hit_light: OmniLight3D = get_node("HitLight")
@onready var mainnd = get_parent()
@onready var cam: Camera3D = get_parent().get_node("player/SubViewportContainer/SubViewport/Camera3D")
@onready var arrowhead: Sprite3D = get_node("Sprite3D")
@onready var tail: GPUParticles3D = get_node("GPUParticles3D")
@onready var sprite3d = get_node("Sprite3D")
@onready var player = mainnd.get_node("player")

var rng = RandomNumberGenerator.new()
var color_seed: float

func get_color():
	return Color.from_hsv(clamp(log(damage)*0.1 + 0.05*rng.randf(),0.,1.), 
							clamp(.6+0.1*damage,0.,1.),
							clamp(0.6+0.1*damage,0.,1.))

func launch(initial_position: Vector3, dir: Vector3, speed: int) -> void:
	#print(initial_position)
	look_at(dir, Vector3(0, 1, 0))
	global_rotation_degrees[0] = -45.
	#print(global_rotation_degrees)
	position = initial_position
	init_pos = initial_position
	direction = dir
	proj_speed = speed
	color_seed = rng.randf()
	arrowhead.modulate = get_color()
	tail.material_override.albedo_color = get_color()

func _physics_process(delta: float) -> void:
	#print(global_position, direction)
	if lifetime.is_stopped():
		queue_free()
	elif not hit_something:
		position += direction * proj_speed * delta
	else:
		hit_light.light_energy = timer.time_left * 50
		if timer.is_stopped():
			queue_free()

func _on_body_entered(body):
	if not hit_something and body.is_in_group("enemies"):
		body.take_damage(damage)
		hit_something = true;
		sprite3d.visible = false
		tail.visible = false
		# get_node("HitSprite").visible = true
		if (player.hp > 0):
			cam.camera_shake(.02, .02)
		hit_light.light_energy = 1.0
		timer.start(0.5)
	elif body.is_in_group("map"):
		var _particle_parent = particle_explosion.instantiate()
		var _particle = _particle_parent.get_node("death_particles")
		_particle.position = global_position
		_particle.emitting = true
		get_tree().current_scene.add_child(_particle_parent)
		queue_free()
	elif body.is_in_group("lens"):
		var planelook: Vector3 = body.get_global_transform().basis.z
		#print('planeloo', planelook)
		var plane: Plane = Plane(planelook, body.global_position)
		var planecenter: Vector3 = plane.project(body.global_position)
		var denominator = planelook.dot(direction)
		if abs(denominator) < 0.001:
			return
		var t = ((planecenter - (global_position - direction)).dot(planelook) / planelook.dot(direction))
		var isect = (global_position-direction) + t * direction
		planecenter.y = 0.2
		#print('plane body', planecenter, body.global_position)
		#print('isect', isect)
		#print('arrowpos', global_position)
		var dist_from_center: Vector3 = isect - planecenter
		var horizontal: Vector3 = dist_from_center.cross(Vector3.UP)
		var theta = direction.angle_to(horizontal) 
		var theta_prime = atan(tan(theta) + dist_from_center.length() / body.focal_length)
		var delta_theta = theta_prime - theta
		if horizontal.dot(planelook) < 0:
			direction = direction.rotated(Vector3.UP, -delta_theta)
		else:
			direction = direction.rotated(Vector3.UP, -PI + delta_theta)
		rotation.y = atan2(-direction.x, -direction.z)
		damage *= 2
		arrowhead.modulate = get_color()
		tail.material_override.albedo_color = get_color()
		#look_at(direction)
		#print('dfc', dist_from_center)
		#print('hor',horizontal)
		#print(rad_to_deg(theta))
		#print(rad_to_deg(theta_prime))
