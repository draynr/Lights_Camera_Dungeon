extends CharacterBody3D

# const SPEED = 5.0
# const JUMP_VELOCITY = 4.5

var speed = 1
var target_velocity = Vector3()

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	
func _physics_process(delta):
	var dir = Vector3()
	dir = get_inputs(dir)
	target_velocity.x = dir.x * speed
	target_velocity.z = dir.z * speed
	velocity = target_velocity
	move_and_slide()
	if (dir == Vector3.ZERO):
		$AnimatedSprite3D.play("idle")
