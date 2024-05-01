extends CharacterBody3D

@export var ENEMY_BULLET: PackedScene = preload ("res://jason_test/enemy_bullet.tscn")
# const DEATH_PARTICLE: PackedScene = preload ("res://jason_test/enemy_death_particles.tscn")

var death_particle = preload ("res://jason_test/enemy_death_explosion.tscn")
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
const turn_speed = 15
@onready var raycast: RayCast3D = $LineOfSight
@onready var vision = $vision
@onready var shoottimer = $ReloadTimer

@onready var animatedSprite3d = $AnimatedSprite3D
@onready var hitTimer = $HitTimer
@onready var projectile_texture = preload ("res://jason_test/Enemy_Bullet.png")
@onready var playerNode = get_parent().get_node("player")

@onready var shoot_audio = $ShootAudio
@onready var damaged_audio = playerNode.get_node("Damaged_Enemy")
@onready var killed_audio = playerNode.get_node("Killed_Enemy")
@onready var spawn_timer = $spawntimer
enum {IDLE, ALERT}

var alive = true
var see_player = false
var state = IDLE
# var can_shoot = true

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
		nav.target_position = playerNode.global_position
		
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
				if (shoottimer.is_stopped()):
					shoot()
				break
	velocity = velocity.lerp(dir * speed, accel * delta)
	move_and_slide()
	#print("ENEMY", global_position, dir)

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		state = ALERT
		target = body

func shoot() -> void:
	var bullet: CharacterBody3D = ENEMY_BULLET.instantiate()
	if !shoot_audio.playing:
		shoot_audio.play()
	bullet.projectile_texture = projectile_texture
	var sprite = bullet.get_node("Sprite3D")
	sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
	sprite.material_override.set_shader_parameter("glow_strength", 2)

	var direction = (playerNode.global_position - global_position).normalized()
	bullet.rotation.y = atan2(direction.x, direction.z)
	bullet.spawnCoords = global_position + Vector3(0, .02, 0)
	bullet.spawnRotation = direction
	get_tree().current_scene.add_child(bullet)
	shoottimer.start()

################# ON-HIT #####################################
func flash():
	animatedSprite3d.material_override.set_shader_parameter("active", true)
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
	animatedSprite3d.material_override.set_shader_parameter("active", false)

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
	# print(_particle.death_particles.emitting)
	get_tree().current_scene.add_child(_particle_parent)
	died.emit()
	# $death/death_particles.restart()
	animatedSprite3d.material_override.set_shader_parameter("active", false)
	queue_free()
