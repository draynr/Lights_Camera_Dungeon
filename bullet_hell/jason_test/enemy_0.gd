extends CharacterBody3D

@export var ENEMY_BULLET: PackedScene = preload ("res://jason_test/enemy_bullet.tscn")
# const DEATH_PARTICLE: PackedScene = preload ("res://jason_test/enemy_death_particles.tscn")

var proj_speed: float = 2

var speed = 1
var accel = 1
var hp = 5
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player = null
var player_spotted: bool = false

var view_distance = 20.0
var angle_cone := deg_to_rad(30.)
var angle_between_rays := deg_to_rad(5.)

var target
const turn_speed = 15

@onready var line3d = $Line3D
@onready var raycast: RayCast3D = $LineOfSight
@onready var vision = $vision
@onready var shoottimer = $ReloadTimer

enum {IDLE, ALERT}

var see_player = false
var state = IDLE
# var can_shoot = true

func _ready():
	pass

func _physics_process(delta):
	var dir = Vector3.ZERO
	var cast_count = int(angle_cone / angle_between_rays) + 1
	
	if state == ALERT:
		nav.target_position = get_parent().get_node("player").global_position
		
		var target_direction = target.global_position - global_position
		var target_rotation = Vector3(0, atan2(target_direction.x, target_direction.z), 0)
		rotation = rotation.lerp(target_rotation, turn_speed * delta)
		
		dir = nav.get_next_path_position() - global_position
		dir = dir.normalized()
		
		for index in cast_count:
			var angle = angle_between_rays * (index - cast_count / 2.0)
			var cast_vector = Vector3(sin(angle), 5, cos(angle)) * 100
			raycast.target_position = cast_vector
			raycast.force_raycast_update()
			if raycast.is_colliding() and raycast.get_collider().is_in_group("player"):
				target = raycast.get_collider()
				# vision.look_at(target.global_transform.origin, Vector3.UP)
				if (shoottimer.is_stopped()):
					shoot()
				break
	velocity = velocity.lerp(dir * speed, accel * delta)
	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		state = ALERT
		target = body

func shoot() -> void:
	var bullet: CharacterBody3D = ENEMY_BULLET.instantiate()
	bullet.projectile_texture = load("res://jason_test/Enemy_Bullet.png")
	var direction = (get_parent().get_node("player").global_position - global_position).normalized()
	bullet.rotation.y = atan2(direction.x, direction.z)
	bullet.spawnCoords = global_position + Vector3(0, .05, 0)
	bullet.spawnRotation = direction
	get_tree().current_scene.add_child(bullet)

	var cone_angle = deg_to_rad(30)

	for i in range(2):
		var ofs = ENEMY_BULLET.instantiate()
		ofs.projectile_texture = load("res://jason_test/Enemy_Bullet.png")
		var offset_angle = randf_range( - cone_angle, cone_angle)
		var offset_direction = direction.rotated(Vector3.UP, offset_angle)
		ofs.rotation.y = atan2(offset_direction.x, offset_direction.z)
		ofs.spawnCoords = global_position + Vector3(0, .05, 0)
		ofs.spawnRotation = offset_direction
		get_tree().current_scene.add_child(ofs)

	# flash()
	shoottimer.start()

################# ON-HIT #####################################
func flash():
	$AnimatedSprite3D.material_override.set_shader_parameter("active", true)
	$HitTimer.start()
func take_damage(dmg):
	hp -= dmg;
	flash()
	if hp <= 0:
		die()
		# queue_free()
	else:
		state = ALERT

func _on_hit_timer_timeout():
	# pass # Replace with function body.
	$AnimatedSprite3D.material_override.set_shader_parameter("active", false)

func die():
	# don't have one yet
	# var _particle = DEATH_PARTICLE.instantiate()
	# _particle.position = global_position
	# _particle.rotation = global_rotation
	# _particle.emitting = true
	# get_tree().current_scene.add_child(_particle)
	$AnimatedSprite3D.material_override.set_shader_parameter("active", false)
	queue_free()
