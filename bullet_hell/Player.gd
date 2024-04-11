extends CharacterBody3D

var speed = 3.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#var velocity = Vector3()

func get_input() -> Vector3:
	var input_vector = Vector3()
	if Input.is_action_pressed("move_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.z += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	return input_vector.normalized()

func _physics_process(delta):
	var input_vector = get_input()
	velocity.x = input_vector.x * speed
	velocity.z = input_vector.z * speed
	# velocity.y += gravity * delta // don't really need this 
	move_and_slide();
	handle_animation(input_vector);

func handle_animation(input_vector: Vector3) -> void:
	if $AnimatedSprite3D:
		if input_vector.x > 0:
			$AnimatedSprite3D.play("walk_right")
		elif input_vector.x < 0:
			$AnimatedSprite3D.play("walk_left")
		elif input_vector.z < 0:
			$AnimatedSprite3D.play("walk_up")
		elif input_vector.z > 0:
			$AnimatedSprite3D.play("walk_down")
		else:
			$AnimatedSprite3D.play("idle")
