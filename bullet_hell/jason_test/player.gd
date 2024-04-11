extends CharacterBody3D

# const SPEED = 5.0
# const JUMP_VELOCITY = 4.5
const PROJECTILE_SCENE : PackedScene = preload("res://jason_test/Projectile.tscn")
@onready var attack_timer: Timer = get_node("AttackTimer")

var attack_speed: float = 0.5
var proj_speed: float = 100

var speed = 1
var target_velocity = Vector3()

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	input_vector = input_vector.normalized()
	return input_vector

func get_click_vector() -> Vector3:
	var viewport = get_viewport()
	var cam = viewport.get_camera_3d() #get_node("Camera3D2")
	var from = cam.global_position
	var to = from + cam.project_ray_normal(viewport.get_mouse_position())
	var rayParams:= PhysicsRayQueryParameters3D.create(from, to)
	# rayParams.collision_mask = collisionMask
	var world3d = get_world_3d()
	var result:Dictionary = world3d.direct_space_state.intersect_ray(rayParams)
	if !result.is_empty():
		var collision_pos = result['position']
		return collision_pos - global_position
	
	
	return Vector3.ZERO
	#return get_global_mouse_position() - global_position
	
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
	var projectile : Area3D = PROJECTILE_SCENE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.launch(global_position, shoot_vector, proj_speed)

func handle_attack():
	if Input.is_mouse_button_pressed(1):
		var click_vector = get_click_vector()
		shoot(click_vector.normalized())
		attack_timer.start(attack_speed)

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
