extends CharacterBody3D

@export var ENEMY_BULLET: PackedScene = preload ("res://jason_test/enemy_bullet.tscn")

var rainbow_shader = preload ("res://jason_test/Tpot_rainbow.gdshader")
var pixelated_shader = preload ("res://jason_test/Tpot_pixelated.gdshader")
var wireframe_shader = preload ("res://jason_test/Tpot_wireframe.gdshader")
var speed = 0
var accel = 1

const maxhp = 150
var hp = maxhp

@onready var nav: NavigationAgent3D = $NavigationAgent3D
#var player = null
var player_spotted: bool = false
var ray_count = 5
var view_distance = 20.0
var view_angle = 45.0
@onready var projectile_texture = preload ("res://jason_test/Enemy_Bullet.png")

var target
const turn_speed = 5

@onready var los = $LineOfSight
@onready var raycast: RayCast3D = $LineOfSight
@onready var vision = $vision
@onready var shoottimer = $ReloadTimer
@onready var shoottimer2 = $ReloadTimer2
@onready var player = get_parent().get_node("player")

@onready var damaged_audio = player.get_node("Damaged_Enemy")
@onready var killed_audio = player.get_node("Killed_Enemy")

@onready var win_screen = preload ("res://Scene/win_screen.tscn")
enum {IDLE, ALERT}

var see_player = false
var state = IDLE
var stage = 1 # bullet pattern

var delta_ang = 0
var delta_ang2 = 0

func _ready():
	pass

#func _on_shoot_timer_timeout():
	#if raycast.is_colliding():
		#var hit = raycast.get_collider()
		#if hit.is_in_group("player"):
			#print("hit motherfker")

func _physics_process(delta):
	var target_direction = global_position - player.global_position
	var target_rotation = Vector3(0, atan2(target_direction.x, target_direction.z), 0)
	rotation.y = lerp_angle(rotation.y, target_rotation.y, 0.5)

	if state == ALERT:
		if stage == 1:
			if shoottimer.is_stopped():
				shootA1()
			if shoottimer2.is_stopped():
				shootA2()
		if stage == 2:
			if shoottimer.is_stopped():
				shootB1()
			if shoottimer2.is_stopped():
				shootB2()
		if stage == 3:
			if shoottimer.is_stopped():
				shootC1()
			if shoottimer2.is_stopped():
				shootC2()
	#velocity = velocity.lerp(dir * speed, accel * delta)
	move_and_slide()

func shootA1() -> void:
	var direction = Vector3(1, 0, 0)
	var subdiv360 = 9
	for i in range(0, 360, 360 / subdiv360):
		var angle = deg_to_rad(i + delta_ang)
		delta_ang = (delta_ang + 9) % 360
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet_classic.png")
		var offset_direction = direction.rotated(Vector3.UP, angle)
		bullet.spawnCoords = global_position + Vector3(0, -.05, 0)
		bullet.spawnRotation = offset_direction
		bullet.acceldir = 1.5 * offset_direction.cross(Vector3.UP)
		bullet.speed = 0.2
		bullet.lifetime = 20
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)

	# flash()
	shoottimer.start()

func shootA2() -> void:
	var direction = Vector3(1, 0, 0) # (get_parent().get_node("player").global_position - global_position).normalized()
	var subdiv360 = 30
	for i in range(0, 360, 360 / subdiv360):
		var angle = deg_to_rad(i)
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet_classic.png")
		var sprite = bullet.get_node("Sprite3D")
		sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
		sprite.material_override.set_shader_parameter("glow_strength", 2.0)

		var offset_direction = direction.rotated(Vector3.UP, angle)
		bullet.spawnCoords = global_position + Vector3(0, -.05, 0)
		bullet.spawnRotation = offset_direction
		bullet.speed = 0.5
		bullet.lifetime = 10
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)
	shoottimer2.start()

func shootB1() -> void:
	#var direction = (get_parent().get_node("player").global_position - global_position).normalized()
	var direction = (player.global_position - global_position).normalized()
	var subdiv = 13
	for i in range(0, 120, 120 / subdiv):
		delta_ang = (delta_ang + 10) % 360 - 180
		var angle = deg_to_rad(i + delta_ang)
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet_classic.png")
		var sprite = bullet.get_node("Sprite3D")
		sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
		sprite.material_override.set_shader_parameter("glow_strength", 2.0)
		var offset_direction = direction.rotated(Vector3.UP, angle)
		bullet.spawnCoords = global_position + Vector3(0, -.05, 0)
		bullet.spawnRotation = offset_direction
		bullet.acceldir = -1. * offset_direction.cross(Vector3.UP) + 1. * offset_direction
		bullet.speed = 0.15
		bullet.lifetime = 20
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)
	shoottimer.start()

