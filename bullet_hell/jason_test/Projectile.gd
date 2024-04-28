extends Node3D

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

var rng = RandomNumberGenerator.new()
var color: Color

func launch(initial_position: Vector3, dir: Vector3, speed: int) -> void:
	#print(initial_position)
	look_at(dir, Vector3(0, 1, 0))
	global_rotation_degrees[0] = -45.
	#print(global_rotation_degrees)
	position = initial_position
	init_pos = initial_position
	direction = dir
	proj_speed = speed
	#mesh.add_vertex(init_pos)

	# if (randf() > .2):
	# 	get_parent().get_node("player/SubViewportContainer/SubViewport/Camera3D").camera_shake(.05, .05)
	color = Color(rng.randf(), rng.randf(), rng.randf())
	arrowhead.modulate = color
	tail.material_override.albedo_color = color

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
		get_node("Sprite3D").visible = false
		get_node("GPUParticles3D").visible = false
		# get_node("HitSprite").visible = true
		get_parent().get_node("player/SubViewportContainer/SubViewport/Camera3D").camera_shake(.04, .04)
		hit_light.light_energy = 1.0
		timer.start(0.5)
	elif body.is_in_group("map"):
		queue_free()
