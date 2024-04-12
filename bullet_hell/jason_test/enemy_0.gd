extends CharacterBody3D

var speed = .5
var accel = 1
var hp = 5
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var player = null
var player_spotted: bool = false
var ray_count = 5
var view_distance = 20.0
var view_angle = 45.0

var target
const turn_speed = 2

@onready var line3d = $Line3D
@onready var los = $LineOfSight
@onready var raycast: RayCast3D = $LineOfSight
@onready var vision = $vision
@onready var shoottimer = $ShootTimer

enum {IDLE, ALERT}

var see_player = false
var state = IDLE

func _ready():
	pass

func _on_ShootTimer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("player"):
			print("hit motherfker")

func _physics_process(delta):
	if state == ALERT:
		# print("yoo")
		vision.look_at(target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(vision.rotation.y * turn_speed))
	move_and_slide()
func _on_area_3d_body_entered(body):
	# pass # Replace with function body.
	if body.is_in_group("player"):
		state = ALERT
		target = body
		shoottimer.start()

func _on_area_3d_body_exited(body):
	state = IDLE
	shoottimer.stop()

func take_damage(dmg):
	hp -= dmg;
	if hp <= 0:
		queue_free()