func shootB2() -> void:
	#var direction = (get_parent().get_node("player").global_position - global_position).normalized()
	var direction = (player.global_position - global_position).normalized()
	var subdiv360 = 30
	for i in range(0, 360, 360 / subdiv360):
		var angle = deg_to_rad(i)
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet_classic.png")
		var sprite = bullet.get_node("Sprite3D")
		sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
		sprite.material_override.set_shader_parameter("glow_strength", 2.0)
		var offset_direction = direction.rotated(Vector3.UP, angle)
		bullet.spawnCoords = global_position + Vector3(0, -.05, 0)
		bullet.spawnRotation = offset_direction
		bullet.acceldir = 2. * direction # 0.01*offset_direction.cross(Vector3.UP)
		bullet.speed = 0.1
		bullet.lifetime = 10
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)
	shoottimer2.start()

func shootC1() -> void:
	var direction = Vector3(1, 0, 0)
	var subdiv360 = 24
	for i in range(0, 360, 360 / subdiv360):
		var angle = deg_to_rad(i)
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet_classic.png")
		var sprite = bullet.get_node("Sprite3D")
		sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
		sprite.material_override.set_shader_parameter("glow_strength", 2.0)
		var offset_direction = direction.rotated(Vector3.UP, angle)
		bullet.spawnCoords = global_position + Vector3(0, -.05, 0)
		bullet.spawnRotation = offset_direction
		delta_ang = (delta_ang + 1) % 88 + 1
		var ang_1 = pow(delta_ang, 0.5)
		var offset_cross = offset_direction.cross(Vector3.UP)
		bullet.acceldir = 0.0025 * (delta_ang * offset_direction + (1 - delta_ang) * offset_cross)
		bullet.speed = 0.2
		bullet.lifetime = 20
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)
	shoottimer.start()

func shootC2() -> void:
	var direction = (get_parent().get_node("player").global_position - global_position).normalized()
	var subdiv = 8
	for i in range(0, 30, 30 / subdiv):
		delta_ang2 = (delta_ang2 + 15) % 30
		var angle = deg_to_rad(i + delta_ang2)
		var bullet = ENEMY_BULLET.instantiate()
		bullet.projectile_texture = load("res://jason_test/Enemy_Bullet_classic.png")
		var sprite = bullet.get_node("Sprite3D")
		sprite.material_override.set_shader_parameter("sprite_texture", projectile_texture)
		sprite.material_override.set_shader_parameter("glow_strength", 2.0)
		var offset_direction = direction.rotated(Vector3.UP, angle)
		
		bullet.spawnCoords = global_position + Vector3(0, -.05, 0)
		bullet.spawnRotation = offset_direction
		bullet.acceldir = 0.005 * pow(i, 2) * direction
		bullet.speed = 0.1 * pow((88 - delta_ang), 0.5)
		bullet.lifetime = 20
		bullet.scale_bullet(0.5)
		get_tree().current_scene.add_child(bullet)
	shoottimer2.start()

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
	damaged_audio.play()
	if hp < maxhp / 3:
		stage = 3
		shoottimer.wait_time = 0.3
		shoottimer2.wait_time = 2
		var new_shader = ShaderMaterial.new()
		new_shader.set("shader", wireframe_shader)
		$Mesh.get_mesh().surface_set_material(0, new_shader)
	elif hp < 2 * maxhp / 3:
		stage = 2
		shoottimer.wait_time = 0.1
		shoottimer2.wait_time = 6
		# print($Mesh)
		var new_shader = ShaderMaterial.new()
		new_shader.set("shader", rainbow_shader)
		$Mesh.get_mesh().surface_set_material(0, new_shader)
		new_shader = ShaderMaterial.new()
		new_shader.set("shader", pixelated_shader)
		$Mesh.get_mesh().surface_get_material(0).set_next_pass(new_shader)

	if hp <= 0:
		killed_audio.play()
		# print("yoo")
		player.hp = 0
		queue_free()
		get_tree().change_scene_to_file("res://Scene/win_screen.tscn")
	else:
		state = ALERT

func _on_hit_timer_timeout():
	$AnimatedSprite3D.material_override.set_shader_parameter("active", false)
