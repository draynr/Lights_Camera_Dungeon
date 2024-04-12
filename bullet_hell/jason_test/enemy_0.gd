extends CharacterBody3D

var speed = .5
var accel = 1
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player = null
var player_spotted: bool = false
var ray_count = 5
var view_distance = 20.0
var view_angle = 45.0

@onready var line3d = $Line3D
@onready var los = $LineOfSight
@onready var raycast: RayCast3D = $RayCast3D

var see_player = false

func _ready():
	player = get_parent().get_node("player").position

func _physics_process(delta):
	# var dir = Vector3()

	see_player = check_los()

	# nav.target_position = get_parent().get_node("player").position
	# dir = nav.get_next_path_position() - global_position
	# dir = dir.normalized()

	# velocity = velocity.lerp(dir * speed, accel * delta)

	move_and_slide()

func check_los() -> bool:
	var player_pos = player.global_transform.origin
	var dir = (player_pos - global_transform.origin).normalized()

	var can_see = false
	
	for i in range(ray_count):
		var angle = lerp( - view_angle / 2, view_angle / 2, float(i) / (ray_count - 1))
		var rotated_direction: Vector3 = direction_to_player.rotated(Vector3.UP, deg_to_rad(angle))
		raycast.cast_to = rotated_direction * view_distance
		raycast.force_raycast_update()

	return can_see
