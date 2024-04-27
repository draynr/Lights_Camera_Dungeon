extends CharacterBody3D

# const SPEED = 5.0
# const JUMP_VELOCITY = 4.5
const PROJECTILE_SCENE: PackedScene = preload ("res://jason_test/Projectile.tscn")
@onready var attack_timer: Timer = get_node("AttackTimer")

signal health_changed(value)

var attack_cd: float = 0.1
var proj_speed: float = 1

var speed = 2.2
var target_velocity = Vector3()

var hp: int = 5
var hearts: float = hp
# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	input_vector = input_vector.normalized()
	return input_vector

func get_click_vector() -> Vector3:
	var viewport = get_node("SubViewportContainer/SubViewport")
	var cam = viewport.get_node("Camera3D")
	var mouse_pos = viewport.get_mouse_position()
	var from = cam.project_ray_origin(mouse_pos)
	var dir = cam.project_ray_normal(mouse_pos) * 1000
	var plane = Plane(Vector3(0, -1, 0), -global_position.y)
	var intersect_pos = plane.intersects_ray(from, dir)
	
	var shoot_vec = intersect_pos - global_position
	var ret_vec = Vector3(shoot_vec.x, 0, shoot_vec.z)
	return ret_vec
	
func get_inputs(dir):
	if Input.is_action_pressed("move_down"):
		dir.z += 1
	if Input.is_action_pressed("move_up"):
		dir.z -= 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	# if dir != Vector3.ZERO:
	dir = dir.normalized()
	return dir

func shoot(shoot_vector: Vector3) -> void:
	var projectile: Area3D = PROJECTILE_SCENE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.launch(global_position, shoot_vector, proj_speed)

func handle_attack():
	if Input.is_mouse_button_pressed(1) and attack_timer.is_stopped():
		var click_vector = get_click_vector()
		shoot(click_vector.normalized())
		attack_timer.start(attack_cd)

func _physics_process(delta):
	var dir = Vector3()
	dir = get_inputs(dir)
	handle_attack()
	target_velocity.x = dir.x * speed
	target_velocity.z = dir.z * speed
	velocity = target_velocity
	move_and_slide()
	if (dir == Vector3.ZERO):
		$AnimatedSprite3D.play("idle")
func flash():
	$AnimatedSprite3D.material_override.set_shader_parameter("active", true)
	$HitTimer.start()
func take_damage(dmg):
	hp -= dmg;
	# flash()
	emit_signal("health_changed", hp)
	if hp <= 0:
		queue_free()
