extends CharacterBody3D

var speed = .5
var accel = 1
@onready var nav: NavigationAgent3D = $NavigationAgent3D

@onready var line3d = $Line3D

func _physics_process(delta):
	var dir = Vector3()
	# print(get_parent().get_node("player"))

	nav.target_position = get_parent().get_node("player").position
	# print(nav.target_position)
	dir = nav.get_next_path_position() - global_position
	dir = dir.normalized()

	velocity = velocity.lerp(dir * speed, accel * delta)

	move_and_slide()
