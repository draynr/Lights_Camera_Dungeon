extends CharacterBody3D

var speed = 2
var accel = 1
@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	var dir = Vector3()
	nav.target_position = get_tree().get_nodes_in_group("player")[0].position
	dir = nav.get_next_path_position() - global_position
	dir = dir.normalized()

	velocity = velocity.lerp(dir * speed, accel * delta)

	move_and_slide()
