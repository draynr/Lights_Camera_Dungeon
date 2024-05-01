extends CharacterBody3D

@export var ENEMY_BULLET: PackedScene = preload ("res://jason_test/enemy_bullet.tscn")
var death_particle = preload ("res://jason_test/enemy_death_explosion_blue.tscn")

const MAX_BULLETS = 15
const turn_speed = 15

var proj_speed: float = 2

var speed = 1
var accel = 1
var hp = 3
signal died

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player = null
var player_spotted: bool = false

var view_distance = 20.0
var angle_cone := deg_to_rad(30.)
var angle_between_rays := deg_to_rad(5.)
var target

@onready var raycast: RayCast3D = $LineOfSight
@onready var vision = $vision

@onready var reloadCnt = 0

@onready var shoottimer = $ShootTimer
@onready var reloadtimer = $ReloadTimer

@onready var sprite3d = $Sprite3D
@onready var hitTimer = $HitTimer
@onready var projectile_texture = preload ("res://jason_test/teabag.png")
@onready var playerNode = get_parent().get_node("player")
@onready var shoot_audio = $ShootAudio
@onready var damaged_audio = playerNode.get_node("Damaged_Enemy")
@onready var killed_audio = playerNode.get_node("Killed_Enemy")

enum {IDLE, ALERT}
var alive = true
var see_player = false
var state = IDLE

func _ready():
	var _particle_parent = death_particle.instantiate()
	var _particle = _particle_parent.get_node("death_particles")
	_particle.position = global_position
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle_parent)
	set_physics_process(false)
	await get_tree().create_timer(0.7).timeout
	set_physics_process(true)

func _physics_process(delta):
	var dir = Vector3.ZERO
	var cast_count = int(angle_cone / angle_between_rays) + 1
	
	if state == ALERT:
		nav.target_position = get_parent().get_node("player").global_position
		
		var target_direction = target.global_position - global_position
		var target_rotation = Vector3(0, atan2(target_direction.x, target_direction.z), 0)
		rotation = rotation.lerp(target_rotation, turn_speed * delta)
		
		dir = nav.get_next_path_position() - global_position
		dir.y = 0
		dir = dir.normalized()
		
		for index in cast_count:
			var angle = angle_between_rays * (index - cast_count / 2.0)
			var cast_vector = Vector3(sin(angle), 5, cos(angle)) * 100
			raycast.target_position = cast_vector
			raycast.force_raycast_update()
			if raycast.is_colliding() and raycast.get_collider().is_in_group("player"):
				target = raycast.get_collider()
				# vision.look_at(target.global_transform.origin, Vector3.UP)
				if (shoottimer.is_stopped() and reloadtimer.is_stopped()):
					shoot()
				break
	velocity = velocity.lerp(dir * speed, accel * delta)
	move_and_slide()
	global_position.y = 0.18

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		state = ALERT
		target = body

## REWORKING SHOOTING MECHANIC
func shoot() -> void:

	var direction = (get_parent().get_node("player").global_position - global_position).normalized()

	var cone_angle = deg_to_rad(30)
	var num_bullets = 5
	var spread_angle = cone_angle / (num_bullets - 1) if num_bullets > 1 else 0
	var start_angle = -cone_angle / 2
	for i in range(num_bullets):
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = projectile_texture
		var sprite = bullet.get_node("Sprite3D")
		sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
		sprite.material_override.set_shader_parameter("glow_strength", 2.1)
		
		var offset_angle = start_angle + i * spread_angle
		var offset_direction = direction.rotated(Vector3.UP, offset_angle)
		bullet.rotation.y = atan2(offset_direction.x, offset_direction.z)
		bullet.spawnCoords = global_position + Vector3(0, .05, 0)
		bullet.spawnRotation = offset_direction
		get_tree().current_scene.add_child(bullet)

	if !shoot_audio.playing:
		shoot_audio.play()
	shoottimer.start()
	reloadCnt += num_bullets
	if (reloadCnt >= MAX_BULLETS):
		reloadtimer.start()
		reloadCnt = 0

################# ON-HIT #####################################
func flash():
	sprite3d.material_override.set_shader_parameter("active", true)
	hitTimer.start()

func take_damage(dmg):
	hp -= dmg;
	flash()
	if hp <= 0 and alive:
		alive = false
		killed_audio.play()
		die()
		# queue_free()
	else:
		damaged_audio.play()
		state = ALERT

func _on_hit_timer_timeout():
	# pass # Replace with function body.
	sprite3d.material_override.set_shader_parameter("active", false)

func die():
	# don't have one yet
	# var _particle = DEATH_PARTICLE.instantiate()
	# _particle.position = global_position
	# _particle.rotation = global_rotation
	# _particle.emitting = true
	# get_tree().current_scene.add_child(_particle)
	var _particle_parent = death_particle.instantiate()
	var _particle = _particle_parent.get_node("death_particles")
	_particle.position = global_position
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle_parent)
	sprite3d.material_override.set_shader_parameter("active", false)
	died.emit()
	queue_free()
