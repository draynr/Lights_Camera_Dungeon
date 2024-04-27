extends CharacterBody3D

@export var ENEMY_BULLET: PackedScene = preload ("res://jason_test/enemy_bullet.tscn")

var speed = 0
var accel = 1
var hp = 5
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player = null
var player_spotted: bool = false
var ray_count = 5
var view_distance = 20.0
var view_angle = 45.0

var target
const turn_speed = 5

@onready var line3d = $Line3D
@onready var los = $LineOfSight
@onready var raycast: RayCast3D = $LineOfSight
@onready var vision = $vision
@onready var shoottimer = $ReloadTimer

enum {IDLE, ALERT}

var see_player = false
var state = IDLE

var delta_ang = 0

func _ready():
	pass

func _on_shoot_timer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("player"):
			print("hit motherfker")

func _physics_process(delta):
	var dir = Vector3.ZERO
	#var cast_count = int(angle_cone / angle_between_rays) + 1
	
	if state == ALERT:
		nav.target_position = get_parent().get_node("player").global_position
		
		var target_direction = target.global_position - global_position
		var target_rotation = Vector3(0, atan2(target_direction.x, target_direction.z), 0)
		rotation = rotation.lerp(target_rotation, turn_speed * delta)
		
		dir = nav.get_next_path_position() - global_position
		dir = dir.normalized()
		if shoottimer.is_stopped():
			shoot()
	velocity = velocity.lerp(dir * speed, accel * delta)
	move_and_slide()

func shoot() -> void:
	var direction = (get_parent().get_node("player").global_position - global_position).normalized()
	var subdiv360 = 10
	for i in range(0, 360, 360/subdiv360):
		var angle = deg_to_rad(i + delta_ang)
		delta_ang = (delta_ang + 10) % 360
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet.png")
		var offset_direction = direction.rotated(Vector3.UP, angle)
		#bullet.rotation.y = atan2(offset_direction.x, offset_direction.z)
		bullet.spawnCoords = global_position + Vector3(0, .05, 0)
		bullet.spawnRotation = offset_direction
		bullet.speed = 0.5
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)

	# flash()
	shoottimer.start()

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		state = ALERT
		target = body
		shoottimer.start()

func _on_area_3d_body_exited(body):
	# state = IDLE
	shoottimer.stop()

# func flash():
# 	$AnimatedSprite3D.material_override.set_shader_parameter("active", true)
# 	$HitTimer.start()

func take_damage(dmg):
	hp -= dmg;
	if hp <= 0:
		queue_free()
	else:
		state = ALERT

func _on_hit_timer_timeout():
	$AnimatedSprite3D.material_override.set_shader_parameter("active", false)
